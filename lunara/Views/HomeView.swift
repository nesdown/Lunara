import SwiftUI
import Models
import StoreKit

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var themeSettings: ThemeSettings
    @State private var showingDreamEntry = false
    @State private var showingDreamDetails = false
    @State private var selectedDream: DreamEntry?
    @State private var showBiorythmAnalysis = false
    
    // Custom colors
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    
    // Dreams data
    @State private var latestDreams: [DreamEntry] = []
    
    // Helper property to check if dark mode is active
    private var isDarkMode: Bool {
        return themeSettings.colorScheme == .dark
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
                        rightButtons: [
                            TopBarButton(icon: "gift.fill", action: {
                                // No functionality for now
                            }),
                            TopBarButton(icon: "star.fill", action: {
                                // No functionality for now
                            }),
                            TopBarButton(icon: isDarkMode ? "sun.max.fill" : "moon.fill", action: {
                                // Toggle between light and dark mode
                                themeSettings.colorScheme = isDarkMode ? .light : .dark
                            })
                        ]
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
                                    showingDreamEntry = true
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
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(.white)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .strokeBorder(lightPurple, lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 4)
                            
                            // Premium Features Card
                            VStack(spacing: 0) {
                                HStack(alignment: .center, spacing: 16) {
                                    // Left part - Icon
                                    ZStack {
                                        Circle()
                                            .fill(lightPurple)
                                            .frame(width: 70, height: 70)
                                        Image(systemName: "star.fill")
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
                                
                                Button {} label: {
                                    HStack(spacing: 8) {
                                        Image(systemName: "star.fill")
                                            .font(.system(size: 16, weight: .semibold))
                                        Text("UPGRADE TO PREMIUM")
                                            .font(.system(size: 16, weight: .semibold))
                                    }
                                    .foregroundColor(primaryPurple)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                }
                                .padding(.horizontal, 16)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(.white)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .strokeBorder(lightPurple, lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 4)
                            
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
                                    showBiorythmAnalysis = true
                                } label: {
                                    HStack(spacing: 8) {
                                        Image(systemName: "chart.bar.fill")
                                            .font(.system(size: 16, weight: .semibold))
                                        Text("BEGIN ANALYSIS")
                                            .font(.system(size: 16, weight: .semibold))
                                    }
                                    .foregroundColor(primaryPurple)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                }
                                .padding(.horizontal, 16)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(.white)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .strokeBorder(lightPurple, lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 4)
                            
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
                                    .fill(.white)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .strokeBorder(lightPurple, lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 4)
                            
                            // Action Buttons
                            VStack(spacing: 16) {
                                Button {
                                    // Open premium upgrade flow or in-app purchase
                                    HapticManager.shared.buttonPress()
                                    // This would typically open your in-app purchase flow
                                    // For now, we'll just provide a placeholder
                                    print("User tapped to unlock premium features")
                                    // TODO: Implement in-app purchase flow here
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
                                
                                Button {
                                    // Request app store review
                                    HapticManager.shared.buttonPress()
                                    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                                        if #available(iOS 18.0, *) {
                                            StoreKit.AppStore.requestReview(in: scene)
                                        } else {
                                            SKStoreReviewController.requestReview(in: scene)
                                        }
                                    }
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
                                
                                Button {
                                    // Open Contact Support URL
                                    HapticManager.shared.buttonPress()
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
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
} 