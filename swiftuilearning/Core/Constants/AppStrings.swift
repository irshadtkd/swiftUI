//
//  AppStrings.swift
//  swiftuilearning
//
//  Created by Irshadali M T on 22/01/26.
//

import SwiftUI

enum AppStrings {
    
    static let tutorialTitle = "Welcome to SwiftUI Learning"
    static let tutorialDescription = "Learn SwiftUI with MVVM architecture"
    static let continueText = "Continue"
    static let loginTitle = "Login"
    static let usernamePlaceholder = "Username"
    static let passwordPlaceholder = "Password"
    static let loginButton = "Login"
    static let homeTitle = "Home"
    
    struct Tutorial {
        static let skip = "Skip"
        static let next = "Next"
        static let getStarted = "Get Started"
        static let pages: [TutorialPage] = [
            TutorialPage(
                icon: "book",
                title: "Learn New Words Daily",
                subtitle: "Discover a new word every day with meanings, examples, and pronunciation."
            ),
            TutorialPage(
                icon: "bell",
                title: "Daily Reminders",
                subtitle: "Never miss a word with our smart notification system."
            ),
            TutorialPage(
                icon: "chart.line.uptrend.xyaxis",
                title: "Track Your Progress",
                subtitle: "Build your vocabulary and track your learning journey over time."
            )
        ]
    }
    
    enum Home {
        static let wordOfTheDay = "Word of the Day"
        static let saveWord = "Save Word"
        static let share = "Share"
        static let dayStreak = "Day Streak"
        static let wordsLearned = "Words\nLearned"
        static let savedWords = "Saved Words"
        static let more = "More"
        static let wordAlreadySaved = "Already saved"
        static let example = "Example"
        static let etymology = "Etymology"
    }
    
    enum Errors {
        static let genericTitle = "Error"
        static let networkError = "Network connection failed. Please check your internet."
        static let apiError = "Failed to load Word of the Day. Please try again later."
        static let dataError = "Invalid data received from server."
        static let invalidURL = "Invalid Word of the Day URL."
        static let saveWordFailed = "Failed to save word. Please try again."
        static let databaseSaveFailed = "Could not save word to your list."
        static let databaseFetchFailed = "Could not load saved words."
        static let databaseDeleteFailed = "Could not remove saved word."
    }
    
    enum SavedWords {
        static let screenTitle = "Saved Words"
        static let emptyMessage = "No saved words"
        static let retry = "Retry"
        static let removeWord = "Remove Word"
    }
    
    enum Login {
        static let welcomeTitle = "Welcome Back!"
        static let welcomeSubtitle = "Enter your mobile number to continue"
        static let mobileLabel = "Mobile Number"
        static let sendOTP = "Send OTP"
        static let verifyTitle = "Verify OTP"
        static let verifySubtitlePrefix = "Enter the 6-digit code sent to"
        static let resendOTP = "Resend OTP in"
        static let termsText = "By continuing, you agree to our Terms of Service and Privacy Policy"
    }
}

struct TutorialPage {
    let icon: String
    let title: String
    let subtitle: String
}
