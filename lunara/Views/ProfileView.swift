import SwiftUI
import Models
import UIKit
import UserNotifications
import StoreKit

struct SettingsSection: View {
    let title: String
    let content: AnyView
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
            content
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String?
    let type: SettingsRowType
    let action: () -> Void
    @Binding var isOn: Bool
    @State private var isPressed = false
    @State private var isAppearing = false
    
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    
    init(
        icon: String,
        title: String,
        subtitle: String? = nil,
        type: SettingsRowType = .button,
        isOn: Binding<Bool> = .constant(false),
        action: @escaping () -> Void = {}
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.type = type
        self._isOn = isOn
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            if type != .toggle {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = true
                }
                
                // Add haptic feedback
                HapticManager.shared.buttonPress()
                
                // Reset pressed state after a short delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        isPressed = false
                    }
                    
                    // Call the action after the animation
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        action()
                    }
                }
            }
        }) {
            HStack(spacing: 16) {
                // Icon with animation
                ZStack {
                    Circle()
                        .fill(lightPurple)
                        .frame(width: 44, height: 44)
                        .scaleEffect(isPressed ? 0.92 : 1.0)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundColor(primaryPurple)
                        .scaleEffect(isPressed ? 0.85 : 1.0)
                }
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
                
                // Text with animation
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16))
                        .foregroundColor(.primary)
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                }
                .opacity(isAppearing ? 1 : 0)
                .offset(x: isAppearing ? 0 : -10)
                
                Spacer()
                
                // Right element with animation
                switch type {
                case .toggle:
                    Toggle("", isOn: $isOn)
                        .labelsHidden()
                        .tint(primaryPurple)
                        .onChange(of: isOn) { oldValue, newValue in
                            // Add haptic feedback when toggled
                            HapticManager.shared.selection()
                            action()
                        }
                        .scaleEffect(isAppearing ? 1 : 0.8)
                case .button:
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .opacity(0.6)
                        .offset(x: isPressed ? 5 : 0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
                case .destructive:
                    EmptyView()
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(UIColor.systemBackground))
                    .opacity(isPressed ? 0.7 : 1.0)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(
                        type == .destructive ? 
                            Color.red.opacity(isPressed ? 0.3 : 0.15) : 
                            primaryPurple.opacity(isPressed ? 0.3 : 0.15), 
                        lineWidth: isPressed ? 1.5 : 1
                    )
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .offset(x: isPressed ? 3 : 0)
            .opacity(isAppearing ? 1 : 0)
            .offset(y: isAppearing ? 0 : 10)
            .onAppear {
                // Staggered appearance animation
                withAnimation(AppAnimation.gentleSpring.delay(0.1)) {
                    isAppearing = true
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

enum SettingsRowType {
    case toggle
    case button
    case destructive
}

struct ProfileView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var themeSettings: ThemeSettings
    @AppStorage("isNotificationsEnabled") private var isNotificationsEnabled = false
    @AppStorage("isReminderEnabled") private var isReminderEnabled = false
    @AppStorage("reminderTime") private var reminderTimeString: String = "08:00"
    @AppStorage("isHapticsEnabled") private var isHapticsEnabled = true
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = true
    @AppStorage("userName") private var userName = "Guest User"
    @State private var showOnboarding = false
    @State private var showResetAlert = false
    @State private var showEditNameSheet = false
    @State private var showReminderTimePicker = false
    @State private var editingName = ""
    @State private var reminderDate = Calendar.current.date(from: DateComponents(hour: 8, minute: 0)) ?? Date()
    @State private var showingSubscription = false
    
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    
    // Helper property to check if dark mode is active
    private var isDarkMode: Bool {
        return themeSettings.colorScheme == .dark
    }
    
    // Computed binding for the dark mode toggle
    private var darkModeBinding: Binding<Bool> {
        Binding<Bool>(
            get: { themeSettings.colorScheme == .dark },
            set: { newValue in
                themeSettings.colorScheme = newValue ? .dark : .light
            }
        )
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                // Fixed Header using shared component
                TopBarView(
                    title: "Settings",
                    primaryPurple: primaryPurple,
                    colorScheme: colorScheme,
                    rightButtons: []
                )
                
                ScrollView {
                    VStack(spacing: 32) {
                        Color.clear.frame(height: 60)
                        
                        // Account Section
                        SettingsSection(title: "Account", content: AnyView(
                            VStack(spacing: 12) {
                                // Profile Card
                                HStack(spacing: 16) {
                                    ZStack {
                                        Circle()
                                            .fill(lightPurple)
                                            .frame(width: 70, height: 70)
                                        Image(systemName: "person.crop.circle.fill")
                                            .font(.system(size: 32))
                                            .foregroundColor(primaryPurple)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(userName)
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                        Text("Free Account")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        // Edit profile
                                        editingName = userName
                                        showEditNameSheet = true
                                    }) {
                                        Text("Edit")
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(primaryPurple)
                                    }
                                }
                                .padding(.vertical, 20)
                                .padding(.horizontal, 20)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(colorScheme == .dark ? Color(white: 0.15) : .white)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(primaryPurple.opacity(0.15), lineWidth: 1)
                                )
                                .shadow(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 4)
                                
                                SettingsRow(
                                    icon: "crown.fill",
                                    title: "Upgrade to Premium",
                                    subtitle: "Get access to all features",
                                    action: {
                                        // Present the SubscriptionView as fullscreen cover
                                        showingSubscription = true
                                    }
                                )
                            }
                        ))
                        
                        // Preferences Section
                        SettingsSection(title: "Preferences", content: AnyView(
                            VStack(spacing: 12) {
                                SettingsRow(
                                    icon: "moon.fill",
                                    title: "Dark Mode",
                                    type: .toggle,
                                    isOn: darkModeBinding
                                )
                                
                                SettingsRow(
                                    icon: "bell.fill",
                                    title: "Notifications",
                                    type: .toggle,
                                    isOn: $isNotificationsEnabled,
                                    action: {
                                        if isNotificationsEnabled {
                                            // User is turning notifications ON - request permission
                                            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                                                DispatchQueue.main.async {
                                                    // Update toggle based on whether permission was granted
                                                    isNotificationsEnabled = granted
                                                }
                                            }
                                        } else {
                                            // User is turning notifications OFF - just update the setting
                                            isNotificationsEnabled = false
                                        }
                                    }
                                )
                                
                                SettingsRow(
                                    icon: "alarm.fill",
                                    title: "Dream Reminders",
                                    subtitle: isReminderEnabled ? "Daily reminder at \(reminderTimeString)" : "Get reminded to log your dreams",
                                    type: .toggle,
                                    isOn: $isReminderEnabled,
                                    action: {
                                        if isReminderEnabled {
                                            // User enabled reminders
                                            // First check if notifications are allowed
                                            UNUserNotificationCenter.current().getNotificationSettings { settings in
                                                DispatchQueue.main.async {
                                                    if settings.authorizationStatus == .authorized {
                                                        // Show time picker
                                                        self.loadReminderTime()
                                                        self.showReminderTimePicker = true
                                                    } else {
                                                        // Ask for notification permission
                                                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                                                            DispatchQueue.main.async {
                                                                if granted {
                                                                    // Permission granted, show time picker
                                                                    self.loadReminderTime()
                                                                    self.showReminderTimePicker = true
                                                                } else {
                                                                    // Permission denied, disable reminder toggle
                                                                    self.isReminderEnabled = false
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        } else {
                                            // User disabled reminders, cancel notifications
                                            cancelDreamReminders()
                                        }
                                    }
                                )
                                
                                SettingsRow(
                                    icon: "waveform.path",
                                    title: "Haptics",
                                    subtitle: "Feel subtle vibrations when interacting with the app",
                                    type: .toggle,
                                    isOn: $isHapticsEnabled
                                )
                            }
                        ))
                        
                        // Support Section
                        SettingsSection(title: "Support", content: AnyView(
                            VStack(spacing: 12) {
                                SettingsRow(
                                    icon: "questionmark.circle.fill",
                                    title: "Help Center",
                                    action: {
                                        // Open Help Center URL
                                        if let url = URL(string: "https://multumgrp.tech/lunara") {
                                            UIApplication.shared.open(url)
                                        }
                                    }
                                )
                                
                                SettingsRow(
                                    icon: "envelope.fill",
                                    title: "Contact Support",
                                    action: {
                                        // Open Contact Support URL
                                        if let url = URL(string: "https://multumgrp.tech/lunara#popup:form") {
                                            UIApplication.shared.open(url)
                                        }
                                    }
                                )
                                
                                SettingsRow(
                                    icon: "star.fill",
                                    title: "Rate App",
                                    action: {
                                        // Request app store review
                                        HapticManager.shared.buttonPress()
                                        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                                            if #available(iOS 18.0, *) {
                                                StoreKit.AppStore.requestReview(in: scene)
                                            } else {
                                                SKStoreReviewController.requestReview(in: scene)
                                            }
                                        }
                                    }
                                )
                            }
                        ))
                        
                        // Legal Section
                        SettingsSection(title: "Legal", content: AnyView(
                            VStack(spacing: 12) {
                                SettingsRow(
                                    icon: "doc.text.fill",
                                    title: "Privacy Policy",
                                    action: {
                                        // Open Privacy Policy URL
                                        if let url = URL(string: "https://multumgrp.tech/lunara/privacypolicy") {
                                            UIApplication.shared.open(url)
                                        }
                                    }
                                )
                                
                                SettingsRow(
                                    icon: "doc.text.fill",
                                    title: "Terms of Service",
                                    action: {
                                        // Open Terms of Service URL
                                        if let url = URL(string: "https://multumgrp.tech/lunara/termsofuse") {
                                            UIApplication.shared.open(url)
                                        }
                                    }
                                )
                                
                                SettingsRow(
                                    icon: "doc.text.fill",
                                    title: "EULA",
                                    action: {
                                        // Open EULA URL
                                        if let url = URL(string: "https://multumgrp.tech/lunara/eula") {
                                            UIApplication.shared.open(url)
                                        }
                                    }
                                )
                                
                                SettingsRow(
                                    icon: "doc.text.fill",
                                    title: "User Agreement",
                                    action: {
                                        // Open User Agreement URL
                                        if let url = URL(string: "https://multumgrp.tech/lunara/useragreement") {
                                            UIApplication.shared.open(url)
                                        }
                                    }
                                )
                            }
                        ))
                        
                        // Developer Section
                        SettingsSection(title: "Developer", content: AnyView(
                            VStack(spacing: 12) {
                                SettingsRow(
                                    icon: "line.3.crossed.swirl.circle.fill",
                                    title: "Test Onboarding",
                                    subtitle: "Reset onboarding state to view it again",
                                    action: {
                                        // Reset onboarding state
                                        hasCompletedOnboarding = false
                                        
                                        // Display alert that onboarding has been reset
                                        HapticManager.shared.buttonPress()
                                        
                                        // Show alert asking if user wants to see onboarding now
                                        showResetAlert = true
                                    }
                                )
                            }
                        ))
                        
                        // Account Actions
                        SettingsSection(title: "Account Actions", content: AnyView(
                            VStack(spacing: 12) {
                                Button(action: {
                                    // Show delete data confirmation dialog
                                    HapticManager.shared.buttonPress()
                                    showResetAlert = true
                                }) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "trash.fill")
                                            .font(.system(size: 16, weight: .semibold))
                                        Text("DELETE ALL DATA")
                                            .font(.system(size: 16, weight: .semibold))
                                    }
                                    .foregroundColor(Color.red)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        Capsule()
                                            .stroke(Color.red.opacity(0.5), lineWidth: 1.5)
                                    )
                                }
                            }
                        ))
                    }
                    .padding(16)
                    .padding(.bottom, 90)
                }
            }
            .background(Color(UIColor.systemBackground))
            .navigationBarHidden(true)
            .sheet(isPresented: $showOnboarding) {
                OnboardingFlow()
            }
            .alert(isPresented: $showResetAlert) {
                Alert(
                    title: Text("Delete All Data?"),
                    message: Text("This will delete all your data and reset the app to its initial state. This action cannot be undone."),
                    primaryButton: .destructive(Text("Delete")) {
                        resetApp()
                    },
                    secondaryButton: .cancel()
                )
            }
            .sheet(isPresented: $showEditNameSheet) {
                EditNameView(userName: $userName, isPresented: $showEditNameSheet, editingName: $editingName)
            }
            .sheet(isPresented: $showReminderTimePicker) {
                ReminderTimePickerView(isPresented: $showReminderTimePicker, reminderDate: $reminderDate, reminderTimeString: $reminderTimeString, onSave: {
                    saveReminderTime()
                    scheduleDreamReminders()
                })
            }
            .fullScreenCover(isPresented: $showingSubscription) {
                SubscriptionView()
            }
            .onAppear {
                checkNotificationAuthorizationStatus()
                loadReminderTime()
                
                // Schedule notifications if reminders are enabled
                if isReminderEnabled {
                    scheduleDreamReminders()
                }
            }
        }
    }
    
    private func resetApp() {
        // Reset all user defaults
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
        
        // Reset specific values if needed
        hasCompletedOnboarding = false
        userName = "Guest User"
        isNotificationsEnabled = false  // Reset in UserDefaults, actual system settings can't be changed
        isReminderEnabled = false
        isHapticsEnabled = true
        
        // Reset theme to light mode
        UserDefaults.standard.removeObject(forKey: "appColorScheme")
        themeSettings.colorScheme = .light
        
        reminderTimeString = "08:00"
        
        // Show onboarding flow again
        showOnboarding = true
    }
    
    // Function to check current notification authorization status
    private func checkNotificationAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                isNotificationsEnabled = settings.authorizationStatus == .authorized
            }
        }
    }
    
    // MARK: - Reminder Functions
    
    // Function to load reminder time from UserDefaults string
    private func loadReminderTime() {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        if let date = timeFormatter.date(from: reminderTimeString) {
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            let minute = calendar.component(.minute, from: date)
            
            var components = DateComponents()
            components.hour = hour
            components.minute = minute
            
            if let reminderTime = Calendar.current.date(from: components) {
                reminderDate = reminderTime
            }
        }
    }
    
    // Function to save reminder time to UserDefaults
    private func saveReminderTime() {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        reminderTimeString = timeFormatter.string(from: reminderDate)
    }
    
    // Function to schedule daily notifications
    private func scheduleDreamReminders() {
        // First cancel any existing notifications
        cancelDreamReminders()
        
        guard isReminderEnabled else { return }
        
        // Create reminder text options
        let reminderTexts = [
            "Good morning! Remember any dreams last night? Take a moment to record them while they're still fresh.",
            "Rise and shine! Did you have any interesting dreams? Open Lunara to log them before they fade away.",
            "Morning! Your dream journal is waiting for today's entry. What adventures did your mind take you on?",
            "Hey dreamer! Time to capture those nighttime thoughts before they disappear. Open Lunara now.",
            "Good morning! Your dream insights await. Take a moment to record what you remember from last night.",
            "Dreams fade quickly after waking. Open Lunara now to preserve last night's dreams.",
            "Morning reflection time: what messages did your dreams bring last night?",
            "Your dream journal misses you! Add today's entry while memories are still vivid."
        ]
        
        // Extract hour and minute components from the selected date
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: reminderDate)
        let minute = calendar.component(.minute, from: reminderDate)
        
        // Set up notification content
        let notificationCenter = UNUserNotificationCenter.current()
        
        // Schedule notifications for the next 30 days with rotating messages
        for day in 0..<30 {
            // Create a date component for the notification
            var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = minute
            
            // Create the trigger
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            // Create the content with a rotating message
            let reminderText = reminderTexts[day % reminderTexts.count]
            let content = UNMutableNotificationContent()
            content.title = "Dream Journal Reminder"
            content.body = reminderText
            content.sound = UNNotificationSound.default
            content.badge = 1
            
            // Create the request
            let request = UNNotificationRequest(
                identifier: "dreamReminder-\(day)",
                content: content,
                trigger: trigger
            )
            
            // Add the request to the notification center
            notificationCenter.add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error)")
                }
            }
        }
    }
    
    // Function to cancel all dream reminder notifications
    private func cancelDreamReminders() {
        let notificationCenter = UNUserNotificationCenter.current()
        
        // Get all pending notification requests
        notificationCenter.getPendingNotificationRequests { requests in
            // Filter out the dream reminder notifications
            let dreamReminderIds = requests
                .filter { $0.identifier.hasPrefix("dreamReminder") }
                .map { $0.identifier }
            
            // Remove the dream reminder notifications
            notificationCenter.removePendingNotificationRequests(withIdentifiers: dreamReminderIds)
        }
    }
}

