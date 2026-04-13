//
//  LearningStatsManager.swift
//  swiftuilearning
//
//  Business logic for Words Learned and Day Streak. All UserDefaults storage is in UserDefaultsManager.
//

import Foundation

final class LearningStatsManager {

    static let shared = LearningStatsManager()
    private init() {}

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.timeZone = TimeZone.current
        f.locale = Locale.current
        return f
    }()

    var wordsLearnedCount: Int {
        UserDefaultsManager.shared.wordsLearnedCount
    }

    var dayStreak: Int {
        UserDefaultsManager.shared.dayStreak
    }

    /// Call when the user opens home and the word loads successfully. At most one word per calendar day is counted; streak is updated for consecutive days. Reads and writes via UserDefaultsManager.
    func recordWordLearnedIfNeeded() {
        let manager = UserDefaultsManager.shared
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let todayString = Self.dateFormatter.string(from: today)

        guard manager.lastLearnedDate != todayString else {
            return
        }

        let last = manager.lastLearnedDate
        manager.wordsLearnedCount += 1

        if last == nil {
            manager.dayStreak = 1
        } else {
            guard let yesterday = calendar.date(byAdding: .day, value: -1, to: today) else {
                manager.dayStreak = 1
                manager.lastLearnedDate = todayString
                return
            }
            let yesterdayString = Self.dateFormatter.string(from: yesterday)
            if last == yesterdayString {
                manager.dayStreak += 1
            } else {
                manager.dayStreak = 1
            }
        }

        manager.lastLearnedDate = todayString
    }
}
