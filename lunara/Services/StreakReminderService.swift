import Foundation
import UserNotifications

class StreakReminderService {
    static let shared = StreakReminderService()
    
    // Keys for UserDefaults
    private let reminderEnabledKey = "isReminderEnabled"
    private let reminderTimeKey = "reminderTime"
    private let lastNotificationDateKey = "lastStreakNotificationDate"
    
    // Constants
    private let dailyReminderIdentifier = "dreamDailyReminder"
    private let streakAlertIdentifier = "dreamStreakAlert"
    
    private init() {
        // Set up notification category for streak actions
        setupNotificationCategories()
    }
    
    // MARK: - Public Methods
    
    // Schedule all streak-related notifications
    func scheduleAllNotifications() {
        // First cancel existing notifications to avoid duplicates
        cancelAllNotifications()
        
        // Only proceed if reminders are enabled
        guard UserDefaults.standard.bool(forKey: reminderEnabledKey) else { 
            print("DEBUG: Reminders are disabled, not scheduling")
            return 
        }
        
        // Add a timestamp-based throttle to prevent multiple calls within a short time
        let throttleKey = "lastNotificationScheduleAttempt"
        let now = Date()
        
        if let lastScheduleTime = UserDefaults.standard.object(forKey: throttleKey) as? Date {
            // Only allow scheduling once per minute to prevent duplicates
            if now.timeIntervalSince(lastScheduleTime) < 60 {
                print("DEBUG: Throttling notification scheduling - last attempt was too recent")
                return
            }
        }
        
        // Record this attempt
        UserDefaults.standard.set(now, forKey: throttleKey)
        
        // Get the count of pending notifications to avoid scheduling duplicates
        checkPendingNotificationsCount { [weak self] count in
            guard let self = self else { return }
            
            if count > 0 {
                print("DEBUG: Notifications already scheduled (\(count) pending). Skipping scheduling.")
                return
            }
            
            print("DEBUG: No existing notifications found, proceeding to schedule")
            
            // Schedule the daily reminder
            self.scheduleDailyReminder()
            
            // Check if streak is at risk and schedule alert if needed
            self.checkAndScheduleStreakAlert()
        }
    }
    