// Name editing sheet
struct EditNameView: View {
    @Binding var userName: String
    @Binding var isPresented: Bool
    @Binding var editingName: String
    @FocusState private var isNameFieldFocused: Bool
    @State private var animateBorder = false
    @State private var animateStars = false
    @State private var isAppearing = false
    @State private var isSaving = false
    
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    private let darkPurple = Color(red: 102/255, green: 51/255, blue: 153/255)
    private let deepPurple = Color(red: 76/255, green: 40/255, blue: 130/255)
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        deepPurple,
                        darkPurple,
                        primaryPurple.opacity(0.85)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // Star particles
                StarsView()
                    .opacity(animateStars ? 0.8 : 0.3)
                    .animation(.easeInOut(duration: 2.0), value: animateStars)
                
                VStack(spacing: 32) {
                    // Profile icon with animation
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [lightPurple.opacity(0.7), primaryPurple.opacity(0.3)]),
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 50
                                )
                            )
                            .frame(width: 100, height: 100)
                            .shadow(color: primaryPurple.opacity(0.5), radius: 10, x: 0, y: 0)
                            .scaleEffect(isAppearing ? 1.0 : 0.7)
                            .opacity(isAppearing ? 1.0 : 0.0)
                        
                        Image(systemName: "person.fill")
                            .font(.system(size: 45))
                            .foregroundColor(.white)
                            .scaleEffect(isAppearing ? 1.0 : 0.5)
                            .opacity(isAppearing ? 1.0 : 0.0)
                    }
                    .animation(AppAnimation.spring.delay(0.1), value: isAppearing)
                    
                    // Title with animation
                    Text("Edit Your Name")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .opacity(isAppearing ? 1.0 : 0.0)
                        .offset(y: isAppearing ? 0 : 20)
                        .animation(AppAnimation.spring.delay(0.2), value: isAppearing)
                    
                    // Text field with animation
                    VStack(spacing: 8) {
                        TextField("Your Name", text: $editingName)
                            .font(.system(size: 18))
                            .padding()
                            .background(Color.white.opacity(0.15))
                            .cornerRadius(12)
                            .foregroundColor(.white)
                            .accentColor(.white)
                            .focused($isNameFieldFocused)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                .white.opacity(animateBorder ? 0.8 : 0.4),
                                                primaryPurple.opacity(animateBorder ? 0.6 : 0.3),
                                                .white.opacity(animateBorder ? 0.8 : 0.4)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: animateBorder ? 2 : 1
                                    )
                            )
                            .onChange(of: isNameFieldFocused) { _, isFocused in
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    animateBorder = isFocused
                                }
                            }
                        
                        if editingName.isEmpty {
                            Text("Please enter your name")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.7))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 4)
                        }
                    }
                    .padding(.horizontal, 20)
                    .opacity(isAppearing ? 1.0 : 0.0)
                    .offset(y: isAppearing ? 0 : 15)
                    .animation(AppAnimation.spring.delay(0.3), value: isAppearing)
                    
                    // Buttons with animation
                    HStack(spacing: 16) {
                        // Cancel button
                        Button(action: {
                            HapticManager.shared.light()
                            isPresented = false
                        }) {
                            Text("Cancel")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(12)
                        }
                        
                        // Save button
                        Button(action: {
                            if !editingName.isEmpty {
                                // Show saving animation
                                isSaving = true
                                HapticManager.shared.success()
                                
                                // Simulate a brief saving process
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    userName = editingName
                                    isPresented = false
                                }
                            } else {
                                // Animate border to indicate error
                                withAnimation(.easeInOut(duration: 0.5).repeatCount(3, autoreverses: true)) {
                                    animateBorder = true
                                }
                                HapticManager.shared.error()
                            }
                        }) {
                            HStack {
                                if isSaving {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                        .padding(.trailing, 8)
                                }
                                
                                Text(isSaving ? "Saving..." : "Save")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                editingName.isEmpty ? 
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.white.opacity(0.1), Color.white.opacity(0.1)]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ) : 
                                    LinearGradient(
                                        gradient: Gradient(colors: [lightPurple, primaryPurple]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                            )
                            .cornerRadius(12)
                            .scaleEffect(isSaving ? 0.98 : 1.0)
                        }
                        .disabled(editingName.isEmpty)
                    }
                    .padding(.horizontal, 20)
                    .opacity(isAppearing ? 1.0 : 0.0)
                    .offset(y: isAppearing ? 0 : 20)
                    .animation(AppAnimation.spring.delay(0.4), value: isAppearing)
                }
                .padding(.vertical, 40)
            }
            .onAppear {
                // Focus the text field
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    isNameFieldFocused = true
                }
                
                // Trigger appearance animations
                withAnimation(AppAnimation.gentleSpring) {
                    isAppearing = true
                }
                
                // Animate stars
                withAnimation(.easeInOut(duration: 1.5)) {
                    animateStars = true
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// Star background view for the edit name screen
struct StarsView: View {
    let starCount = 40
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<starCount, id: \.self) { i in
                    Circle()
                        .fill(Color.white)
                        .frame(width: randomSize(for: i))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                        .opacity(Double.random(in: 0.1...0.7))
                        .blur(radius: i % 3 == 0 ? 0 : 0.5)
                        .animation(
                            Animation.easeInOut(duration: Double.random(in: 2...5))
                                .repeatForever(autoreverses: true)
                                .delay(Double.random(in: 0...3)),
                            value: UUID()
                        )
                }
            }
        }
    }
    
    private func randomSize(for index: Int) -> CGFloat {
        if index % 10 == 0 {
            return CGFloat.random(in: 2...3.5)
        } else {
            return CGFloat.random(in: 1...2)
        }
    }
}

