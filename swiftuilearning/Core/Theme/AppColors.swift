//
//  AppColors.swift
//  swiftuilearning
//
//  Created by Irshadali M T on 22/01/26.
//

import SwiftUI

enum AppColors {
    static let primary = Color.purple
    static let secondary = Color(red: 0.55, green: 0.1, blue: 0.85)
    static let accent = Color(red: 1.0, green: 0.84, blue: 0.0) // Gold/Yellow
    static let textWhite = Color.white
    static let buttonBackground = Color.white
    static let buttonText = Color.purple
    
    // MARK: - Home Screen Colors
    static let gradientStart = Color(red: 0.45, green: 0.1, blue: 0.75) // Deep purple
    static let gradientEnd = Color(red: 0.65, green: 0.2, blue: 0.95) // Lighter purple
    static let cardBackground = Color.white.opacity(0.15)
    static let cardBorder = Color.white.opacity(0.3)
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.8)
    static let textTertiary = Color.white.opacity(0.6)
    static let statCardBackground = Color.white.opacity(0.2)
    static let iconBackground = Color.white.opacity(0.2)
}
