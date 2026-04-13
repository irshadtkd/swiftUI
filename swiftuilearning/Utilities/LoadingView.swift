//
//  LoadingView.swift
//  swiftuilearning
//
//  Created by Irshadali M T on 27/01/26.
//
//  Common loading indicators used throughout the app
//  Usage:
//  - LoadingView() - Basic spinner with text
//  - FullScreenLoadingView() - Full screen with gradient background
//  - ContentLoadingView() - For content areas
//  - LoadingOverlayView() - Centered overlay with card background

import SwiftUI

// MARK: - Basic Loading Indicator

/// Basic animated loading spinner with "Loading..." text
/// Can be used anywhere in the app
struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                // Outer circle
                Circle()
                    .stroke(AppColors.cardBorder, lineWidth: 3)
                    .frame(width: 60, height: 60)
                
                // Animated circle
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(
                        AppColors.textPrimary,
                        style: StrokeStyle(lineWidth: 3, lineCap: .round)
                    )
                    .frame(width: 60, height: 60)
                    .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                    .animation(
                        Animation.linear(duration: 1)
                            .repeatForever(autoreverses: false),
                        value: isAnimating
                    )
            }
            
            Text("Loading...")
                .font(AppFonts.buttonLabel)
                .foregroundColor(AppColors.textSecondary)
        }
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Full Screen Loading

/// Full screen loading view with gradient background
/// Use for initial app/screen loads
struct FullScreenLoadingView: View {
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [AppColors.gradientStart, AppColors.gradientEnd]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            LoadingView()
        }
    }
}

// MARK: - Content Loading

/// Loading view for content areas
/// Use when replacing content with loading state
struct ContentLoadingView: View {
    var body: some View {
        VStack(spacing: 20) {
            LoadingView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Loading Overlay

/// Centered loading overlay with semi-transparent card background
/// Use for API calls that don't require full screen blocking
struct LoadingOverlayView: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                LoadingView()
                    .padding(30)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(AppColors.cardBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(AppColors.cardBorder, lineWidth: 1)
                            )
                    )
                Spacer()
            }
            Spacer()
        }
    }
}

// MARK: - Previews

#Preview("Loading Indicator") {
    LoadingView()
        .padding()
        .background(AppColors.gradientStart)
}

#Preview("Full Screen Loading") {
    FullScreenLoadingView()
}

#Preview("Content Loading") {
    ContentLoadingView()
        .background(AppColors.gradientStart)
}

#Preview("Loading Overlay") {
    ZStack {
        LinearGradient(
            gradient: Gradient(colors: [AppColors.gradientStart, AppColors.gradientEnd]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        
        LoadingOverlayView()
    }
}
