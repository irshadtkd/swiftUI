//
//  TutorialView.swift
//  swiftuilearning
//
//  Created by Irshadali M T on 22/01/26.
//

import SwiftUI

struct TutorialView: View {
    
    @StateObject private var viewModel = TutorialViewModel()
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                
                // Skip Button
                HStack {
                    Spacer()
                    Button(AppStrings.Tutorial.skip) {
                        viewModel.skip(appState: appState)
                    }
                    .font(AppFonts.navigationAction)
                    .foregroundColor(AppColors.textWhite)
                }
                .padding()
                
                Spacer()
                
                TabView(selection: $viewModel.currentPage) {
                    ForEach(0..<AppStrings.Tutorial.pages.count, id: \.self) { index in
                        tutorialPageView(page: AppStrings.Tutorial.pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                Spacer()
                
                // Page Indicator
                HStack(spacing: 8) {
                    ForEach(0..<viewModel.totalPages, id: \.self) { index in
                        Capsule()
                            .fill(index == viewModel.currentPage ? .white : .white.opacity(0.4))
                            .frame(width: index == viewModel.currentPage ? 20 : 6, height: 6)
                    }
                }
                
                // Bottom Button
                Button {
                    viewModel.next(appState: appState)
                } label: {
                    Text(viewModel.isLastPage
                         ? AppStrings.Tutorial.getStarted
                         : AppStrings.Tutorial.next)
                    .font(AppFonts.primaryButton)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppColors.buttonBackground)
                    .foregroundColor(AppColors.buttonText)
                    .cornerRadius(14)
                }
                .padding()
            }
        }
    }
    
    // MARK: - Page Content
    private func tutorialPageView(page: TutorialPage) -> some View {
        VStack(spacing: 20) {
            
            Image(systemName: page.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.white)
            
            Text(page.title)
                .font(AppFonts.tutorialTitle)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text(page.subtitle)
                .font(AppFonts.tutorialSubtitle)
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
    }
}
