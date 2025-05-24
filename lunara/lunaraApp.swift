//
//  lunaraApp.swift
//  lunara
//
//  Created by Bohdan Hlushko on 27.02.2025.
//

import SwiftUI
import UserNotifications

// Add these keys to Info.plist:
// NSUserTrackingUsageDescription - This identifier will be used to deliver personalized dream insights and improve your experience
// NSNotificationUsageDescription - Stay updated about your dream patterns and receive personalized insights

@main
struct lunaraApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @StateObject private var subscriptionService = SubscriptionService.shared
    @StateObject private var ratingService = RatingService.shared
    @StateObject private var streakService = StreakService.shared
    
    // Flag to prevent scheduling notifications multiple times during the same app session
    private static var hasScheduledNotifications = false
    
    init() {
        // Only register defaults if the key doesn't exist yet
        if UserDefaults.standard.object(forKey: "hasCompletedOnboarding") == nil {
            UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
        }
        
        // Initialize app version for tracking updates
        setupAppVersion()
        
        // Set up UNUserNotificationCenter delegate for handling notifications
        UNUserNotificationCenter.current().delegate = NotificationDelegate.shared
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
                    .withCustomRating() // Apply our custom rating view
                    .onAppear {
                        // Check if we should show rating prompt on app launch
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            ratingService.checkAndRequestReview()
                        }
                        
                        // Check and update streak status
                        checkAndUpdateStreak()
                    }
            } else {
                OnboardingFlow()
            }
        }
    }
    
    // Check and update streak reminders when app launches
    private func checkAndUpdateStreak() {
        // Check if reminders are enabled and schedule them only if not already done
        if UserDefaults.standard.bool(forKey: "isReminderEnabled") && !Self.hasScheduledNotifications {
            Self.hasScheduledNotifications = true
            StreakReminderService.shared.scheduleAllNotifications()
        }
        
        // Check if we have uncelebrated milestones that should be shown
        checkForMilestones()
    }
    
    // Check for uncelebrated streak milestones
    private func checkForMilestones() {
        if streakService.streakComplete && 
           !streakService.hasMilestoneBeenShown(milestone: streakService.unlockedMilestone) {
            // Milestone will be shown by HomeView when it appears
            print("Milestone \(streakService.unlockedMilestone) ready to be celebrated")
        }
    }
}

// MARK: - Notification Delegate
class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationDelegate()
    
    // Handle notifications when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, 
                               willPresent notification: UNNotification, 
                               withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Show banner even when app is in foreground
        completionHandler([.banner, .sound, .badge])
    }
    
    // Handle notification response when user taps on it
    func userNotificationCenter(_ center: UNUserNotificationCenter, 
                               didReceive response: UNNotificationResponse, 
                               withCompletionHandler completionHandler: @escaping () -> Void) {
        let identifier = response.notification.request.identifier
        
        // Handle different notification types
        if identifier == "dreamDailyReminder" || identifier == "dreamStreakAlert" {
            // Open app directly to dream entry if user tapped on streak reminder
            if response.actionIdentifier == "LOG_DREAM" {
                // Note: In a real app, we'd set a deep link flag to open dream entry
                print("User tapped LOG_DREAM action, should open dream entry")
            }
        }
        
        completionHandler()
    }
}
