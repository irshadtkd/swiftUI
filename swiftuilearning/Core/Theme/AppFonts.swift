//
//  AppFonts.swift
//  swiftuilearning
//
//  Created by Irshadali M T on 22/01/26.
//

import SwiftUI

enum AppFonts {
    static func title() -> Font {
        .system(size: 24, weight: .bold)
    }
    static func body() -> Font {
        .system(size: 16)
    }
    // MARK: - Titles
    static var tutorialTitle: Font {
        .system(size: 26, weight: .bold)
    }
    // MARK: - Body
    static var tutorialSubtitle: Font {
        .system(size: 15, weight: .regular)
    }
    // MARK: - Buttons
    static var primaryButton: Font {
        .system(size: 16, weight: .semibold)
    }
    // MARK: - Navigation
    static var navigationAction: Font {
        .system(size: 14, weight: .medium)
    }
    
    // MARK: - Home Screen
    static var homeHeader: Font {
        .system(size: 14, weight: .medium)
    }
    
    static var homeDate: Font {
        .system(size: 12, weight: .regular)
    }
    
    static var wordTitle: Font {
        .system(size: 32, weight: .bold)
    }
    
    static var pronunciation: Font {
        .system(size: 14, weight: .regular)
    }
    
    static var wordType: Font {
        .system(size: 13, weight: .medium)
    }
    
    static var definition: Font {
        .system(size: 15, weight: .regular)
    }
    
    static var statNumber: Font {
        .system(size: 24, weight: .bold)
    }
    
    static var statLabel: Font {
        .system(size: 11, weight: .medium)
    }
    
    static var buttonLabel: Font {
        .system(size: 14, weight: .semibold)
    }
}
