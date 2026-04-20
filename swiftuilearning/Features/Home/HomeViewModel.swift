//
//  HomeViewModel.swift
//  swiftuilearning
//
//  Created by Irshadali M T on 22/01/26.
//

import SwiftUI
import SwiftData
import AVFoundation
import Combine

final class HomeViewModel: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    
    @Published var wordOfTheDay: WordOfTheDay?
    @Published var userStats: UserStats = UserStats()
    @Published var isLoading: Bool = false
    @Published var currentDate: String = ""
    @Published var errorMessage: String?
    @Published var showSafari: Bool = false
    @Published var safariURL: URL?
    @Published var isSpeaking: Bool = false
    @Published var isCurrentWordSaved: Bool = false
    
    // Side Menu State
    @Published var isMenuOpen: Bool = false
    @Published var userProfileImage: UIImage?
    @Published var isNotificationsEnabled: Bool = true
    @Published var userName: String = "User"
    
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    private let service = APIService.shared
    private let synthesizer = AVSpeechSynthesizer()
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
        synthesizer.delegate = self
        setupCurrentDate()
        isNotificationsEnabled = UserDefaultsManager.shared.notificationsEnabled
        observeNotificationToggle()
    }
    
    private func observeNotificationToggle() {
        $isNotificationsEnabled
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { enabled in
                UserDefaultsManager.shared.notificationsEnabled = enabled
                if enabled {
                    UIApplication.shared.registerForRemoteNotifications()
                } else {
                    UIApplication.shared.unregisterForRemoteNotifications()
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupCurrentDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM dd, yyyy"
        currentDate = formatter.string(from: Date())
    }
    
    // MARK: - Data Loading
    
    private static let apiDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.timeZone = TimeZone.current
        f.locale = Locale.current
        return f
    }()
    
    @MainActor
    func loadData(context: ModelContext?) async {
        if wordOfTheDay == nil {
            isLoading = true
        }
        errorMessage = nil
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let todayString = Self.apiDateFormatter.string(from: today)
        
        // DB-first: if we have context, try to load today's word from the local database
        if let ctx = context {
            do {
                if let dbWord = try WordDatabaseService.shared.fetchWordForDate(date: todayString, context: ctx) {
                    LearningStatsManager.shared.recordWordLearnedIfNeeded()
                    self.wordOfTheDay = dbWord
                    let savedCount = (try? WordDatabaseService.shared.fetchCount(context: ctx)) ?? self.userStats.savedWords
                    self.userStats = UserStats(
                        dayStreak: LearningStatsManager.shared.dayStreak,
                        wordsLearned: LearningStatsManager.shared.wordsLearnedCount,
                        savedWords: savedCount
                    )
                    self.isLoading = false
                    return
                }
            } catch {
                // Fall through to API on DB fetch failure
            }
        }
        
        // No context or no word for today in DB: call API
        let wordResult: WordOfTheDay? = await {
            do {
                return try await service.fetchWordOfTheDay()
            } catch {
                if let appError = error as? AppErrors {
                    self.errorMessage = appError.message
                } else {
                    self.errorMessage = AppStrings.Errors.apiError
                }
                return nil
            }
        }()
        
        if let fetchedWord = wordResult {
            LearningStatsManager.shared.recordWordLearnedIfNeeded()
        }
        
        self.wordOfTheDay = wordResult
        self.userStats = UserStats(
            dayStreak: LearningStatsManager.shared.dayStreak,
            wordsLearned: LearningStatsManager.shared.wordsLearnedCount,
            savedWords: self.userStats.savedWords
        )
        self.isLoading = false
    }
    
    func openSource() {
        guard let urlString = wordOfTheDay?.sourceUrl, let url = URL(string: urlString) else { return }
        safariURL = url
        showSafari = true
    }
    
    // MARK: - User Actions (local database)
    @MainActor
    func saveWord(context: ModelContext) async {
        guard let word = wordOfTheDay else { return }
        do {
            let alreadySaved = try WordDatabaseService.shared.exists(date: word.date, wordText: word.word, context: context)
            if alreadySaved {
                errorMessage = AppStrings.Home.wordAlreadySaved
                return
            }
            try WordDatabaseService.shared.save(word: word, context: context)
            isCurrentWordSaved = true
            let count = try WordDatabaseService.shared.fetchCount(context: context)
            userStats = UserStats(
                dayStreak: userStats.dayStreak,
                wordsLearned: userStats.wordsLearned,
                savedWords: count
            )
        } catch let appError as AppErrors {
            errorMessage = appError.message
            print("Error saving word: \(appError)")
        } catch {
            errorMessage = AppStrings.Errors.saveWordFailed
            print("Error saving word: \(error)")
        }
    }
    
    func saveWordSync(context: ModelContext) {
        Task {
            await saveWord(context: context)
        }
    }
    
    /// Updates the Saved Words count from the local database. Call from the view when it appears and after refresh.
    @MainActor
    func updateSavedWordsCount(context: ModelContext) {
        do {
            let count = try WordDatabaseService.shared.fetchCount(context: context)
            userStats = UserStats(
                dayStreak: userStats.dayStreak,
                wordsLearned: userStats.wordsLearned,
                savedWords: count
            )
        } catch {
            // Leave existing savedWords value on fetch failure
        }
    }
    
    /// Updates whether the current word is saved (for filled bookmark and "Already saved" toast). Call from the view when it appears and after refresh.
    @MainActor
    func updateIsCurrentWordSaved(context: ModelContext) {
        guard let word = wordOfTheDay else {
            isCurrentWordSaved = false
            return
        }
        do {
            isCurrentWordSaved = try WordDatabaseService.shared.exists(date: word.date, wordText: word.word, context: context)
        } catch {
            isCurrentWordSaved = false
        }
    }
    
    func speak(word: String) {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        let utterance = AVSpeechUtterance(string: word)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
    }
    
    // MARK: - AVSpeechSynthesizerDelegate
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isSpeaking = true
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isSpeaking = false
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isSpeaking = false
        }
    }
    
    func shareWord() {
        // TODO: Implement share functionality
        guard let word = wordOfTheDay else { return }
        print("Share word: \(word.word)")
    }
    
    func refreshData(context: ModelContext?) {
        Task {
            await loadData(context: context)
        }
    }
    
    func logout(appState: AppState) {
        UserDefaultsManager.shared.isLoggedIn = false
        appState.flow = .login
    }
}
