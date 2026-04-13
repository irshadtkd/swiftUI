//
//  swiftuilearningApp.swift
//  swiftuilearning
//
//  Created by Irshadali M T on 22/01/26.
//

import SwiftUI
import SwiftData
import Firebase
import FirebaseCore
import FirebaseAuth

@main
struct swiftuilearningApp: App {
    // Add this line to register the delegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            AppRouter().environmentObject(appState)
        }
        .modelContainer(for: [WordOfTheDay.self])
    }
}