// MARK: - ReminderTimePickerView
struct ReminderTimePickerView: View {
    @Binding var isPresented: Bool
    @Binding var reminderDate: Date
    @Binding var reminderTimeString: String
    var onSave: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    private let darkPurple = Color(red: 102/255, green: 51/255, blue: 153/255)
    private let deepPurple = Color(red: 76/255, green: 40/255, blue: 130/255)
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        deepPurple,
                        darkPurple,
                        primaryPurple.opacity(0.85)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // Star particles in background
                StarsView()
                    .opacity(0.8)
                
                VStack(spacing: 30) {
                    Text("When would you like to be reminded?")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .shadow(color: darkPurple.opacity(0.6), radius: 3, x: 0, y: 2)
                    
                    Text("Choose a time to receive daily reminders to log your dreams")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                        .shadow(color: darkPurple.opacity(0.4), radius: 2, x: 0, y: 1)
                    
                    Spacer().frame(height: 20)
                    
                    // Time Picker
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(colorScheme == .dark ? Color.black.opacity(0.3) : Color.white.opacity(0.15))
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                        
                        DatePicker("", selection: $reminderDate, displayedComponents: .hourAndMinute)
                            .datePickerStyle(WheelDatePickerStyle())
                            .labelsHidden()
                            .colorScheme(.dark) // Force dark appearance for the picker
                            .colorMultiply(lightPurple) // Add a light purple tint
                            .padding()
                    }
                    .frame(height: 180)
                    .padding(.horizontal, 40)
                    
                    Text("Dream memories fade quickly. The best time to record dreams is right after waking up.")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                        .padding(.top, 10)
                    
                    Spacer()
                    
                    // Save button
                    Button {
                        onSave()
                        isPresented = false
                    } label: {
                        Text("Save")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [primaryPurple, darkPurple]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(20)
                            .shadow(color: darkPurple.opacity(0.6), radius: 8, x: 0, y: 4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(lightPurple.opacity(0.5), lineWidth: 1)
                            )
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 30)
                }
            }
            .navigationBarItems(trailing: Button(action: {
                isPresented = false
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.white.opacity(0.8))
            })
        }
    }
}

#Preview {
    ProfileView()
} 