    // Cancel all streak-related notifications
    func cancelAllNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [
            dailyReminderIdentifier,
            streakAlertIdentifier
        ])
    }
    
    // Check how many pending notifications we have
    private func checkPendingNotificationsCount(completion: @escaping (Int) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            // Filter to only include our app's notifications
            let ourNotifications = requests.filter { 
                $0.identifier == self.dailyReminderIdentifier || 
                $0.identifier == self.streakAlertIdentifier
            }
            
            DispatchQueue.main.async {
                completion(ourNotifications.count)
            }
        }
    }
    
    // Check if notification permissions are granted
    func checkNotificationPermissions(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus == .authorized)
            }
        }
    }
    
    // Request notification permissions if not already granted
    func requestNotificationPermissions(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    // Save the preference
                    UserDefaults.standard.set(true, forKey: "notificationsEnabled")
                    
                    // Set up notification categories for actions
                    self.setupNotificationCategories()
                }
                completion(granted)
            }
        }
    }
    
    // MARK: - Private Implementation
    
    // Schedule the daily dream reminder
    private func scheduleDailyReminder() {
        // Debug: Print how many pending notifications we already have before scheduling
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let existingReminders = requests.filter { $0.identifier == self.dailyReminderIdentifier }
            print("DEBUG: Found \(existingReminders.count) existing daily reminders before scheduling")
        }
        
        // Get streak information
        let streakService = StreakService.shared
        let currentStreak = streakService.currentStreak
        
        // Get reminder time string from UserDefaults
        guard let reminderTimeString = UserDefaults.standard.string(forKey: reminderTimeKey) else {
            // Default to 8:00 AM if not set
            UserDefaults.standard.set("08:00", forKey: reminderTimeKey)
            return
        }
        
        // Parse time components
        let components = reminderTimeString.split(separator: ":")
        guard components.count == 2,
              let hour = Int(components[0]),
              let minute = Int(components[1]) else {
            return
        }
        
        // Ensure there's only one daily reminder by removing any existing ones first
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [dailyReminderIdentifier])
        
        // Create date components for trigger
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        // Create trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // Create notification content based on streak status
        let content = createReminderContent(currentStreak: currentStreak)
        
        // Create request
        let request = UNNotificationRequest(
            identifier: dailyReminderIdentifier,
            content: content,
            trigger: trigger
        )
        
        // Add to notification center
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling daily reminder: \(error)")
            } else {
                print("DEBUG: Successfully scheduled daily reminder for \(hour):\(minute)")
                
                // Verify only one notification was scheduled
                UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                    let dailyReminders = requests.filter { $0.identifier == self.dailyReminderIdentifier }
                    print("DEBUG: After scheduling, found \(dailyReminders.count) daily reminders")
                }
            }
        }
    }
    
    // Check if streak is at risk and schedule an alert
    private func checkAndScheduleStreakAlert() {
        let streakService = StreakService.shared
        
        // Only proceed if user has an active streak and it's at risk
        guard streakService.currentStreak > 0,
              streakService.willStreakBreakToday(),
              shouldSendStreakAlert() else {
            return
        }
        
        // Create content for urgent streak alert
        let content = UNMutableNotificationContent()
        content.title = "⚠️ Streak at Risk!"
        content.body = "Your \(streakService.currentStreak)-day streak will break if you don't log a dream today! Tap to open your journal."
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = "STREAK_ALERT"
        
        // Schedule for current time + 1 minute (for testing) or early evening (production)
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
        components.hour = 18  // 6:00 PM - a good time to remind before day ends
        components.minute = 0
        
        // Create trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        // Create request
        let request = UNNotificationRequest(
            identifier: streakAlertIdentifier,
            content: content,
            trigger: trigger
        )
        
        // Add to notification center
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling streak alert: \(error)")
            } else {
                // Record that we sent an alert today
                self.recordStreakAlertSent()
            }
        }
    }
    
    // Create content for the daily reminder based on streak status
    private func createReminderContent(currentStreak: Int) -> UNMutableNotificationContent {
        let streakService = StreakService.shared
        let willBreakToday = streakService.willStreakBreakToday()
        
        // Create reminder text options based on streak status
        var reminderTexts: [String]
        
        if willBreakToday {
            // At risk of breaking streak
            reminderTexts = [
                "⚠️ Don't break your \(currentStreak)-day streak! Log your dream now before the day ends.",
                "Your \(currentStreak)-day streak is at risk! Take a moment to record your dreams today.",
                "Reminder: Your dream streak will reset if you don't log today. Keep your \(currentStreak)-day momentum going!",
                "Quick! Your \(currentStreak)-day streak needs you. Log your dream before midnight."
            ]
        } else if currentStreak >= 7 {
            // Established streak
            if let nextMilestone = streakService.getNextMilestone(), 
               let daysLeft = streakService.daysUntilNextMilestone(), 
               daysLeft <= 3 {
                // Close to milestone
                reminderTexts = [
                    "Just \(daysLeft) more days until your \(nextMilestone)-day milestone! Record today's dreams to stay on track.",
                    "You're \(daysLeft) days away from a dream milestone! Don't forget to log today's dreams.",
                    "\(daysLeft) days until you unlock special insights! Keep your \(currentStreak)-day streak going.",
                    "Almost there! \(daysLeft) more days to your \(nextMilestone)-day streak milestone. Log your dreams now."
                ]
            } else {
                // Regular strong streak
                reminderTexts = [
                    "Keep your \(currentStreak)-day streak alive! Time to record last night's dreams.",
                    "You're on a \(currentStreak)-day dream journey! Don't forget to log today's entry.",
                    "Impressive \(currentStreak)-day streak! Record your dreams to unlock deeper insights.",
                    "Your dedication is paying off! Maintain your \(currentStreak)-day streak by logging today's dreams."
                ]
            }
        } else if currentStreak > 0 {
            // New streak
            reminderTexts = [
                "You've logged dreams for \(currentStreak) days in a row! Keep the streak going today.",
                "Day \(currentStreak+1) awaits! Continue building your dream streak by logging today.",
                "Your \(currentStreak)-day streak is just the beginning. Log today's dreams to keep growing.",
                "Building habits takes consistency. Keep your \(currentStreak)-day streak alive!"
            ]
        } else {
            // No streak
            reminderTexts = [
                "Start your dream journey today! Record what you remember from last night.",
                "Begin your dream journey today. Log your dreams to unlock insights into your subconscious.",
                "No current streak - today is the perfect day to start! Log your dreams now.",
                "Turn dream logging into a daily habit. Start your streak today!"
            ]
        }
        
        // Choose one reminder text randomly for consistency
        let randomIndex = Int.random(in: 0..<reminderTexts.count)
        let reminderText = reminderTexts[randomIndex]
        
        // Create the content
        let content = UNMutableNotificationContent()
        content.title = willBreakToday ? "Dream Streak at Risk!" : "Dream Journal Reminder"
        content.body = reminderText
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = "DREAM_REMINDER"
        
        return content
    }
    
    // Set up notification categories with actions
    private func setupNotificationCategories() {
        // Define action for opening app directly to dream entry
        let logAction = UNNotificationAction(
            identifier: "LOG_DREAM",
            title: "Log Dream Now",
            options: .foreground
        )
        
        // Create categories for different notification types
        let reminderCategory = UNNotificationCategory(
            identifier: "DREAM_REMINDER",
            actions: [logAction],
            intentIdentifiers: [],
            options: []
        )
        
        let alertCategory = UNNotificationCategory(
            identifier: "STREAK_ALERT",
            actions: [logAction],
            intentIdentifiers: [],
            options: [.hiddenPreviewsShowTitle]
        )
        
        // Register the categories
        UNUserNotificationCenter.current().setNotificationCategories([reminderCategory, alertCategory])
    }
    
    // Check if we should send a streak alert today (to avoid spamming)
    private func shouldSendStreakAlert() -> Bool {
        let calendar = Calendar.current
        
        // Get the last notification date
        if let lastDate = UserDefaults.standard.object(forKey: lastNotificationDateKey) as? Date {
            // If we already sent a notification today, don't send another
            return !calendar.isDateInToday(lastDate)
        }
        
        // No recent notification, so we should send one
        return true
    }
    
    // Record that we sent a streak alert
    private func recordStreakAlertSent() {
        UserDefaults.standard.set(Date(), forKey: lastNotificationDateKey)
    }
} 