//
//  AppState.swift
//  swiftuilearning
//
//  Created by Irshadali M T on 22/01/26.
//

import SwiftUI

final class AppState: ObservableObject {
    
    enum AppFlow {
        case tutorial
        case login
        case home
    }
    
    @Published var flow: AppFlow = .tutorial
    
    init() {
        loadInitialState()
    }
    
    private func loadInitialState() {
        let hasSeenTutorial = UserDefaultsManager.shared.hasSeenTutorial
        let isLoggedIn = UserDefaultsManager.shared.isLoggedIn
        
        if !hasSeenTutorial {
            flow = .tutorial
        } else if !isLoggedIn {
            flow = .login
        } else {
            flow = .home
        }
    }
}
