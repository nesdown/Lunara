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
        // Only register defaults if the key doesn't exist yet
        if UserDefaults.standard.object(forKey: "hasCompletedOnboarding") == nil {
            UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
        }
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
