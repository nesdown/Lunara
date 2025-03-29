//
//  lunaraApp.swift
//  lunara
//
//  Created by Bohdan Hlushko on 27.02.2025.
//

import SwiftUI

// Add these keys to Info.plist:
// NSUserTrackingUsageDescription - This identifier will be used to deliver personalized dream insights and improve your experience
// NSNotificationUsageDescription - Stay updated about your dream patterns and receive personalized insights

@main
struct lunaraApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    init() {
        // Register default values
        UserDefaults.standard.register(defaults: [
            "hasCompletedOnboarding": false
        ])
    }
    
    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                MainView()
            } else {
                OnboardingFlow()
            }
        }
    }
}
