import SwiftUI
import Models
import StoreKit

// Import DynamicColors from the main module
import UIKit

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var themeSettings: ThemeSettings
    @State private var showingDreamEntry = false
    @State private var showingDreamDetails = false
    @State private var selectedDream: DreamEntry?
    @State private var showBiorythmAnalysis = false
    @State private var showingSubscription = false
    @State private var showingPromoModal = false
    @StateObject private var subscriptionService = SubscriptionService.shared
    
    // Button animation states
    @State private var unlockButtonScale: CGFloat = 1.0
    @State private var unlockButtonRotation: Double = 0.0
    @State private var rateButtonScale: CGFloat = 1.0
    @State private var rateButtonOffset: CGFloat = 0.0
    @State private var rateButtonOpacity: Double = 1.0
    @State private var contactButtonScale: CGFloat = 1.0
    @State private var contactButtonOpacity: Double = 1.0
    @State private var premiumButtonScale: CGFloat = 1.0
    @State private var newDreamButtonScale: CGFloat = 1.0
    @State private var newDreamButtonBrightness: Double = 0.0
    @State private var newDreamButtonBgOpacity: Double = 0.0
    @State private var biorythmButtonScale: CGFloat = 1.0
    @State private var biorythmButtonColor: Color = Color(red: 147/255, green: 112/255, blue: 219/255)
    @State private var biorythmButtonBlur: CGFloat = 0.0
    
    // Custom colors - define them inline
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    
    // Custom helper for cardBackgroundColor
    private var cardBackgroundColor: Color {
        return colorScheme == .dark ? Color(white: 0.15) : .white
    }
    
    // Dreams data
    @State private var latestDreams: [DreamEntry] = []
    
    // Helper property to check if dark mode is active
    private var isDarkMode: Bool {
        return themeSettings.colorScheme == .dark
    }
    
    // Computed property to manage top bar buttons based on subscription status
    private var topBarButtons: [TopBarButton] {
        if subscriptionService.isSubscribed() {
            // Only show theme toggle for subscribers
            return [
                TopBarButton(icon: isDarkMode ? "sun.max.fill" : "moon.fill", action: {
                    // Toggle between light and dark mode
                    themeSettings.colorScheme = isDarkMode ? .light : .dark
                })
            ]
        } else {
            // Show all buttons for non-subscribers
            return [
                TopBarButton(icon: "gift.fill", action: {
                    HapticManager.shared.buttonPress()
                    showingPromoModal = true
                }),
                TopBarButton(icon: "crown.fill", action: {
                    // Show subscription view when crown icon is clicked
                    HapticManager.shared.buttonPress()
                    showingSubscription = true
                }),
                TopBarButton(icon: isDarkMode ? "sun.max.fill" : "moon.fill", action: {
                    // Toggle between light and dark mode
                    themeSettings.colorScheme = isDarkMode ? .light : .dark
                })
            ]
        }
    }
    
    private var currentDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d"
        return formatter.string(from: Date())
    }
    
    private var timeBasedGreeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        let greeting: String
        let emojis: [String]
        
        if hour >= 5 && hour < 12 {
            greeting = "Good morning!"
            emojis = ["☀️", "🌅", "🌄", "🌻", "🍳", "☕️"]
        } else if hour >= 12 && hour < 17 {
            greeting = "Afternoon!"
            emojis = ["🌞", "🌈", "🏖️", "🍹", "🌤️", "🌻"]
        } else if hour >= 17 && hour < 22 {
            greeting = "Evening!"
            emojis = ["🌙", "✨", "🌆", "🌃", "🥂", "🍷"]
        } else {
            greeting = "Good night!"
            emojis = ["💤", "🌛", "🌜", "🌌", "🌠", "🦉"]
        }
        
        // Use a seeded random generator based on the day so the emoji stays the same all day
        let day = Calendar.current.component(.day, from: Date())
        let month = Calendar.current.component(.month, from: Date())
        let seed = day + month * 100
        srand48(seed)
        
        let randomIndex = Int(drand48() * Double(emojis.count))
        let emoji = emojis[randomIndex]
        
        return "\(greeting) \(emoji)\n\(currentDate)"
    }
    
    // Custom title view with different font weights
    private var customTitleView: some View {
        let hour = Calendar.current.component(.hour, from: Date())
        
        let greeting: String
        let emojis: [String]
        
        if hour >= 5 && hour < 12 {
            greeting = "Good morning!"
            emojis = ["☀️", "🌅", "🌄", "🌻", "🍳", "☕️"]
        } else if hour >= 12 && hour < 17 {
            greeting = "Good day!"
            emojis = ["🌞", "🌈", "🏖️", "🍹", "🌤️", "🌻"]
        } else if hour >= 17 && hour < 22 {
            greeting = "G'evening!"
            emojis = ["🌙", "✨", "🌆", "🌃", "🥂", "🍷"]
        } else {
            greeting = "Sleep well!"
            emojis = ["💤", "🌛", "🌜", "🌌", "🌠", "🦉"]
        }
        
        // Use a seeded random generator based on the day
        let day = Calendar.current.component(.day, from: Date())
        let month = Calendar.current.component(.month, from: Date())
        let seed = day + month * 100
        srand48(seed)
        
        let randomIndex = Int(drand48() * Double(emojis.count))
        let emoji = emojis[randomIndex]
        
        return VStack(alignment: .leading, spacing: 2) {
            // First line: Greeting with emoji
            Text("\(greeting) \(emoji)")
                .font(.title)
                .fontWeight(.bold)
            
            // Second line: Date with lighter weight
            Text(currentDate)
                .font(.title3)
                .fontWeight(.regular)
                .foregroundColor(.secondary)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    TopBarView(
                        titleView: customTitleView,
                        primaryPurple: primaryPurple,
                        colorScheme: colorScheme,
                        rightButtons: topBarButtons
                    )
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            // Dream Interpreter Card
                            VStack(spacing: 0) {
                                HStack(alignment: .center, spacing: 16) {
                                    // Left part - Icon
                                    ZStack {
                                        Circle()
                                            .fill(lightPurple)
                                            .frame(width: 70, height: 70)
                                        Image(systemName: "sparkles")
                                            .font(.system(size: 28))
                                            .foregroundColor(primaryPurple)
                                    }
                                    
                                    // Right part - Text
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Dream Interpreter")
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                        Text("Record and understand your dreams with AI-powered interpretation")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .lineSpacing(2)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 16)
                                
                                Divider()
                                    .background(lightPurple)
                                    .padding(.horizontal, 16)
                                
                                Button {
                                    HapticManager.shared.buttonPress()
                                    
                                    // Button animation - enhanced shimmer effect
                                    withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                                        newDreamButtonScale = 0.85
                                        newDreamButtonBrightness = 0.4
                                        newDreamButtonBgOpacity = 1.0
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        withAnimation(.spring(response: 0.25, dampingFraction: 0.4)) {
                                            newDreamButtonScale = 1.1
                                            newDreamButtonBrightness = 0.0
                                            newDreamButtonBgOpacity = 0.0
                                        }
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                            withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                                                newDreamButtonScale = 1.0
                                            }
                                        }
                                    }
                                    
                                    handleDreamInterpreterClick()
                                } label: {
                                    HStack(spacing: 8) {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.system(size: 16, weight: .semibold))
                                        Text("NEW DREAM ENTRY")
                                            .font(.system(size: 16, weight: .semibold))
                                    }
                                    .foregroundColor(primaryPurple)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                }
                                .padding(.horizontal, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 24)
                                        .fill(cardBackgroundColor.opacity(0.2))
                                        .opacity(newDreamButtonBgOpacity)
                                )
                                .scaleEffect(newDreamButtonScale)
                                .brightness(newDreamButtonBrightness)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(cardBackgroundColor)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .strokeBorder(lightPurple, lineWidth: 1)
                            )
                            .shadow(color: colorScheme == .dark ? Color.clear : Color.black.opacity(0.05), radius: 15, x: 0, y: 4)
                            
                            // Premium Features Card
                            if !subscriptionService.isSubscribed() {
                                VStack(spacing: 0) {
                                    HStack(alignment: .center, spacing: 16) {
                                        // Left part - Icon
                                        ZStack {
                                            Circle()
                                                .fill(lightPurple)
                                                .frame(width: 70, height: 70)
                                            Image(systemName: "crown.fill")
                                                .font(.system(size: 28))
                                                .foregroundColor(primaryPurple)
                                        }
                                        
                                        // Right part - Text
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Premium Features")
                                                .font(.title3)
                                                .fontWeight(.semibold)
                                            Text("Get unlimited dream interpretations, advanced insights, and personalized recommendations")
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                                .lineSpacing(2)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 16)
                                    
                                    Divider()
                                        .background(lightPurple)
                                        .padding(.horizontal, 16)
                                    
                                    Button {
                                        HapticManager.shared.buttonPress()
                                        
                                        // Button animation - dramatic pulse effect
                                        withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                                            premiumButtonScale = 0.8
                                        }
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.4)) {
                                                premiumButtonScale = 1.15
                                            }
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                                withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                                                    premiumButtonScale = 1.0
                                                }
                                            }
                                        }
                                        
                                        showingSubscription = true
                                    } label: {
                                        HStack(spacing: 8) {
                                            Image(systemName: "crown.fill")
                                                .font(.system(size: 16, weight: .semibold))
                                            Text("UPGRADE TO PREMIUM")
                                                .font(.system(size: 16, weight: .semibold))
                                        }
                                        .foregroundColor(primaryPurple)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                    }
                                    .padding(.horizontal, 16)
                                    .scaleEffect(premiumButtonScale)
                                }
                                .background(
                                    RoundedRectangle(cornerRadius: 24)
                                        .fill(cardBackgroundColor)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24)
                                        .strokeBorder(lightPurple, lineWidth: 1)
                                )
                                .shadow(color: colorScheme == .dark ? Color.clear : Color.black.opacity(0.05), radius: 15, x: 0, y: 4)
                            }
                            
                            // Recent Dreams Section
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Recent Dreams")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                
                                if latestDreams.isEmpty {
                                    VStack(spacing: 8) {
                                        Image(systemName: "moon.zzz.fill")
                                            .font(.system(size: 32))
                                            .foregroundColor(primaryPurple.opacity(0.5))
                                        Text("No Dreams Yet")
                                            .font(.system(size: 16))
                                            .foregroundColor(.secondary)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 32)
                                } else {
                                    ForEach(latestDreams) { dream in
                                        Button {
                                            HapticManager.shared.itemSelected()
                                            print("Dream selected in HomeView: \(dream.id), \(dream.dreamName)")
                                            selectedDream = dream
                                            showingDreamDetails = true
                                        } label: {
                                            HStack(spacing: 12) {
                                                Image(systemName: getDreamIcon(for: dream.dreamName))
                                                    .font(.system(size: 16))
                                                    .foregroundColor(primaryPurple)
                                                
                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text(dream.dreamName)
                                                        .font(.system(size: 16, weight: .medium))
                                                        .foregroundColor(.primary)
                                                    
                                                    Text(formattedDate(dream.createdAt))
                                                        .font(.system(size: 12))
                                                        .foregroundColor(.secondary)
                                                }
                                                
                                                Spacer()
                                                
                                                Image(systemName: "chevron.right")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                        if dream.id != latestDreams.last?.id {
                                            Divider()
                                                .background(lightPurple)
                                        }
                                    }
                                }
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(cardBackgroundColor)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .strokeBorder(lightPurple, lineWidth: 1)
                            )
                            .shadow(color: colorScheme == .dark ? Color.clear : Color.black.opacity(0.05), radius: 15, x: 0, y: 4)
                            
                            // Biorythm Analysis Card
                            VStack(spacing: 0) {
                                HStack(alignment: .center, spacing: 16) {
                                    // Left part - Icon
                                    ZStack {
                                        Circle()
                                            .fill(lightPurple)
                                            .frame(width: 70, height: 70)
                                        Image(systemName: "waveform.path.ecg")
                                            .font(.system(size: 28))
                                            .foregroundColor(primaryPurple)
                                    }
                                    
                                    // Right part - Text
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Biorythm Analysis")
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                        Text("Understand your natural sleep cycles and optimize your rest")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .lineSpacing(2)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 16)
                                
                                Divider()
                                    .background(lightPurple)
                                    .padding(.horizontal, 16)
                                
                                Button {
                                    HapticManager.shared.buttonPress()
                                    
                                    // Button animation - dramatic color pulse with blur
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        biorythmButtonScale = 0.85
                                        biorythmButtonColor = Color(red: 210/255, green: 170/255, blue: 255/255)
                                        biorythmButtonBlur = 5
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        withAnimation(.spring(response: 0.25, dampingFraction: 0.4)) {
                                            biorythmButtonScale = 1.15
                                            biorythmButtonColor = Color(red: 180/255, green: 140/255, blue: 255/255)
                                            biorythmButtonBlur = 0
                                        }
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                            withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                                                biorythmButtonScale = 1.0
                                                biorythmButtonColor = primaryPurple
                                            }
                                        }
                                    }
                                    
                                    showBiorythmAnalysis = true
                                } label: {
                                    HStack(spacing: 8) {
                                        Image(systemName: "chart.bar.fill")
                                            .font(.system(size: 16, weight: .semibold))
                                        Text("BEGIN ANALYSIS")
                                            .font(.system(size: 16, weight: .semibold))
                                    }
                                    .foregroundColor(biorythmButtonColor)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                }
                                .padding(.horizontal, 16)
                                .scaleEffect(biorythmButtonScale)
                                .blur(radius: biorythmButtonBlur)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(cardBackgroundColor)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .strokeBorder(lightPurple, lineWidth: 1)
                            )
                            .shadow(color: colorScheme == .dark ? Color.clear : Color.black.opacity(0.05), radius: 15, x: 0, y: 4)
                            
                            // Action Buttons
                            VStack(spacing: 16) {
                                if !subscriptionService.isSubscribed() {
                                    Button {
                                        // Open premium upgrade flow or in-app purchase
                                        HapticManager.shared.buttonPress()
                                        
                                        // Button animation - subtle rotation and scale effect
                                        withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                                            unlockButtonScale = 0.95
                                            unlockButtonRotation = -1
                                        }
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                                unlockButtonScale = 1.03
                                                unlockButtonRotation = 0.5
                                            }
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                                withAnimation(.spring(response: 0.25, dampingFraction: 0.6)) {
                                                    unlockButtonScale = 1.0
                                                    unlockButtonRotation = 0
                                                }
                                            }
                                        }
                                        
                                        showingSubscription = true
                                    } label: {
                                        HStack(spacing: 8) {
                                            Image(systemName: "lock.open.fill")
                                                .font(.system(size: 16, weight: .semibold))
                                            Text("UNLOCK ALL FEATURES")
                                                .font(.system(size: 16, weight: .semibold))
                                        }
                                        .foregroundColor(primaryPurple)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                        .background(
                                            RoundedRectangle(cornerRadius: 24)
                                                .strokeBorder(primaryPurple, lineWidth: 1)
                                        )
                                    }
                                    .scaleEffect(unlockButtonScale)
                                    .rotationEffect(.degrees(unlockButtonRotation))
                                }
                                
                                // Rate Us button - only show if user hasn't rated the app yet
                                if !RatingService.shared.hasUserRatedApp() {
                                    Button {
                                        // Request app store review
                                        HapticManager.shared.buttonPress()
                                        
                                        // Button animation - subtle press with fade
                                        withAnimation(.easeOut(duration: 0.15)) {
                                            rateButtonScale = 0.97
                                            rateButtonOpacity = 0.85
                                            rateButtonOffset = 0
                                        }
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                            withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                                                rateButtonScale = 1.02
                                                rateButtonOpacity = 1.0
                                            }
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                                withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) {
                                                    rateButtonScale = 1.0
                                                }
                                            }
                                        }
                                        
                                        // Use our RatingService for consistent tracking
                                        RatingService.shared.requestSystemReview()
                                    } label: {
                                        HStack(spacing: 8) {
                                            Image(systemName: "star.bubble.fill")
                                                .font(.system(size: 16, weight: .semibold))
                                            Text("RATE US ON THE APP STORE")
                                                .font(.system(size: 16, weight: .semibold))
                                        }
                                        .foregroundColor(Color(.systemGray))
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                        .background(
                                            RoundedRectangle(cornerRadius: 24)
                                                .strokeBorder(Color(.systemGray), lineWidth: 1)
                                        )
                                    }
                                    .scaleEffect(rateButtonScale)
                                    .offset(y: rateButtonOffset)
                                    .opacity(rateButtonOpacity)
                                }
                                
                                Button {
                                    // Open Contact Support URL
                                    HapticManager.shared.buttonPress()
                                    
                                    // Button animation - subtle press with fade
                                    withAnimation(.easeOut(duration: 0.15)) {
                                        contactButtonScale = 0.97
                                        contactButtonOpacity = 0.85
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                        withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                                            contactButtonScale = 1.02
                                            contactButtonOpacity = 1.0
                                        }
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                            withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) {
                                                contactButtonScale = 1.0
                                            }
                                        }
                                    }
                                    
                                    if let url = URL(string: "https://multumgrp.tech/lunara#popup:form") {
                                        UIApplication.shared.open(url)
                                    }
                                } label: {
                                    HStack(spacing: 8) {
                                        Image(systemName: "envelope.fill")
                                            .font(.system(size: 16, weight: .semibold))
                                        Text("CONTACT US")
                                            .font(.system(size: 16, weight: .semibold))
                                    }
                                    .foregroundColor(Color(.systemGray))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 24)
                                            .strokeBorder(Color(.systemGray), lineWidth: 1)
                                    )
                                }
                                .scaleEffect(contactButtonScale)
                                .opacity(contactButtonOpacity)
                            }
                        }
                        .padding(16)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .sheet(isPresented: $showingDreamEntry) {
            DreamEntryFlow()
        }
        .sheet(isPresented: $showBiorythmAnalysis) {
            BiorythmAnalysisFlow()
        }
        .fullScreenCover(isPresented: $showingSubscription) {
            SubscriptionView()
        }
        .sheet(isPresented: $showingPromoModal) {
            ShortPromoView(onDismiss: {
                showingPromoModal = false
            })
        }
        .fullScreenCover(isPresented: $showingDreamDetails, onDismiss: {
            print("Dream details dismissed in HomeView")
            // Reset selected dream when sheet is dismissed
            selectedDream = nil
        }) {
            if let dream = selectedDream {
                NavigationView {
                    DreamInterpretationCoordinatorView(dream: dream)
                        .background(Color(.systemBackground))
                        .onAppear {
                            print("Presenting dream in HomeView - ID: \(dream.id), Name: \(dream.dreamName)")
                        }
                }
                .navigationViewStyle(StackNavigationViewStyle())
            } else {
                // Add a navigation view with a dismiss button to handle case when no dream is selected
                NavigationView {
                    VStack {
                        Text("No dream selected")
                            .font(.title2)
                            .foregroundColor(.secondary)
                            .onAppear {
                                print("ERROR: No dream selected but trying to show details")
                            }
                    }
                    .navigationBarItems(trailing: Button("Close") {
                        showingDreamDetails = false
                    })
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemBackground))
                }
                .navigationViewStyle(StackNavigationViewStyle())
            }
        }
        .onAppear {
            loadLatestDreams()
        }
        .onReceive(NotificationCenter.default.publisher(for: .dreamsSaved)) { _ in
            loadLatestDreams()
        }
    }
    
    private func loadLatestDreams() {
        latestDreams = DreamStorageService.shared.getLatestDreams(limit: 3)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func getDreamIcon(for dreamName: String) -> String {
        let title = dreamName.lowercased()
        
        switch true {
        case title.contains("jungle"), title.contains("forest"), title.contains("nature"):
            return "leaf.fill"
        case title.contains("flying"), title.contains("sky"), title.contains("air"):
            return "bird.fill"
        case title.contains("water"), title.contains("ocean"), title.contains("sea"):
            return "water.waves.fill"
        case title.contains("house"), title.contains("home"):
            return "house.fill"
        case title.contains("conflict"), title.contains("fight"), title.contains("battle"):
            return "exclamationmark.triangle.fill"
        case title.contains("love"), title.contains("heart"):
            return "heart.fill"
        case title.contains("work"), title.contains("office"):
            return "briefcase.fill"
        case title.contains("school"), title.contains("study"):
            return "book.fill"
        case title.contains("family"), title.contains("friend"):
            return "person.2.fill"
        case title.contains("journey"), title.contains("travel"):
            return "airplane.departure"
        default:
            return "moon.stars.fill"
        }
    }
    
    // Function that triggers when the dream interpreter tile is clicked
    private func handleDreamInterpreterClick() {
        // Check if user can interpret dreams before showing the flow
        if subscriptionService.canInterpretDream() {
            showingDreamEntry = true
        } else {
            // No free attempts left, show subscription view directly
            showingSubscription = true
        }
    }
}

