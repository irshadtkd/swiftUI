//
//  ShimmerView.swift
//  swiftuilearning
//
//  Created by Irshadali M T on 30/01/26.
//

import SwiftUI

/// A view that applies a shimmer animation (sliding gradient) to its content.
struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0),
                            Color.white.opacity(0.4),
                            Color.white.opacity(0)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geometry.size.width * 0.6)
                    .offset(x: -geometry.size.width * 0.6 + phase * geometry.size.width * 1.2)
                }
                    .mask(content)
            )
            .onAppear {
                withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

extension View {
    func shimmer() -> some View {
        modifier(ShimmerModifier())
    }
}

/// Skeleton row mimicking Saved Words list item: date, word, description.
struct SavedWordsListShimmerRow: View {
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.smallPadding) {
            RoundedRectangle(cornerRadius: 4)
                .fill(AppColors.cardBorder)
                .frame(width: 80, height: 12)
            RoundedRectangle(cornerRadius: 4)
                .fill(AppColors.cardBorder)
                .frame(width: 160, height: 20)
            RoundedRectangle(cornerRadius: 4)
                .fill(AppColors.cardBorder)
                .frame(maxWidth: .infinity)
                .frame(height: 14)
        }
        .padding(AppTheme.padding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
        .shimmer()
    }
}

/// Multiple shimmer rows for Saved Words list loading state.
struct SavedWordsListShimmer: View {
    private let rowCount = 6
    
    var body: some View {
        VStack(spacing: AppTheme.mediumPadding) {
            ForEach(0..<rowCount, id: \.self) { _ in
                SavedWordsListShimmerRow()
            }
        }
        .padding(.horizontal, AppTheme.largePadding)
    }
}
