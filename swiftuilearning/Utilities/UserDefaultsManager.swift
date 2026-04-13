//
//  UserDefaultsManager.swift
//  swiftuilearning
//
//  Created by Irshadali M T on 22/01/26.
//
import SwiftUI
import Foundation

final class UserDefaultsManager {

    static let shared = UserDefaultsManager()
    private init() {}

    private let defaults = UserDefaults.standard
    private let tutorialKey = "hasSeenTutorial"
    private let loginKey = "isLoggedIn"
    private let lastLearnedDateKey = "learningStats.lastLearnedDate"
    private let wordsLearnedCountKey = "learningStats.wordsLearnedCount"
    private let dayStreakKey = "learningStats.dayStreak"

    var hasSeenTutorial: Bool {
        get { defaults.bool(forKey: tutorialKey) }
        set { defaults.set(newValue, forKey: tutorialKey) }
    }

    var isLoggedIn: Bool {
        get { defaults.bool(forKey: loginKey) }
        set { defaults.set(newValue, forKey: loginKey) }
    }

    // MARK: - Learning stats (storage only; logic in LearningStatsManager)

    var lastLearnedDate: String? {
        get { defaults.string(forKey: lastLearnedDateKey) }
        set { defaults.set(newValue, forKey: lastLearnedDateKey) }
    }

    var wordsLearnedCount: Int {
        get { defaults.integer(forKey: wordsLearnedCountKey) }
        set { defaults.set(newValue, forKey: wordsLearnedCountKey) }
    }

    var dayStreak: Int {
        get { defaults.integer(forKey: dayStreakKey) }
        set { defaults.set(newValue, forKey: dayStreakKey) }
    }
}
