//
//  TutorialViewModel.swift
//  swiftuilearning
//
//  Created by Irshadali M T on 22/01/26.
//

import SwiftUI

final class TutorialViewModel: ObservableObject {
    
    @Published var currentPage = 0
    
    let totalPages = AppStrings.Tutorial.pages.count
    
    var isLastPage: Bool {
        currentPage == totalPages - 1
    }
    
    func skip(appState: AppState) {
        completeTutorial(appState: appState)
    }
    
    func next(appState: AppState) {
        if isLastPage {
            completeTutorial(appState: appState)
        } else {
            currentPage += 1
        }
    }
    
    private func completeTutorial(appState: AppState) {
        UserDefaultsManager.shared.hasSeenTutorial = true
        appState.flow = .login
    }
}
