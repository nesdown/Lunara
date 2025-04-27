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
    @StateObject private var subscriptionService = SubscriptionService.shared
    
    init() {
        // Only register defaults if the key doesn't exist yet
        if UserDefaults.standard.object(forKey: "hasCompletedOnboarding") == nil {
            UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
        }
        
        // Initialize app version for tracking updates
        setupAppVersion()
    }
    
    private func setupAppVersion() {
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let lastVersionKey = "lastAppVersion"
        
        // Check if this is a new version
        if let lastVersion = UserDefaults.standard.string(forKey: lastVersionKey),
           lastVersion != currentVersion {
            // Version changed, reset free attempts counter
            SubscriptionService.shared.resetAllFreeAttempts()
        }
        
        // Save current version
        UserDefaults.standard.set(currentVersion, forKey: lastVersionKey)
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
