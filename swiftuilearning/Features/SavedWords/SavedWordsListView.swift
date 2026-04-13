//
//  SavedWordsListView.swift
//  swiftuilearning
//
//  Created by Irshadali M T on 28/01/26.
//

import SwiftUI
import SwiftData

struct SavedWordsListView: View {
    @StateObject private var viewModel = SavedWordsListViewModel()
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [AppColors.gradientStart, AppColors.gradientEnd]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            if viewModel.isLoading && viewModel.items.isEmpty {
                SavedWordsListShimmer()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = viewModel.errorMessage, viewModel.items.isEmpty {
                errorView(message: error)
            } else if viewModel.items.isEmpty {
                emptyView
            } else {
                listContent
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(AppColors.gradientStart, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(AppStrings.SavedWords.screenTitle)
                    .font(AppFonts.navigationAction)
                    .foregroundColor(AppColors.textWhite)
            }
        }
        .tint(AppColors.textWhite)
        .onAppear {
            viewModel.loadFirstPage(context: modelContext)
        }
        .toast(text: $viewModel.errorMessage)
    }
    
    private var listContent: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: AppTheme.mediumPadding) {
                ForEach(viewModel.items) { word in
                    NavigationLink(destination: SavedWordDetailView(word: word)) {
                        listTile(word: word)
                    }
                    .buttonStyle(.plain)
                }
                if viewModel.hasMore && !viewModel.items.isEmpty {
                    Color.clear
                        .frame(height: 1)
                        .onAppear {
                            viewModel.loadNextPage(context: modelContext)
                        }
                }
            }
            .padding(.horizontal, AppTheme.largePadding)
            .padding(.vertical, AppTheme.largePadding)
        }
    }
    
    private func listTile(word: WordOfTheDay) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.smallPadding) {
            Text(word.date)
                .font(AppFonts.homeDate)
                .foregroundColor(AppColors.textSecondary)
            Text(word.word)
                .font(AppFonts.wordTitle)
                .foregroundColor(AppColors.textPrimary)
                .lineLimit(1)
            Text(word.meaning)
                .font(AppFonts.definition)
                .foregroundColor(AppColors.textSecondary)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppTheme.padding)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private var emptyView: some View {
        VStack(spacing: AppTheme.padding) {
            Text(AppStrings.SavedWords.emptyMessage)
                .font(AppFonts.definition)
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func errorView(message: String) -> some View {
        VStack(spacing: AppTheme.largePadding) {
            Text(message)
                .font(AppFonts.definition)
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Button(AppStrings.SavedWords.retry) {
                viewModel.retry(context: modelContext)
            }
            .font(AppFonts.buttonLabel)
            .foregroundColor(AppColors.textPrimary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
