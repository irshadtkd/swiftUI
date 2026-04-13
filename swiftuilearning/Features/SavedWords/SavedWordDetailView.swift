//
//  SavedWordDetailView.swift
//  swiftuilearning
//
//  Created by Irshadali M T on 29/01/26.
//

import SwiftUI
import SwiftData
import AVFoundation

private final class DetailSpeechHelper: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    @Published var isSpeaking = false
    private let synthesizer = AVSpeechSynthesizer()
    
    override init() {
        super.init()
        synthesizer.delegate = self
    }
    
    func speak(word: String) {
        if synthesizer.isSpeaking { synthesizer.stopSpeaking(at: .immediate) }
        let utterance = AVSpeechUtterance(string: word)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        DispatchQueue.main.async { self.isSpeaking = true }
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async { self.isSpeaking = false }
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        DispatchQueue.main.async { self.isSpeaking = false }
    }
}

struct SavedWordDetailView: View {
    let word: WordOfTheDay
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showWebView = false
    @State private var webViewURL: URL?
    @State private var isSharing = false
    @State private var shareItems: [Any] = []
    @State private var errorMessage: String?
    @State private var isRemoving = false
    @StateObject private var speechHelper = DetailSpeechHelper()
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [AppColors.gradientStart, AppColors.gradientEnd]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                wordCardContent
                    .padding(.horizontal, AppTheme.largePadding)
                    .padding(.vertical, AppTheme.largePadding)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(AppColors.gradientStart, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .tint(AppColors.textWhite)
        .toast(text: $errorMessage)
        .sheet(isPresented: $showWebView) {
            if let url = webViewURL {
                InAppWebView(url: url)
            }
        }
        .sheet(isPresented: $isSharing) {
            ActivityViewController(activityItems: shareItems)
        }
    }
    
    private var wordCardContent: some View {
        VStack(alignment: .leading, spacing: AppTheme.padding) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(word.word)
                        .font(AppFonts.wordTitle)
                        .foregroundColor(AppColors.textPrimary)
                }
                Spacer()
                Button(action: { speechHelper.speak(word: word.word) }) {
                    Image(systemName: speechHelper.isSpeaking ? "speaker.wave.3.fill" : "speaker.wave.2.fill")
                        .font(.system(size: 20))
                        .foregroundColor(speechHelper.isSpeaking ? AppColors.accent : AppColors.textPrimary)
                        .scaleEffect(speechHelper.isSpeaking ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: speechHelper.isSpeaking)
                }
            }
            
            Text(word.partOfSpeech)
                .font(AppFonts.wordType)
                .foregroundColor(AppColors.textSecondary)
                .textCase(.uppercase)
            
            Text(word.meaning)
                .font(AppFonts.definition)
                .foregroundColor(AppColors.textPrimary)
                .lineSpacing(4)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(AppStrings.Home.example)
                    .font(AppFonts.wordType)
                    .foregroundColor(AppColors.textSecondary)
                    .italic()
                Text(word.example)
                    .font(AppFonts.definition)
                    .foregroundColor(AppColors.textSecondary)
                    .lineSpacing(4)
            }
            .padding(.top, AppTheme.smallPadding)
            
            if !word.etymology.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text(AppStrings.Home.etymology)
                        .font(AppFonts.wordType)
                        .foregroundColor(AppColors.textSecondary)
                        .italic()
                    Text(word.etymology)
                        .font(AppFonts.definition)
                        .foregroundColor(AppColors.textSecondary)
                        .lineSpacing(4)
                }
                .padding(.top, AppTheme.smallPadding)
            }
            
            HStack(spacing: AppTheme.mediumPadding) {
                Button(action: { removeWord() }) {
                    HStack(spacing: 5) {
                        if isRemoving {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .tint(AppColors.textPrimary)
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "trash")
                                .font(.system(size: 14, weight: .medium))
                        }
                        Text(AppStrings.SavedWords.removeWord)
                            .font(AppFonts.buttonLabel)
                    }
                    .foregroundColor(AppColors.textPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(AppColors.cardBackground)
                    .cornerRadius(AppTheme.cornerRadius)
                }
                .disabled(isRemoving)
                
                Button(action: { prepareShare() }) {
                    HStack(spacing: 5) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 14, weight: .medium))
                        Text(AppStrings.Home.share)
                            .font(AppFonts.buttonLabel)
                    }
                    .foregroundColor(AppColors.textPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(AppColors.cardBackground)
                    .cornerRadius(AppTheme.cornerRadius)
                }
                
                Button(action: { openSource() }) {
                    HStack(spacing: 5) {
                        Image(systemName: "link")
                            .font(.system(size: 14, weight: .medium))
                        Text(AppStrings.Home.more)
                            .font(AppFonts.buttonLabel)
                    }
                    .foregroundColor(AppColors.textPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(AppColors.cardBackground)
                    .cornerRadius(AppTheme.cornerRadius)
                }
            }
            .padding(.top, AppTheme.smallPadding)
            
            HStack {
                Text(word.source)
                Spacer()
                Text(word.date)
            }
            .font(.caption)
            .foregroundColor(AppColors.textSecondary)
            .padding(.top, 4)
        }
        .padding(AppTheme.largePadding)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private func prepareShare() {
        shareItems = [WordShareHelper.shareText(for: word)]
        isSharing = true
    }
    
    private func openSource() {
        guard let url = URL(string: word.sourceUrl) else { return }
        webViewURL = url
        showWebView = true
    }
    
    private func removeWord() {
        guard !isRemoving else { return }
        isRemoving = true
        errorMessage = nil
        do {
            try WordDatabaseService.shared.delete(id: word.id, context: modelContext)
            dismiss()
        } catch let appError as AppErrors {
            errorMessage = appError.message
            isRemoving = false
        } catch {
            errorMessage = AppStrings.Errors.databaseDeleteFailed
            isRemoving = false
        }
    }
}