struct ShortPromoView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var subscriptionService = SubscriptionService.shared
    let onDismiss: () -> Void
    
    @State private var isLoading = false
    @State private var buttonScale = 0.95
    @State private var showGlow = false
    @State private var elementOpacity: Double = 0.0
    
    // Gradient background colors
    private let backgroundGradientStart = Color(red: 48/255, green: 25/255, blue: 94/255)
    private let backgroundGradientEnd = Color(red: 80/255, green: 49/255, blue: 149/255)
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [backgroundGradientStart, backgroundGradientEnd]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Main content
            VStack(spacing: 16) {
                // Gift icon
                ZStack {
                    Circle()
                        .fill(Color(.systemBackground))
                        .frame(width: 70, height: 70)
                        .shadow(color: primaryPurple.opacity(0.5), radius: 10)
                    
                    Image(systemName: "gift.fill")
                        .font(.system(size: 34))
                        .foregroundColor(primaryPurple)
                }
                .padding(.top, 24)
                .opacity(elementOpacity)
                
                // Title
                Text("Special Trial Offer")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 4)
                    .opacity(elementOpacity)
                
                // Price
                HStack(spacing: 10) {
                    Text("$19.99/mo")
                        .strikethrough()
                        .foregroundColor(.white.opacity(0.7))
                        .font(.system(size: 18))
                    
                    Text("$0.99")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("(95% OFF)")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Color(red: 95/255, green: 220/255, blue: 110/255))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.green.opacity(0.15))
                                .overlay(
                                    Capsule()
                                        .strokeBorder(Color.green.opacity(0.3), lineWidth: 1)
                                )
                        )
                }
                .padding(.top, 8)
                .opacity(elementOpacity)
                
                // Features box
                VStack(alignment: .leading, spacing: 12) {
                    Text("PREMIUM BENEFITS:")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white.opacity(0.8))
                        .tracking(1)
                        .padding(.bottom, 2)
                    
                    PromoFeatureRow(icon: "sparkles", text: "Unlimited Dream Interpretations")
                    PromoFeatureRow(icon: "moon.fill", text: "Advanced AI Dream Analysis")
                    PromoFeatureRow(icon: "chart.bar.fill", text: "Personalized Dream Insights")
                    PromoFeatureRow(icon: "brain.head.profile", text: "Deep Symbolism Analysis")
                    PromoFeatureRow(icon: "person.text.rectangle", text: "Personalized Recommendations")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.08))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(Color.white.opacity(0.15), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .opacity(elementOpacity)
                
                // Limited time badge
                HStack(spacing: 8) {
                    Image(systemName: "timer")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                    
                    Text("LIMITED TIME OFFER")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .tracking(0.5)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
                .background(
                    Capsule()
                        .fill(Color(red: 155/255, green: 105/255, blue: 235/255).opacity(0.3))
                        .overlay(
                            Capsule()
                                .strokeBorder(Color.white.opacity(0.2), lineWidth: 1)
                        )
                )
                .padding(.top, 8)
                .opacity(elementOpacity)
                
                // Buttons
                VStack(spacing: 12) {
                    Button {
                        hapticFeedback()
                        purchasePromoSubscription()
                    } label: {
                        ZStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(1.2)
                            } else {
                                Text("TRY FOR $0.99")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                    .tracking(0.5)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 155/255, green: 105/255, blue: 235/255),
                                    Color(red: 125/255, green: 85/255, blue: 205/255)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(Color.white.opacity(0.22), lineWidth: 1)
                            )
                        )
                        .shadow(color: primaryPurple.opacity(0.4), radius: 5, x: 0, y: 3)
                    }
                    .scaleEffect(buttonScale)
                    .opacity(elementOpacity)
                    
                    Button {
                        dismiss()
                        onDismiss()
                    } label: {
                        Text("Maybe Later")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .opacity(elementOpacity)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                
                // Terms text
                Text("$0.99 - introductory offer, yearly subscription automatically renews after first month.")
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 16)
                    .padding(.horizontal, 20)
                    .opacity(elementOpacity)
            }
            
            // Close button
            VStack {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                        onDismiss()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.2))
                                .frame(width: 30, height: 30)
                            
                            Image(systemName: "xmark")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(16)
                }
                Spacer()
            }
        }
        .onAppear {
            loadPromoProduct()
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeIn(duration: 0.5)) {
            elementOpacity = 1.0
        }
        
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            buttonScale = 1.0
        }
    }
    
    private func hapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    private func loadPromoProduct() {
        Task {
            await subscriptionService.loadPromoProduct()
        }
    }
    
    private func purchasePromoSubscription() {
        guard !isLoading else { return }
        
        let productID = "lunara.subscription.yearlypromo"
        
        guard let product = subscriptionService.getProduct(for: productID) else {
            print("Product not found: \(productID)")
            
            if subscriptionService.products.isEmpty {
                Task {
                    await subscriptionService.loadProducts()
                    await subscriptionService.loadPromoProduct()
                }
            }
            return
        }
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            buttonScale = 0.96
        }
        
        isLoading = true
        
        Task {
            do {
                let success = try await subscriptionService.purchase(product)
                
                await MainActor.run {
                    isLoading = false
                    
                    if success {
                        dismiss()
                        onDismiss()
                    } else {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            buttonScale = 1.0
                        }
                    }
                }
            } catch {
                print("Purchase error: \(error.localizedDescription)")
                
                await MainActor.run {
                    isLoading = false
                    
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        buttonScale = 1.0
                    }
                }
            }
        }
    }
}

struct PromoFeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
            
            Text(text)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
                .lineLimit(1)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
} 