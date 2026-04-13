//
//  HomeView.swift
//  swiftuilearning
//
//  Created by Irshadali M T on 22/01/26.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject var appState: AppState
    @Environment(\.modelContext) private var modelContext
    @State private var isSharing: Bool = false
    @State private var shareItems: [Any] = []
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [AppColors.gradientStart, AppColors.gradientEnd]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            if viewModel.isLoading && viewModel.wordOfTheDay == nil {
                // Show full screen loading on initial load
                ContentLoadingView()
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: AppTheme.largePadding) {
                        // Header
                        headerView
                        // Word of the Day Card
                        if let word = viewModel.wordOfTheDay {
                            wordCardView(word: word)
                        } else if !viewModel.isLoading {
                            blankWordCardView
                        }
                        // Stats Cards
                        statsCardsView
                    }
                    .padding(.horizontal, AppTheme.largePadding)
                    .padding(.vertical, AppTheme.largePadding)
                }
                .refreshable {
                    await viewModel.loadData(context: modelContext)
                    viewModel.updateSavedWordsCount(context: modelContext)
                    viewModel.updateIsCurrentWordSaved(context: modelContext)
                }
            }
            
            // Loading overlay for refresh
            if viewModel.isLoading && viewModel.wordOfTheDay != nil {
                LoadingOverlayView()
            }
            
            // Side Menu
            SideMenuView(
                isShowing: $viewModel.isMenuOpen,
                profileImage: $viewModel.userProfileImage,
                isNotificationsOn: $viewModel.isNotificationsEnabled,
                userName: viewModel.userName,
                appVersion: viewModel.appVersion,
                onLogout: {
                    viewModel.logout(appState: appState)
                }
            )
        }
        .onAppear {
            Task {
                await viewModel.loadData(context: modelContext)
                viewModel.updateSavedWordsCount(context: modelContext)
                viewModel.updateIsCurrentWordSaved(context: modelContext)
            }
        }
        .onChange(of: viewModel.wordOfTheDay?.id) {
            viewModel.updateIsCurrentWordSaved(context: modelContext)
        }
        .toast(text: $viewModel.errorMessage)
        .sheet(isPresented: $viewModel.showSafari) {
            if let url = viewModel.safariURL {
                InAppWebView(url: url)
            }
        }
        .sheet(isPresented: $isSharing) {
            ActivityViewController(activityItems: shareItems)
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(AppStrings.Home.wordOfTheDay)
                    .font(AppFonts.homeHeader)
                    .foregroundColor(AppColors.textPrimary)
                
                Text(viewModel.currentDate)
                    .font(AppFonts.homeDate)
                    .foregroundColor(AppColors.textSecondary)
            }
            Spacer()
            Button(action: {
                withAnimation {
                    viewModel.isMenuOpen = true
                }
            }) {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(AppColors.textPrimary)
            }
        }
    }
    
    // MARK: - Blank Word Card (when API fails)
    private var blankWordCardView: some View {
        Color.clear
            .frame(minHeight: 120)
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
    
    // MARK: - Word Card View
    private func wordCardView(word: WordOfTheDay) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.padding) {
            // Word title
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(word.word)
                        .font(AppFonts.wordTitle)
                        .foregroundColor(AppColors.textPrimary)
                    // Pronunciation removed as API doesn't provide it
                }
                Spacer()
                
                // Pronunciation Icon
                Button(action: {
                    viewModel.speak(word: word.word)
                }) {
                    Image(systemName: viewModel.isSpeaking ? "speaker.wave.3.fill" : "speaker.wave.2.fill")
                        .font(.system(size: 20))
                        .foregroundColor(viewModel.isSpeaking ? AppColors.accent : AppColors.textPrimary)
                        .scaleEffect(viewModel.isSpeaking ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: viewModel.isSpeaking)
                }
                
            }
            
            // Word type (Part of Speech)
            Text(word.partOfSpeech)
                .font(AppFonts.wordType)
                .foregroundColor(AppColors.textSecondary)
                .textCase(.uppercase)
            
            // Meaning
            Text(word.meaning)
                .font(AppFonts.definition)
                .foregroundColor(AppColors.textPrimary)
                .lineSpacing(4)
            
            // Example
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
            
            // Etymology
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
            
            // Action buttons
            HStack(spacing: AppTheme.mediumPadding) {
                Button(action: {
                    viewModel.saveWordSync(context: modelContext)
                }) {
                    HStack(spacing: 5) {
                        Image(systemName: viewModel.isCurrentWordSaved ? "bookmark.fill" : "bookmark")
                            .font(.system(size: 14, weight: .medium))
                        Text(AppStrings.Home.saveWord)
                            .font(AppFonts.buttonLabel)
                    }
                    .foregroundColor(AppColors.textPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(AppColors.cardBackground)
                    .cornerRadius(AppTheme.cornerRadius)
                }
                
                Button(action: {
                    prepareShareContent(word: word)
                }) {
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
                
                Button(action: {
                    viewModel.openSource()
                }) {
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
            
            // Source and Date
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
    
    private func prepareShareContent(word: WordOfTheDay) {
        shareItems = [WordShareHelper.shareText(for: word)]
        isSharing = true
    }
    
    // MARK: - Stats Cards View
    private var statsCardsView: some View {
        HStack(spacing: AppTheme.mediumPadding) {
            statCard(
                number: "\(viewModel.userStats.dayStreak)",
                label: AppStrings.Home.dayStreak
            )
            
            statCard(
                number: "\(viewModel.userStats.wordsLearned)",
                label: AppStrings.Home.wordsLearned
            )
            
            NavigationLink(destination: SavedWordsListView()) {
                statCard(
                    number: "\(viewModel.userStats.savedWords)",
                    label: AppStrings.Home.savedWords
                )
            }
            .buttonStyle(.plain)
        }
    }
    
    // MARK: - Stat Card Component
    private func statCard(number: String, label: String) -> some View {
        VStack(spacing: 8) {
            Text(number)
                .font(AppFonts.statNumber)
                .foregroundColor(AppColors.textPrimary)
            
            Text(label)
                .font(AppFonts.statLabel)
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100) // Fixed height for uniformity
        .padding(.vertical, AppTheme.padding)
        .padding(.horizontal, AppTheme.smallPadding)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.statCardCornerRadius)
                .fill(AppColors.statCardBackground)
        )
    }
}
