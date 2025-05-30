import SwiftUI
import Models
import Foundation
import AVFoundation

// MoodService for saving/retrieving daily mood data
class MoodService {
    static let shared = MoodService()
    
    private let userDefaults = UserDefaults.standard
    private let moodKeyPrefix = "userMood_"
    
    // Save mood for a specific date
    func saveMood(_ mood: MoodOption, for date: Date) {
        let dateKey = dateToKey(date)
        userDefaults.set(mood.rawValue, forKey: moodKeyPrefix + dateKey)
    }
    
    // Get mood for a specific date
    func getMood(for date: Date) -> MoodOption? {
        let dateKey = dateToKey(date)
        if let moodString = userDefaults.string(forKey: moodKeyPrefix + dateKey) {
            return MoodOption(rawValue: moodString)
        }
        return nil
    }
    
    // Check if mood exists for a specific date
    func hasMoodForToday() -> Bool {
        let today = Date()
        return getMood(for: today) != nil
    }
    
    // Convert date to a string key (YYYY-MM-DD format)
    private func dateToKey(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

// Biography Service for saving/retrieving biography data
class BiographyService {
    static let shared = BiographyService()
    
    private let userDefaults = UserDefaults.standard
    private let biographyKey = "userBiography"
    private let biographyStructuredKey = "userBiographyStructured"
    
    func saveBiography(_ text: String) {
        userDefaults.set(text, forKey: biographyKey)
    }
    
    func getBiography() -> String {
        return userDefaults.string(forKey: biographyKey) ?? ""
    }
    
    func saveStructuredBiography(_ biography: StructuredBiography) {
        if let encoded = try? JSONEncoder().encode(biography) {
            userDefaults.set(encoded, forKey: biographyStructuredKey)
        }
    }
    
    func getStructuredBiography() -> StructuredBiography {
        if let data = userDefaults.data(forKey: biographyStructuredKey),
           let biography = try? JSONDecoder().decode(StructuredBiography.self, from: data) {
            return biography
        }
        return StructuredBiography()
    }
    
    func hasBiography() -> Bool {
        return !getBiography().isEmpty || !getStructuredBiography().isEmpty
    }
}

// Structured biography model
struct StructuredBiography: Codable {
    var lifestyle: Set<Lifestyle> = []
    var sleepHabits: Set<SleepHabit> = []
    var personalFactors: Set<PersonalFactor> = []
    var healthFactors: Set<HealthFactor> = []
    var dailyActivities: Set<DailyActivity> = []
    var additionalNotes: String = ""
    
    var isEmpty: Bool {
        return lifestyle.isEmpty && 
               sleepHabits.isEmpty && 
               personalFactors.isEmpty &&
               healthFactors.isEmpty &&
               dailyActivities.isEmpty &&
               additionalNotes.isEmpty
    }
    
    // Helper method to get a summary
    func getSummary() -> String {
        var summary = ""
        
        if !lifestyle.isEmpty {
            summary += "Lifestyle: " + lifestyle.map { $0.rawValue }.joined(separator: ", ") + ". "
        }
        
        if !sleepHabits.isEmpty {
            summary += "Sleep: " + sleepHabits.map { $0.rawValue }.joined(separator: ", ") + ". "
        }
        
        if !personalFactors.isEmpty {
            summary += "Personal: " + personalFactors.map { $0.rawValue }.joined(separator: ", ") + ". "
        }
        
        if !healthFactors.isEmpty {
            summary += "Health: " + healthFactors.map { $0.rawValue }.joined(separator: ", ") + ". "
        }
        
        if !dailyActivities.isEmpty {
            summary += "Activities: " + dailyActivities.map { $0.rawValue }.joined(separator: ", ") + ". "
        }
        
        if !additionalNotes.isEmpty {
            if !summary.isEmpty {
                summary += "\n"
            }
            summary += additionalNotes
        }
        
        return summary
    }
}

// Enums for structured biography options
enum Lifestyle: String, Codable, CaseIterable, Identifiable {
    case urban = "Urban Living"
    case suburban = "Suburban Living"
    case rural = "Rural Living"
    case highStress = "High-Stress Job"
    case creative = "Creative Field"
    case technical = "Technical Field"
    case activeTravel = "Frequent Travel"
    case student = "Student"
    case parent = "Parent"
    
    var id: String { self.rawValue }
}

enum SleepHabit: String, Codable, CaseIterable, Identifiable {
    case earlyRiser = "Early Riser"
    case nightOwl = "Night Owl"
    case lightSleeper = "Light Sleeper"
    case deepSleeper = "Deep Sleeper"
    case irregular = "Irregular Sleep Schedule"
    case sleeplessNights = "Occasional Sleepless Nights"
    case napTaker = "Regular Napper"
    
    var id: String { self.rawValue }
}

enum PersonalFactor: String, Codable, CaseIterable, Identifiable {
    case highlyCreative = "Highly Creative"
    case analytical = "Analytical Thinker"
    case vivid = "Vivid Imagination"
    case spiritual = "Spiritual/Mystical"
    case rational = "Rational/Logical"
    case empathetic = "Highly Empathetic"
    case introvert = "Introvert"
    case extrovert = "Extrovert"
    
    var id: String { self.rawValue }
}

enum HealthFactor: String, Codable, CaseIterable, Identifiable {
    case meditation = "Regular Meditation"
    case exercise = "Regular Exercise"
    case chronicIssue = "Chronic Health Issue"
    case anxiety = "Anxiety"
    case depression = "Depression"
    case useMedication = "Taking Medication"
    case headaches = "Frequent Headaches"
    case vitaminSupplement = "Take Vitamins/Supplements"
    
    var id: String { self.rawValue }
}

enum DailyActivity: String, Codable, CaseIterable, Identifiable {
    case screenTime = "High Screen Time"
    case reading = "Regular Reading"
    case gaming = "Video Games"
    case outdoorTime = "Outdoor Activities"
    case sports = "Sports/Athletics"
    case arts = "Arts/Crafts"
    case socializing = "Active Social Life"
    case cooking = "Cooking/Baking"
    
    var id: String { self.rawValue }
}

extension DateComponents {
    func removingDay() -> DateComponents {
        var components = self
        components.day = nil
        return components
    }
}

enum MoodOption: String, CaseIterable, Identifiable, Hashable {
    case happy
    case calm
    case thoughtful
    case confused
    case sad
    
    var id: String { self.rawValue }
    
    var emoji: String {
        switch self {
        case .happy: return "😊" 
        case .calm: return "😌"
        case .thoughtful: return "🤔"
        case .confused: return "😕"
        case .sad: return "😢"
        }
    }
    
    var description: String {
        switch self {
        case .happy: return "Happy"
        case .calm: return "Calm"
        case .thoughtful: return "Thoughtful" 
        case .confused: return "Confused"
        case .sad: return "Sad"
        }
    }
}

struct DreamIndicator: View {
    let count: Int
    let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    
    var body: some View {
        if count == 1 {
            Image(systemName: "moon.stars.fill")
                .font(.system(size: 10))
                .foregroundColor(primaryPurple)
        } else {
            ZStack {
                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 10))
                    .foregroundColor(primaryPurple)
                Text("\(count)")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundColor(.white)
                    .padding(2)
                    .background(
                        Circle()
                            .fill(primaryPurple)
                    )
                    .offset(x: 6, y: -6)
            }
        }
    }
}

struct DreamListItem: View {
    let dream: DreamEntry
    let isLast: Bool
    let primaryPurple: Color
    let onTap: () -> Void
    @State private var isPressed = false
    @State private var isAppearing = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
            Button(action: {
            // Give haptic feedback when tapped
            HapticManager.shared.itemSelected()
            
            // Set pressed state briefly
            isPressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                isPressed = false
                // Delay the actual tap action slightly to ensure UI state is updated
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    onTap()
                }
            }
            }) {
                HStack(spacing: 12) {
                // Dream icon with animation
                ZStack {
                    Circle()
                        .fill(DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.3 : 1.0))
                        .frame(width: 40, height: 40)
                        .shadow(color: primaryPurple.opacity(0.2), radius: isPressed ? 4 : 2, x: 0, y: isPressed ? 1 : 2)
                    
                    Image(systemName: getDreamIcon(for: dream.dreamName))
                        .font(.system(size: 18))
                        .foregroundColor(primaryPurple)
                        .scaleEffect(isPressed ? 0.9 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
                }
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
                
                // Dream details
                VStack(alignment: .leading, spacing: 4) {
                    Text(dream.dreamName)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(DynamicColors.textPrimary)
                    
                    Text(formattedDate(dream.createdAt))
                        .font(.system(size: 12))
                        .foregroundColor(DynamicColors.textSecondary)
                }
                
                    Spacer()
                
                // Chevron with animation
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(DynamicColors.textSecondary)
                    .opacity(0.6)
                    .offset(x: isPressed ? 5 : 0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(DynamicColors.backgroundSecondary)
                    .opacity(isPressed ? 0.7 : 1.0)
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .offset(x: isPressed ? 5 : 0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
            .opacity(isAppearing ? 1 : 0)
            .offset(y: isAppearing ? 0 : 20)
            .onAppear {
                withAnimation(AppAnimation.gentleSpring.delay(0.1)) {
                    isAppearing = true
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.bottom, isLast ? 0 : 8)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
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

struct EmptyDreamsView: View {
    let primaryPurple: Color
    @State private var isAppearing = false
    @State private var isSparkleAnimating = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                // Sparkle background effect
                ForEach(0..<3) { i in
                    Circle()
                        .fill(primaryPurple.opacity(colorScheme == .dark ? 0.2 : 0.1))
                        .frame(width: 8, height: 8)
                        .offset(
                            x: cos(Angle(degrees: Double(i) * 120 + (isSparkleAnimating ? 360 : 0)).radians) * 30,
                            y: sin(Angle(degrees: Double(i) * 120 + (isSparkleAnimating ? 360 : 0)).radians) * 30
                        )
                        .opacity(isAppearing ? 0.8 : 0)
                }
                
                Image(systemName: "sparkles.square.filled.on.square")
                    .font(.system(size: 32))
                    .foregroundColor(primaryPurple.opacity(colorScheme == .dark ? 0.7 : 0.5))
                    .scaleEffect(isAppearing ? 1.0 : 0.7)
                    .rotationEffect(Angle(degrees: isAppearing ? 0 : -10))
                    .shadow(color: primaryPurple.opacity(0.3), radius: isAppearing ? 5 : 0, x: 0, y: 0)
            }
            .animation(Animation.spring(response: 0.6, dampingFraction: 0.7), value: isAppearing)
            
            Text("No dreams logged for this magical night ✨")
                .font(.system(size: 16))
                .foregroundColor(DynamicColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .opacity(isAppearing ? 1.0 : 0.0)
                .offset(y: isAppearing ? 0 : 10)
                .animation(Animation.spring(response: 0.6, dampingFraction: 0.7).delay(0.1), value: isAppearing)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .onAppear {
            // Trigger appearance animations
            withAnimation {
                isAppearing = true
            }
            
            // Start sparkle animation
            withAnimation(Animation.linear(duration: 8).repeatForever(autoreverses: false)) {
                isSparkleAnimating = true
            }
        }
    }
}

struct BiographyInputView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Binding var parentBiography: String
    
    // View state
    @State private var currentStep = 1
    @State private var isAppearing = false
    @State private var isSaving = false
    
    // Structured biography data
    @State private var biography = BiographyService.shared.getStructuredBiography()
    @State private var additionalNotes = ""
    
    // For keyboard avoidance
    @FocusState private var isTextFieldFocused: Bool
    @State private var keyboardHeight: CGFloat = 0
    
    // Colors
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Top bar with title and close button
                    HStack {
                        Spacer()
                        
                        Text("Your Biography")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.secondary)
                        }
                        .padding(.trailing)
                    }
                    .padding(.top)
                    .padding(.bottom, 8)
                    
                    // Progress indicator
                    ProgressBar(currentStep: currentStep, totalSteps: 6)
                        .padding(.horizontal)
                        .padding(.bottom, 16)
                    
                    // Main content with step navigation
                ScrollView {
                    VStack(spacing: 24) {
                            // Content based on current step
                            switch currentStep {
                            case 1:
                                introductionView
                            case 2:
                                lifestyleView
                            case 3:
                                sleepHabitsView
                            case 4:
                                personalFactorsView
                            case 5:
                                healthFactorsView
                            case 6:
                                dailyActivitiesView
                            case 7:
                                additionalNotesView
                            default:
                                EmptyView()
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 80)
                    }
                    
                    // Navigation buttons
                    HStack(spacing: 16) {
                        // Back button (except on first step)
                        if currentStep > 1 {
                            Button {
                                withAnimation {
                                    currentStep -= 1
                                }
                            } label: {
                                Text("Back")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .padding(.vertical, 16)
                                    .frame(maxWidth: .infinity)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(24)
                            }
                        }
                        
                        // Continue/Next button
                        Button {
                            // Add haptic feedback
                            HapticManager.shared.buttonPress()
                            
                            withAnimation {
                                if currentStep == 7 {
                                    // Last step - save data
                                    saveAndDismiss()
                                } else {
                                    currentStep += 1
                                }
                            }
                        } label: {
                            Text(currentStep == 7 ? "Save" : "Continue")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                                .background(primaryPurple)
                                .cornerRadius(24)
                        }
                    }
                    .padding()
                    .background(
                        Rectangle()
                            .fill(Color(.systemBackground))
                            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: -5)
                    )
                }
            }
            .onAppear {
                // Trigger appearance animations
                withAnimation(AppAnimation.gentleSpring) {
                    isAppearing = true
                }
                
                // Load existing data if available
                additionalNotes = biography.additionalNotes
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
                if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    keyboardHeight = keyboardFrame.height
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                keyboardHeight = 0
            }
        }
    }
    
    // MARK: - Step Views
    
    private var introductionView: some View {
        VStack(alignment: .leading, spacing: 16) {
                                Image(systemName: "person.text.rectangle.fill")
                .font(.system(size: 50))
                                    .foregroundColor(primaryPurple)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 4)
            
            Text("About Your Biography")
                .font(.title3)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("Tell us about yourself to help Lunara better analyze your dreams. Your personal details provide context that helps create more accurate and personalized interpretations.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .lineSpacing(2)
                .padding(.bottom, 4)
            
            Text("The information is stored securely on your device and is never shared with third parties.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 8)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(colorScheme == .dark ? Color(.systemGray6) : .white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .strokeBorder(lightPurple, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 4)
    }
    
    private var lifestyleView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Lifestyle")
                .font(.title3)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("Select all options that apply to your current lifestyle.")
                .font(.subheadline)
                                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 8)
            
            VStack(spacing: 10) {
                ForEach(Lifestyle.allCases) { option in
                    CheckboxRow(
                        title: option.rawValue,
                        isSelected: biography.lifestyle.contains(option),
                        action: {
                            toggleSelection(option, in: &biography.lifestyle)
                        }
                    )
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(colorScheme == .dark ? Color(.systemGray6) : .white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .strokeBorder(lightPurple, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 4)
    }
    
    private var sleepHabitsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Sleep Habits")
                .font(.title3)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("Select all options that describe your typical sleep patterns.")
                .font(.subheadline)
                            .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 8)
            
            VStack(spacing: 10) {
                ForEach(SleepHabit.allCases) { option in
                    CheckboxRow(
                        title: option.rawValue,
                        isSelected: biography.sleepHabits.contains(option),
                        action: {
                            toggleSelection(option, in: &biography.sleepHabits)
                        }
                    )
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(colorScheme == .dark ? Color(.systemGray6) : .white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .strokeBorder(lightPurple, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 4)
    }
    
    private var personalFactorsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Personality")
                .font(.title3)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("Select all options that describe your personality traits.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 8)
            
            VStack(spacing: 10) {
                ForEach(PersonalFactor.allCases) { option in
                    CheckboxRow(
                        title: option.rawValue,
                        isSelected: biography.personalFactors.contains(option),
                        action: {
                            toggleSelection(option, in: &biography.personalFactors)
                        }
                    )
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(colorScheme == .dark ? Color(.systemGray6) : .white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .strokeBorder(lightPurple, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 4)
    }
    
    private var healthFactorsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Health Factors")
                .font(.title3)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("Select any health factors that may influence your dreams.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 8)
            
            VStack(spacing: 10) {
                ForEach(HealthFactor.allCases) { option in
                    CheckboxRow(
                        title: option.rawValue,
                        isSelected: biography.healthFactors.contains(option),
                        action: {
                            toggleSelection(option, in: &biography.healthFactors)
                        }
                    )
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(colorScheme == .dark ? Color(.systemGray6) : .white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .strokeBorder(lightPurple, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 4)
    }
    
    private var dailyActivitiesView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Daily Activities")
                .font(.title3)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("Select activities that are regular parts of your daily life.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 8)
            
            VStack(spacing: 10) {
                ForEach(DailyActivity.allCases) { option in
                    CheckboxRow(
                        title: option.rawValue,
                        isSelected: biography.dailyActivities.contains(option),
                        action: {
                            toggleSelection(option, in: &biography.dailyActivities)
                        }
                    )
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(colorScheme == .dark ? Color(.systemGray6) : .white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .strokeBorder(lightPurple, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 4)
    }
    
    private var additionalNotesView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Additional Information")
                .font(.title3)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("Is there anything else you'd like to share that might help with your dream analysis?")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 8)
            
                                ZStack(alignment: .bottomTrailing) {
                TextEditor(text: $additionalNotes)
                    .frame(minHeight: 150)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(colorScheme == .dark ? Color(white: 0.2) : Color(white: 0.95))
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .strokeBorder(primaryPurple.opacity(0.15), lineWidth: 1.5)
                                        )
                                        .overlay(
                                            Group {
                            if additionalNotes.isEmpty {
                                Text("Optional: Any other relevant details about yourself...")
                                                        .foregroundColor(.secondary)
                                                        .padding(.horizontal, 24)
                                                        .padding(.vertical, 24)
                                                        .allowsHitTesting(false)
                                                }
                                            },
                                            alignment: .topLeading
                                        )
                                        .focused($isTextFieldFocused)
                                    
                                    VoiceInputButton(color: primaryPurple) { text in
                    if additionalNotes.isEmpty {
                        additionalNotes = text
                                        } else {
                        additionalNotes += " " + text
                                        }
                                        // Add haptic feedback when text is updated
                                        HapticManager.shared.success()
                                    }
                                    .padding([.bottom, .trailing], 16)
            }
            
            if isTextFieldFocused {
                Button("Done") {
                    isTextFieldFocused = false
                }
                .foregroundColor(primaryPurple)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 8)
            }
            
            Text("Your information is stored locally on your device and used to enhance your dream analysis.")
                .font(.caption)
                    .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 16)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(colorScheme == .dark ? Color(.systemGray6) : .white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .strokeBorder(lightPurple, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 4)
        .padding(.bottom, keyboardHeight > 0 ? keyboardHeight - 120 : 0) // Adjust for keyboard
    }
    
    // MARK: - Helper Methods
    
    // Generic function to toggle selection for any option type
    private func toggleSelection<T: Hashable>(_ option: T, in set: inout Set<T>) {
        if set.contains(option) {
            set.remove(option)
        } else {
            set.insert(option)
        }
        // Add haptic feedback
        HapticManager.shared.light()
    }
    
    private func saveAndDismiss() {
        // First dismiss keyboard if active
        isTextFieldFocused = false
        
        // Show saving animation
        isSaving = true
        
        // Give haptic feedback
        HapticManager.shared.success()
        
        // Update notes in biography
        biography.additionalNotes = additionalNotes
        
        // Save to BiographyService
        BiographyService.shared.saveStructuredBiography(biography)
        
        // Generate and save text format for compatibility
        let summaryText = biography.getSummary()
        BiographyService.shared.saveBiography(summaryText)
            
            // Update parent state
        parentBiography = summaryText
            
            // Dismiss the sheet
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            dismiss()
        }
    }
}

// MARK: - Helper Components

struct CheckboxRow: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    @Environment(\.colorScheme) var colorScheme
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(.primary)
                
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(isSelected ? primaryPurple : Color.gray, lineWidth: 1.5)
                        .frame(width: 22, height: 22)
                    
                    if isSelected {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(primaryPurple)
                            .frame(width: 22, height: 22)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? 
                         lightPurple.opacity(0.3) : 
                         (colorScheme == .dark ? Color(.systemGray5) : Color.white))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? primaryPurple : Color.clear, lineWidth: 1)
            )
        }
    }
}

// Progress bar component (reused from BiorythmAnalysisFlow)
struct ProgressBar: View {
    let currentStep: Int
    let totalSteps: Int
    
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background track
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemGray5))
                    .frame(width: geometry.size.width, height: 8)
                
                // Filled portion
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [primaryPurple, primaryPurple.opacity(0.7)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: min(CGFloat(currentStep) / CGFloat(totalSteps) * geometry.size.width, geometry.size.width), height: 8)
                    .animation(.spring(response: 0.4, dampingFraction: 0.6), value: currentStep)
            }
        }
        .frame(height: 8)
    }
}

// DreamSymbol struct for symbols library
struct DreamSymbol: Identifiable {
    let id = UUID()
    let name: String
    let iconName: String
    let shortDescription: String
    let detailedDescription: String
    
    // Categories to organize symbols
    let category: SymbolCategory
    
    static let allSymbols: [DreamSymbol] = [
        DreamSymbol(
            name: "Butterfly",
            iconName: "waveform.path.ecg",
            shortDescription: "Transformation and personal growth",
            detailedDescription: "Butterflies in dreams symbolize transformation, change, and the soul. They represent the process of metamorphosis in your life - shedding old ways and embracing new beginnings. Seeing a butterfly in your dream often indicates you're going through or need to embrace personal evolution and growth.\n\nIf the butterfly is brightly colored, it suggests joy and positivity in your transformation. If it's struggling to fly, you may be facing obstacles in your personal development. Multiple butterflies may represent different aspects of yourself evolving simultaneously.",
            category: .nature
        ),
        DreamSymbol(
            name: "Flying",
            iconName: "airplane",
            shortDescription: "Freedom, perspective, and rising above limitations",
            detailedDescription: "Dreams of flying typically represent freedom, transcendence, and the ability to rise above limitations or problems. How easily you fly in the dream is significant.\n\nEffortless flying suggests confidence and a sense of freedom in waking life. Struggling to stay airborne might indicate obstacles or insecurities holding you back. Flying very high could represent ambition or spiritual seeking, while flying close to the ground might suggest caution or fear of taking risks.\n\nThe context is important - flying to escape something indicates avoidance, while flying toward something shows motivation and goal-directed behavior.",
            category: .actions
        ),
        DreamSymbol(
            name: "Teeth",
            iconName: "face.smiling",
            shortDescription: "Anxiety, appearance, and communication",
            detailedDescription: "Dreams about teeth, especially losing them, are among the most common dreams worldwide. They often relate to anxieties about appearance, communication, or power.\n\nLosing teeth frequently symbolizes fear of embarrassment, loss of attractiveness, or concerns about making a good impression. Breaking teeth might represent powerlessness in a situation. Having perfect teeth could indicate confidence in social situations.\n\nIn some interpretations, teeth dreams relate to communication - what we say and how we express ourselves. Teeth problems might suggest difficulties in expressing yourself clearly or anxiety about how your words will be received.",
            category: .body
        ),
        DreamSymbol(
            name: "Water",
            iconName: "water.waves",
            shortDescription: "Emotions and the subconscious mind",
            detailedDescription: "Water is one of the most common and powerful dream symbols, representing your emotional state and subconscious mind. The condition of the water reflects your emotional wellbeing.\n\nCalm, clear water suggests emotional clarity and peace. Turbulent or stormy water indicates emotional turmoil. Deep water represents the depths of your subconscious or overwhelming feelings. Shallow water might suggest superficial emotions.\n\nOceans often symbolize the collective unconscious or vast emotional landscapes, while rivers represent the flow of your life journey and how you navigate emotional changes.",
            category: .elements
        ),
        DreamSymbol(
            name: "House",
            iconName: "house",
            shortDescription: "Self and different aspects of personality",
            detailedDescription: "Houses in dreams typically represent the self - the different rooms often symbolize different aspects of your personality or life. The condition of the house reflects how you perceive yourself.\n\nA new house might represent new beginnings or self-discovery. An abandoned or decaying house could indicate neglected aspects of yourself. Hidden rooms often represent undiscovered talents or repressed memories.\n\nThe basement frequently symbolizes the subconscious or repressed thoughts, while the attic might represent spiritual aspects or stored memories. The kitchen often relates to nourishment and how you care for yourself emotionally.",
            category: .places
        ),
        DreamSymbol(
            name: "Snake",
            iconName: "arrow.triangle.turn.up.right.diamond",
            shortDescription: "Transformation, healing, and hidden fears",
            detailedDescription: "Snakes are complex dream symbols with dual meanings. They can represent transformation, renewal, and healing (as in the medical caduceus symbol), but also hidden fears, toxic situations, or deception.\n\nA shedding snake suggests personal transformation and leaving behind old patterns. A coiled snake might represent potential energy or creative power waiting to be released. Being bitten by a snake could symbolize a fear of being hurt by something toxic in your life.\n\nThe color of the snake adds meaning - black snakes often connect to the unknown or unconscious, while colorful snakes might represent more visible or conscious challenges. Multiple snakes could indicate feeling overwhelmed by fears or transformative forces.",
            category: .animals
        ),
        DreamSymbol(
            name: "Door",
            iconName: "door.right.hand.open",
            shortDescription: "Opportunities, transitions, and choices",
            detailedDescription: "Doors in dreams symbolize opportunities, transitions, and choices. How you interact with the door and what lies beyond it are significant elements.\n\nAn open door represents available opportunities or a welcoming attitude. A closed door suggests unknown possibilities or challenges that require effort to overcome. A locked door might indicate obstacles, limitations, or opportunities that aren't yet accessible to you.\n\nMultiple doors represent different choices or paths available. The condition of the door - whether new, old, broken, etc. - offers insight into how you perceive the opportunity or transition it represents. Walking through a door symbolizes making a transition or accepting a new phase in your life.",
            category: .objects
        ),
        DreamSymbol(
            name: "Baby",
            iconName: "figure.child",
            shortDescription: "New beginnings, vulnerability, and growth potential",
            detailedDescription: "Dreams about babies typically symbolize new beginnings, innocence, and aspects of yourself that are still developing. Babies represent potential and the start of something new in your life.\n\nHolding a baby might indicate nurturing a new project, relationship, or aspect of yourself. A crying baby could symbolize neglected needs or aspects of yourself requiring attention. Finding or losing a baby in a dream often relates to discovering or losing touch with new opportunities or your own innocence and potential.\n\nThe baby's condition is meaningful - a healthy, happy baby suggests positive growth and development, while a distressed baby might indicate vulnerabilities or new ventures that need more care and attention.",
            category: .people
        ),
        DreamSymbol(
            name: "Mountain",
            iconName: "mountain.2",
            shortDescription: "Challenges, aspirations, and spiritual journey",
            detailedDescription: "Mountains in dreams symbolize challenges, ambitions, and the spiritual journey. They represent both obstacles to overcome and elevated perspectives to achieve.\n\nClimbing a mountain suggests making progress toward your goals, with the difficulty of the climb reflecting the challenges you face. Reaching the summit represents achievement, clarity, and expanded awareness. Being unable to climb or falling might indicate setbacks or fears about your ability to overcome challenges.\n\nA distant mountain often symbolizes long-term aspirations or spiritual goals. The condition of the mountain - whether snow-capped, volcanic, lush, or barren - adds layers of meaning about the nature of the challenges or aspirations it represents in your life.",
            category: .nature
        ),
        DreamSymbol(
            name: "Clock",
            iconName: "clock",
            shortDescription: "Time awareness, pressure, and life transitions",
            detailedDescription: "Clocks and timepieces in dreams typically relate to your relationship with time - including time pressure, fear of missed opportunities, or awareness of life transitions.\n\nA ticking clock often represents time pressure or anxiety about deadlines. A stopped or broken clock might symbolize feeling that time has stopped or a desire to escape time constraints. Fast-moving clock hands can indicate anxiety about time passing too quickly.\n\nOld-fashioned clocks (like grandfather clocks) might relate to connections with the past or traditional values. Digital clocks could represent modern pressures or precision timing. Dreaming of being late or watching the time frequently suggests fear of missing opportunities or not meeting expectations - either your own or others'.",
            category: .objects
        ),
        DreamSymbol(
            name: "Fire",
            iconName: "flame",
            shortDescription: "Passion, transformation, and purification",
            detailedDescription: "Fire in dreams often symbolizes passion, transformation, and the purification of ideas or situations in your life. The nature of the fire provides insight into its specific meaning.\n\nControlled fire, like a campfire or fireplace, often represents contained passion, comfort, or healthy transformation. Raging, destructive fire might indicate overwhelming emotions, anger, or dramatic change that's destroying something in your life. Being burned can suggest you're playing with dangerous emotions or situations.\n\nFire can also represent enlightenment and spiritual awakening, similar to how many religious traditions view fire as purifying or representative of divine presence. Standing near flames might suggest you're ready for – or in the midst of – a dramatic personal transformation.",
            category: .elements
        ),
        DreamSymbol(
            name: "Bridge",
            iconName: "network",
            shortDescription: "Transitions, connections, and crossing difficulties",
            detailedDescription: "Bridges in dreams symbolize transitions, connections, and ways of overcoming obstacles. They represent a passage from one state of being to another.\n\nCrossing a bridge often indicates moving from one life phase to another. A sturdy, safe bridge suggests confidence in your transition, while a damaged or unstable bridge might reflect anxiety about upcoming changes. Being stuck on a bridge represents feeling caught between two situations or indecision about moving forward.\n\nThe environment around the bridge adds meaning – crossing over troubled water suggests overcoming emotional turmoil, while a bridge over a peaceful valley might suggest a more harmonious transition. Burning bridges behind you symbolizes permanent changes or deliberately cutting ties with your past.",
            category: .places
        ),
        DreamSymbol(
            name: "Mirror",
            iconName: "rectangle.on.rectangle",
            shortDescription: "Self-reflection, identity, and reality perception",
            detailedDescription: "Mirrors in dreams represent self-reflection, how you perceive yourself, and sometimes distorted perceptions of reality. What you see in the mirror is significant.\n\nSeeing your actual reflection suggests honest self-awareness. A distorted image might indicate an inaccurate self-perception or identity confusion. Breaking a mirror can symbolize a break with your identity or fear of misfortune.\n\nMultiple mirrors or a hall of mirrors often suggests you're seeing multiple aspects of yourself or experiencing confusion about which version of yourself is authentic. Looking into a mirror and seeing someone else's face might represent identification with that person or recognition of shared qualities. Empty mirrors where your reflection should appear suggest a loss of identity or disconnection from yourself.",
            category: .objects
        ),
        DreamSymbol(
            name: "Car",
            iconName: "car",
            shortDescription: "Personal journey, control, and direction in life",
            detailedDescription: "Cars in dreams typically symbolize your journey through life, your direction, and the control you feel over your path. The condition and circumstances of the car reveal your feelings about your life journey.\n\nDriving smoothly suggests confidence and control over your direction in life. Problems with the car—like brake failures, getting lost, or crashes—indicate anxieties about losing control or encountering obstacles. Being a passenger might suggest you feel others are directing your life.\n\nThe type of car can be meaningful: an expensive luxury car might represent aspirations or how you want others to see you, while an old, reliable car might represent trusted personal values. The landscape you're driving through reflects your emotional environment, and who accompanies you in the car represents influences or relationships affecting your journey.",
            category: .objects
        ),
        DreamSymbol(
            name: "Tree",
            iconName: "leaf",
            shortDescription: "Growth, strength, and personal development",
            detailedDescription: "Trees in dreams symbolize growth, strength, stability, and your connection to your roots and personal development. Different aspects of the tree provide specific insights.\n\nA healthy, strong tree often represents wellbeing, stability, and flourishing personal growth. Dead or dying trees might indicate stagnation, loss, or neglect of your personal development. Climbing a tree can symbolize advancement, ambition, or gaining new perspective.\n\nThe roots represent your foundation, heritage, and connection to your past. The trunk symbolizes your core strength and basic character. Branches represent the different directions your life may take or aspects of yourself. Fruit on the tree often signifies the rewards of your efforts and personal achievements.",
            category: .nature
        ),
        DreamSymbol(
            name: "Lion",
            iconName: "cat",
            shortDescription: "Courage, authority, and personal power",
            detailedDescription: "Lions in dreams typically represent courage, personal power, leadership, and assertiveness. Your interaction with the lion reveals how you relate to these qualities.\n\nA powerful, majestic lion often symbolizes strength, confidence, and self-assurance. A threatening lion might represent fears about asserting yourself or concerns about others' aggression. A tame or friendly lion can indicate successfully harnessing your personal power.\n\nBeing chased by a lion might suggest you're running from responsibilities or challenges that require courage to face. Riding or leading a lion suggests mastery over your own power and instinctive nature. A wounded or caged lion might represent feelings that your power has been restricted or damaged, either by others or your own limiting beliefs.",
            category: .animals
        ),
        DreamSymbol(
            name: "Key",
            iconName: "key",
            shortDescription: "Access, discovery, and new possibilities",
            detailedDescription: "Keys in dreams symbolize access, opportunity, discovery, and solutions. The way you interact with the key and what it opens are significant elements.\n\nFinding a key often represents discovering a solution to a problem or gaining access to hidden knowledge or potential. Losing keys might indicate fear of missing opportunities or losing access to important aspects of yourself. A locked door you can't open suggests frustration with obstacles or a sense that something important remains inaccessible.\n\nMultiple keys could represent choices or different approaches to a situation. A key that doesn't fit or breaks in a lock might symbolize attempts at solutions that aren't working. The material of the key – gold, silver, iron – might also carry symbolic meaning about the value or durability of the opportunity or solution represented.",
            category: .objects
        ),
        DreamSymbol(
            name: "Ocean",
            iconName: "water.waves",
            shortDescription: "Emotions, the unconscious, and life's infinite possibilities",
            detailedDescription: "The ocean in dreams represents the vast unconscious mind, deep emotions, and life's infinite possibilities. The state of the ocean mirrors your emotional landscape.\n\nCalm, clear waters suggest emotional peace and clarity. Stormy seas represent emotional turbulence or overwhelming feelings. Swimming comfortably in the ocean indicates harmony with your emotions, while drowning or struggling suggests feeling overwhelmed by them.\n\nThe depth of the ocean relates to the depths of your unconscious – seeing into clear depths suggests insight into your deeper self, while dark, mysterious depths might represent the unknown or unexplored aspects of your psyche. Creatures emerging from the ocean often symbolize thoughts, memories, or emotions surfacing from your unconscious.",
            category: .elements
        ),
        DreamSymbol(
            name: "Spider",
            iconName: "circle.grid.3x3",
            shortDescription: "Creativity, feminine energy, and feelings of being trapped",
            detailedDescription: "Spiders in dreams have multiple meanings, including creativity, patience, feminine energy, and sometimes feelings of being manipulated or trapped. The context and your feelings about the spider are important.\n\nA spider weaving its web often symbolizes creativity, careful planning, and manifestation of goals. Being caught in a web might suggest feeling trapped in a complicated situation or relationship. A spider biting you could represent feeling hurt by someone manipulative in your life.\n\nIn many traditions, spiders represent the feminine archetype – particularly the aspects related to creation and fate. The intricate patterns of spider webs can also represent interconnectedness and the idea that all actions have consequences that ripple outward. Giant or threatening spiders often embody fears about situations where you feel powerless or manipulated.",
            category: .animals
        ),
        DreamSymbol(
            name: "Stairs",
            iconName: "stairs",
            shortDescription: "Progress, transitions between levels of consciousness",
            detailedDescription: "Stairs in dreams symbolize progress, transition, and movement between different levels of consciousness or life situations. The direction and nature of your movement on the stairs is significant.\n\nClimbing up stairs often represents progress, advancement, or spiritual growth. Descending stairs might indicate exploring deeper parts of yourself, the unconscious, or moving into a more grounded state. Difficulty climbing stairs suggests obstacles in your advancement or feeling that progress requires significant effort.\n\nBroken or dangerous stairs can symbolize risky transitions or unstable pathways in your life. A spiral staircase might represent a more complex journey of self-discovery, where you revisit similar issues at different levels of understanding. Being stuck on a landing between flights of stairs often indicates a transitional period where you're between major life phases.",
            category: .places
        ),
        DreamSymbol(
            name: "Sun",
            iconName: "sun.max",
            shortDescription: "Vitality, consciousness, enlightenment, and success",
            detailedDescription: "The sun in dreams symbolizes vitality, consciousness, enlightenment, and success. It represents the active principle and often relates to self-expression and your core identity.\n\nA bright, warm sun typically indicates optimism, clarity, and energy in your life. A setting sun might represent the completion of a phase or the decline of something important. A rising sun suggests new beginnings, hope, and the dawn of understanding.\n\nBeing able to look directly at the sun (which isn't possible in waking life) might symbolize spiritual insight or direct consciousness of profound truths. Sun damage or burning can represent too much exposure to something powerful – perhaps intensity that you're not yet ready to handle. Multiple suns in the sky might indicate conflicting sources of authority or influence in your life.",
            category: .elements
        ),
        DreamSymbol(
            name: "Moon",
            iconName: "moon",
            shortDescription: "Intuition, the unconscious, and cyclical change",
            detailedDescription: "The moon in dreams symbolizes intuition, the unconscious mind, and the cyclical nature of experience. It often represents the receptive principle and is associated with mystery and the feminine aspect of personality.\n\nA full, bright moon suggests emotional clarity and the illumination of unconscious content. A new or dark moon might represent something hidden or a period of gestation before new awareness emerges. A blood moon or eclipse often symbolizes rare insight or unusual emotional states.\n\nChanges in the moon's phases within a dream highlight awareness of natural cycles and rhythms in your life. Multiple moons might suggest conflicting intuitive pulls or emotional influences. The moon reflected in water combines symbols of emotion and intuition, suggesting deep insight into your emotional landscape.",
            category: .elements
        ),
        DreamSymbol(
            name: "Sword",
            iconName: "shield",
            shortDescription: "Intellect, courage, and decisive action",
            detailedDescription: "Swords in dreams symbolize intellect, truth, courage, and the power to cut through confusion. They represent decisive action and the ability to separate truth from falsehood.\n\nWielding a sword effectively suggests confidence in your decisions and clarity of thought. A broken or dull sword might indicate compromised judgment or ineffective intellectual approaches. Being attacked with a sword could represent feeling threatened by others' sharp words or critical thoughts.\n\nA ceremonial sword often represents authority or formal power. Finding or being given a sword suggests receiving a new capacity for clear thinking or decisive action. Sheathing a sword might symbolize choosing peace or holding back your analytical power in favor of more receptive approaches. Two-edged swords can represent thoughts or decisions that cut both ways, affecting both yourself and others.",
            category: .objects
        ),
        DreamSymbol(
            name: "Birds",
            iconName: "bird",
            shortDescription: "Freedom, perspective, and spiritual messages",
            detailedDescription: "Birds in dreams generally symbolize freedom, perspective, aspirations, and sometimes messages from the spiritual or unconscious realms. The type of bird and its behavior provide specific insights.\n\nFlying birds often represent freedom, transcendence, and the ability to rise above circumstances. Singing birds frequently symbolize joy, creative expression, and harmony. Birds in cages might represent feelings of confinement or restricted freedom.\n\nCertain birds carry additional symbolism: eagles suggest vision and strength; owls represent wisdom and the ability to see in darkness; songbirds often connect to voice and self-expression; and ravens or crows might symbolize transformation or messages from the unconscious. A flock of birds changing direction in unison can represent sudden shifts in thought patterns or collective consciousness.",
            category: .animals
        ),
        DreamSymbol(
            name: "Book",
            iconName: "book",
            shortDescription: "Knowledge, memory, and life narrative",
            detailedDescription: "Books in dreams symbolize knowledge, learning, memory, and the narrative of your life. How you interact with the book provides insight into your relationship with knowledge and your personal story.\n\nReading easily suggests clear access to knowledge or understanding of your life experience. Difficulty reading or blurred text might indicate confusion or hidden knowledge. Writing in a book can represent actively shaping your life story or recording important insights.\n\nAn old, valuable book often symbolizes wisdom, traditional knowledge, or ancestral guidance. A blank book might represent untapped potential or a story yet to be written. Finding a lost book can symbolize recovering forgotten knowledge or memories. Multiple books or a library often represents the wealth of your accumulated knowledge and experience, or the collective wisdom available to you.",
            category: .objects
        ),
        DreamSymbol(
            name: "Gift",
            iconName: "gift",
            shortDescription: "Unexpected benefits, talents, and relationships",
            detailedDescription: "Gifts in dreams symbolize unexpected benefits, recognition of value, and the exchange of energy in relationships. The nature of the gift and how it's given or received provides specific meaning.\n\nReceiving a gift often represents recognition, appreciation, or unexpected benefits coming into your life. Giving a gift might symbolize your generosity, desire for connection, or recognition of others' value. An unwrapped gift suggests transparent intentions, while an elaborately wrapped gift might represent layers of meaning or hidden agendas.\n\nThe contents of the gift are significant – practical items might suggest practical help, while symbolic or unusual items often carry metaphorical meaning. Empty gift boxes can represent disappointment or deceptive appearances. Being unable to open a gift might symbolize difficulty accepting help or recognizing your own talents and resources.",
            category: .objects
        ),
        DreamSymbol(
            name: "Mask",
            iconName: "theatermasks",
            shortDescription: "Identity, deception, and social roles",
            detailedDescription: "Masks in dreams symbolize identity, deception, social roles, and the faces we present to others versus our authentic selves. Your interaction with the mask reveals important insights.\n\nWearing a mask often suggests hiding your true feelings or presenting a false front to others. Removing a mask typically represents revealing your authentic self or discovering truth. Seeing others in masks might indicate uncertainty about their true intentions or feelings.\n\nChanging masks can symbolize adopting different social roles or exploring different aspects of your identity. A mask stuck to your face suggests difficulty separating from a role you've been playing. Beautiful or ornate masks might represent appealing but potentially deceptive appearances, while grotesque masks often symbolize feared aspects of yourself or others that are being concealed.",
            category: .objects
        ),
        DreamSymbol(
            name: "Rose",
            iconName: "heart",
            shortDescription: "Love, beauty, and the duality of pleasure and pain",
            detailedDescription: "Roses in dreams symbolize love, beauty, passion, and the duality of pleasure and pain. The condition, color, and context of the rose provide specific meanings.\n\nA blooming rose often represents flourishing love, beauty, or creative expression. A rosebud suggests potential or new beginnings in love or creative endeavors. A wilting or dying rose might symbolize fading relationships or beauty concerns.\n\nRed roses traditionally symbolize romantic love and passion. White roses often represent purity, spirituality, or new beginnings. Yellow roses can symbolize friendship or joy. The thorns on roses represent the painful aspects that come with love and beauty – the idea that what's valuable often requires navigating difficulties. A rose without thorns might suggest an idealized view of love that doesn't acknowledge its challenges.",
            category: .nature
        ),
        DreamSymbol(
            name: "Teeth Falling Out",
            iconName: "eye",
            shortDescription: "Anxiety about appearance, power, and communication",
            detailedDescription: "Dreams about teeth falling out are among the most common dream themes worldwide. They typically symbolize anxiety about appearance, social judgment, loss of power, or communication fears.\n\nTeeth falling out painlessly often relates to concerns about how you present yourself to others or fears of embarrassment. Painful tooth loss might indicate more acute anxiety or painfully difficult transitions. Crumbling teeth frequently represent feelings that your foundation or confidence is deteriorating.\n\nIn some interpretations, teeth symbolize power and confidence, so losing them can represent feelings of disempowerment in waking life. The teeth dream may also connect to communication anxieties – fears of saying the wrong thing or losing your ability to express yourself effectively. The reaction of others in the dream to your tooth loss can provide additional insight into your social anxieties.",
            category: .body
        ),
        DreamSymbol(
            name: "Falling",
            iconName: "arrow.down.to.line",
            shortDescription: "Loss of control, failure, or letting go",
            detailedDescription: "Falling in dreams typically symbolizes a lack of control, insecurity, or anxiety about failure. The context and feeling of the fall provide important nuances.\n\nFalling without reaching the ground often represents ongoing anxiety without resolution – the fear of failure rather than failure itself. Hitting the ground might symbolize facing the consequences of a failure or reaching a personal low point. Falling but landing safely can represent successfully navigating a challenging situation despite fears.\n\nThe environment you're falling through adds meaning – falling through darkness suggests fear of the unknown, while falling through a familiar setting might connect to specific life situations. Your emotional response during the fall is also significant – terror suggests genuine anxiety, while exhilaration or eventual flying might indicate that what seems like failure could actually lead to liberation.",
            category: .actions
        ),
        DreamSymbol(
            name: "Labyrinth",
            iconName: "square.on.square",
            shortDescription: "Life's journey, self-discovery, and confusion",
            detailedDescription: "Labyrinths or mazes in dreams symbolize life's journey, the search for self-understanding, and navigation through confusing circumstances. Your experience within the labyrinth reveals your approach to life's complexities.\n\nMoving confidently through a labyrinth suggests trust in your path despite its twists and turns. Feeling lost or trapped indicates confusion about your direction in life or feeling that you're making no progress despite effort. Finding the center of a labyrinth often represents achieving self-knowledge or spiritual insight.\n\nUnlike mazes, which are designed to confuse with dead ends and false paths, traditional labyrinths have a single path that always leads to the center, though it winds in unexpected ways. Dreaming of a true labyrinth might suggest that your path, though seemingly circuitous, is actually leading you exactly where you need to go. Encountering something or someone significant at the center represents the reward of self-discovery or spiritual insight gained through your life journey.",
            category: .places
        ),
        DreamSymbol(
            name: "Tornado",
            iconName: "tornado",
            shortDescription: "Destructive change, emotional turmoil, and transformation",
            detailedDescription: "Tornados in dreams symbolize powerful, potentially destructive change, emotional upheaval, and transformative forces beyond your control. Your response to the tornado reveals your attitude toward dramatic change.\n\nSeeing a tornado in the distance might represent awareness of approaching dramatic change or emotional turmoil. Being caught in a tornado suggests feeling overwhelmed by circumstances or emotions that have uprooted your sense of stability. Surviving a tornado often indicates resilience and the ability to endure major life upheavals.\n\nThe tornado's path of destruction can represent necessary clearing away of old structures to make way for new growth – a difficult but ultimately revitalizing process. Taking shelter from a tornado suggests finding ways to protect your essential self during times of turmoil. Multiple tornados might represent feeling that challenges are coming from multiple directions simultaneously.",
            category: .elements
        ),
        DreamSymbol(
            name: "Crown",
            iconName: "crown",
            shortDescription: "Achievement, authority, and recognition",
            detailedDescription: "Crowns in dreams symbolize achievement, authority, recognition, and sometimes the burden of responsibility. Your interaction with the crown reveals your relationship to power and success.\n\nWearing a crown comfortably suggests confidence in your achievements or leadership abilities. A crown that feels heavy or uncomfortable might indicate feeling burdened by responsibility or authority. Finding a crown represents discovering your own power or being recognized for your achievements.\n\nA golden crown often symbolizes spiritual illumination or highest achievement. Losing or breaking a crown might represent fears about losing status or authority. Someone else wearing a crown could represent a person you view as having power over you or someone you respect for their achievements. Being offered a crown suggests new responsibilities or opportunities for leadership coming your way.",
            category: .objects
        ),
        DreamSymbol(
            name: "Rainbow",
            iconName: "rainbow",
            shortDescription: "Hope, divine promise, and spiritual bridge",
            detailedDescription: "Rainbows in dreams symbolize hope, divine promise, spiritual connection, and the bridging of different realms or states of being. They often appear after emotional storms in your life.\n\nSeeing a vivid, complete rainbow suggests hope returning after difficulties and the promise of better times ahead. A faded rainbow might represent fading hopes or unrealistic expectations. Walking on or following a rainbow can symbolize pursuit of goals that seem just out of reach or connection with spiritual aspirations.\n\nIn many traditions, rainbows represent divine covenant or promise. They can also symbolize the bridge between the physical and spiritual worlds, or between different states of consciousness. Multiple rainbows might suggest extraordinary blessings or multiple paths of hope opening in your life.",
            category: .nature
        ),
        DreamSymbol(
            name: "Elevator",
            iconName: "arrow.up.and.down",
            shortDescription: "Social status changes and emotional transitions",
            detailedDescription: "Elevators in dreams represent social or emotional transitions, changes in perspective, and movements between different levels of consciousness. How the elevator functions and your experience within it provide specific insights.\n\nRiding an elevator smoothly upward often symbolizes advancement, raising consciousness, or improving circumstances. Descending can represent exploring deeper aspects of yourself or confronting more primal emotions. Elevators that malfunction – stopping between floors, plummeting, or rising uncontrollably – suggest anxiety about these transitions.\n\nBeing stuck in an elevator frequently represents feeling trapped between different states or stages of life. Crowded elevators might indicate feeling your personal space invaded during transitions. The people who accompany you in the elevator often represent aspects of yourself or influences affecting your transitions. Very tall elevators can symbolize the full spectrum of consciousness from most instinctual to most spiritual.",
            category: .places
        ),
        DreamSymbol(
            name: "Diamond",
            iconName: "diamond",
            shortDescription: "Inner value, clarity, and resilience",
            detailedDescription: "Diamonds in dreams symbolize inner value, clarity, resilience, and the transformation of pressure into beauty. Your interaction with the diamond reveals your relationship with these qualities.\n\nFinding a diamond often represents discovering your own inner worth or potential. A brilliant, clear diamond suggests spiritual clarity or enlightenment. Diamonds in the rough might symbolize unrecognized potential or value that needs refinement to be fully expressed.\n\nLosing a diamond could represent feelings of diminished self-worth or concerns about losing something precious. Diamond jewelry often connects to status, commitment, or self-valuation. The process of diamond formation – carbon transformed through pressure and time – resonates with the idea that difficulties in life can eventually produce something of immense value.",
            category: .objects
        ),
        DreamSymbol(
            name: "Hospital",
            iconName: "cross.case",
            shortDescription: "Healing, recovery, and confronting pain",
            detailedDescription: "Hospitals in dreams symbolize healing, recovery, confronting pain, and addressing aspects of yourself that need care or attention. Your experience in the hospital reveals your attitudes toward vulnerability and healing.\n\nBeing a patient suggests recognition that you need healing or assistance with some aspect of your life. Working in a hospital might represent your caretaking role for others or different aspects of yourself. Visiting someone in a hospital often symbolizes awareness of vulnerable or wounded aspects that need attention.\n\nEmergency rooms can represent crisis or urgent need for intervention. Operating rooms might symbolize major transformations taking place. Recovery rooms suggest healing in progress after significant change. Empty or abandoned hospitals could represent neglected health needs or disconnection from your healing process. The condition of the hospital – clean and well-run versus chaotic or dilapidated – reflects your perception of healing resources available to you.",
            category: .places
        ),
        DreamSymbol(
            name: "Anchor",
            iconName: "anchor.circle",
            shortDescription: "Stability, security, and emotional grounding",
            detailedDescription: "Anchors in dreams symbolize stability, security, grounding, and connection to your foundations. The condition of the anchor and how it functions reveal insights about your sense of security.\n\nA strong anchor securing a boat suggests feeling stable and connected to your roots despite life's fluctuations. A broken or rusty anchor might indicate compromised security or unreliable foundations. Raising an anchor often symbolizes readiness to move on from a secure but limiting situation.\n\nCarrying an anchor can represent feeling burdened by the very things that provide stability in your life. Lost anchors might suggest feeling adrift or unmoored from your foundations. The depth at which an anchor rests can symbolize how deep your connections to stability and security run. Anchor tattoos or imagery often connect to permanent commitments or values that keep you grounded through life's storms.",
            category: .objects
        ),
        DreamSymbol(
            name: "Wolf",
            iconName: "pawprint",
            shortDescription: "Instinct, freedom, and the balance of wildness",
            detailedDescription: "Wolves in dreams symbolize instinct, freedom, loyalty to community, and the balance between civilized and wild aspects of yourself. Your interaction with the wolf reveals your relationship with these qualities.\n\nA friendly or protective wolf often represents healthy connection to your instincts and natural wisdom. A threatening wolf might symbolize fear of your own wildness or untamed emotions. Being chased by wolves can indicate running from aspects of yourself that seem dangerous but may actually be valuable.\n\nA wolf pack suggests the need for community or tribal connection, while a lone wolf might represent independence or exclusion. Wolves howling connect to emotional expression, especially grief or longing. Wolf cubs can symbolize vulnerable or developing instinctual aspects of yourself. Taming or befriending a wolf in a dream often represents integrating wilder aspects of yourself in a constructive way.",
            category: .animals
        ),
        DreamSymbol(
            name: "Camera",
            iconName: "camera",
            shortDescription: "Perception, memory, and how you view reality",
            detailedDescription: "Cameras in dreams symbolize perception, memory preservation, and how you filter or frame your experience of reality. The type of camera and how you use it provide specific insights.\n\nTaking photographs often represents the desire to preserve memories or capture significant moments. Being photographed might suggest concerns about how others perceive you or the image you project. A broken camera could symbolize distorted perception or inability to accurately record experiences.\n\nOld-fashioned cameras might connect to nostalgia or traditional ways of seeing. Advanced digital cameras could represent contemporary perspectives or information overload. The subject of photographs in dreams is significant – what you choose to focus on reveals what seems most important or noteworthy in your life. Looking through a viewfinder suggests selective attention – what you include in the frame and what you leave out.",
            category: .objects
        ),
        DreamSymbol(
            name: "Hourglass",
            iconName: "hourglass",
            shortDescription: "Passing time, mortality, and transformation",
            detailedDescription: "Hourglasses in dreams symbolize the passage of time, mortality, life transitions, and the transformative nature of time's flow. The condition of the sand and how it moves provide specific insights.\n\nWatching sand flow smoothly suggests acceptance of time's passage. Sand flowing too quickly might represent anxiety about aging or time pressure. Sand that won't flow indicates feeling stuck or time standing still. Turning the hourglass over can symbolize starting fresh or gaining additional time.\n\nBroken hourglasses might represent disrupted timelines or freedom from time constraints. The upper chamber relates to future potential, while the lower chamber represents accumulated experience. The narrow passage between chambers can symbolize transition points or bottlenecks in your life journey. The limited nature of sand in an hourglass connects to awareness of mortality and the finite nature of time.",
            category: .objects
        ),
        DreamSymbol(
            name: "Eagle",
            iconName: "viewfinder",
            shortDescription: "Vision, freedom, and spiritual aspiration",
            detailedDescription: "Eagles in dreams symbolize vision, freedom, spiritual aspiration, and the ability to rise above mundane concerns. Your interaction with the eagle reveals your relationship to these qualities.\n\nAn eagle soaring high represents elevated perspective, spiritual freedom, or rising above circumstances. An eagle's keen vision can symbolize clarity, insight, or the ability to detect what others miss. Being carried by an eagle might suggest spiritual guidance or being elevated by a powerful force in your life.\n\nEagles hunting connect to decisive action or the pursuit of goals. An injured eagle might represent compromised freedom or spiritual constraints. Eagle nests often symbolize security at high levels of awareness or achievement. The majesty of eagles frequently connects to divine power, nobility of spirit, or higher consciousness. In some traditions, eagles represent solar energy and masculine spirituality.",
            category: .animals
        ),
        DreamSymbol(
            name: "Island",
            iconName: "map.fill",
            shortDescription: "Solitude, self-sufficiency, and isolation",
            detailedDescription: "Islands in dreams symbolize solitude, self-sufficiency, isolation, and sometimes emotional separation from others. The condition of the island and your experience there reveal insights about your sense of connection or disconnection.\n\nA beautiful, paradise-like island often represents desired solitude or retreat from the stresses of social life. A barren or desolate island might symbolize unwanted isolation or emotional deprivation. Being stranded suggests feeling cut off from support or resources.\n\nDifficulty leaving an island can represent challenges in connecting with others or overcoming isolation. Building a community on an island might symbolize creating connection despite circumstances that promote separation. The waters surrounding the island represent the emotional barriers or distances between you and others. Bridges or boats to the island indicate pathways to connection, while their absence suggests reinforced isolation.",
            category: .places
        ),
        DreamSymbol(
            name: "Lightning",
            iconName: "bolt",
            shortDescription: "Sudden insight, divine inspiration, or shock",
            detailedDescription: "Lightning in dreams symbolizes sudden insight, divine inspiration, dramatic change, creative inspiration, or shock. Your response to the lightning reveals your attitude toward sudden transformative forces.\n\nLightning illuminating darkness often represents sudden clarity or understanding in a previously confused situation. Being struck by lightning might symbolize unexpected inspiration, spiritual awakening, or being chosen for a special purpose. Destructive lightning can represent shocking events that demolish old structures in your life.\n\nFear of lightning suggests anxiety about sudden changes or revelations. Lightning in a clear sky might represent unexpected challenges arising without warning. Chain lightning or multiple strikes can symbolize a series of insights or revelations coming in rapid succession. The thunder that follows lightning connects to the emotional impact or aftershock of sudden revelations or changes.",
            category: .elements
        ),
        DreamSymbol(
            name: "Owl",
            iconName: "bird",
            shortDescription: "Wisdom, intuition, and perception in darkness",
            detailedDescription: "Owls in dreams symbolize wisdom, intuition, the ability to see what others miss, and navigation through mental or spiritual darkness. Your interaction with the owl reveals your relationship to these qualities.\n\nA peaceful owl watching you might represent wisdom overseeing your journey or the development of your own insight. An owl delivering a message suggests intuitive knowledge being communicated from the unconscious. Owls hunting connect to the pursuit of hidden knowledge or elusive truths.\n\nOwls' ability to see in darkness symbolizes perceiving truth in confusing situations or finding your way through uncertainty. Hearing an owl hoot without seeing it can represent intuitive warnings or guidance that's sensed rather than fully understood. In some traditions, owls connect to the feminine divine or moon energy, representing intuitive wisdom as opposed to logical reasoning.",
            category: .animals
        ),
        DreamSymbol(
            name: "Cave",
            iconName: "archivebox",
            shortDescription: "The unconscious mind, refuge, and primal instincts",
            detailedDescription: "Caves in dreams symbolize the unconscious mind, refuge from external pressures, primal instincts, and facing the unknown within yourself. Your experience in the cave reveals your relationship with these aspects.\n\nEntering a cave willingly suggests readiness to explore your unconscious or retreat from external pressures. Being forced into a cave might represent unwanted confrontation with aspects of yourself you'd prefer to avoid. Finding treasure or artifacts in a cave can symbolize discovering valuable resources in the unconscious.\n\nDark, frightening caves often represent fear of your own depths or primal nature. Caves with ancient paintings might symbolize connection to ancestral wisdom or collective unconscious material. Being lost in a cave system suggests confusion about your inner landscape. Cave openings represent thresholds between conscious and unconscious awareness, with the amount of light at the entrance symbolizing how accessible these deeper aspects are to your conscious mind.",
            category: .places
        ),
        DreamSymbol(
            name: "Desert",
            iconName: "sunrise",
            shortDescription: "Spiritual testing, emptiness, and purification",
            detailedDescription: "Deserts in dreams symbolize spiritual testing, emptiness, purification through austerity, and facing essential truths without distraction. Your experience in the desert reveals insights about how you handle spiritual challenges.\n\nWandering in a desert often represents spiritual searching, periods of emptiness, or feeling that life lacks nourishment. Finding an oasis suggests discovering spiritual refreshment or emotional replenishment in barren circumstances. Desert heat can symbolize purification through trial or the intensity of spiritual testing.\n\nDesert animals or plants represent resilience and adaptation to harsh conditions. Sandstorms might symbolize confusion or temporary blindness during spiritual transitions. The vastness of deserts connects to feelings of insignificance or being overwhelmed by life's challenges. Desert journeys frequently symbolize important spiritual initiations or periods of growth through deprivation, similar to how many religious traditions include desert retreats or vision quests.",
            category: .places
        ),
        DreamSymbol(
            name: "Apple",
            iconName: "applelogo",
            shortDescription: "Knowledge, temptation, and wholeness",
            detailedDescription: "Apples in dreams symbolize knowledge, temptation, wholeness, and sometimes forbidden desires. The condition of the apple and how you interact with it provide specific insights.\n\nA ripe, perfect apple often represents wholeness, health, or the rewards of good choices. Eating an apple might symbolize acquiring knowledge or taking in nourishment on multiple levels. Rotten or worm-eaten apples can represent corrupted knowledge, deception, or tainted offerings.\n\nThe biblical associations with forbidden knowledge influence many apple dreams, connecting them to temptation or choices with significant consequences. Offering someone an apple may represent extending knowledge or temptation to others. Golden apples often connect to special prizes or exceptional knowledge. The act of cutting an apple horizontally to reveal the star pattern inside can symbolize discovering hidden spiritual patterns or insights within ordinary experiences.",
            category: .nature
        ),
        DreamSymbol(
            name: "Fog",
            iconName: "cloud.fog",
            shortDescription: "Confusion, uncertainty, and hidden knowledge",
            detailedDescription: "Fog in dreams symbolizes confusion, uncertainty, hidden knowledge, and the blurring of boundaries between different states of consciousness. Your experience in the fog reveals your relationship with uncertainty.\n\nBeing lost in fog often represents confusion about direction in life or unclear thinking. Fog gradually lifting suggests emerging clarity or gradually understanding something that was previously obscure. Walking confidently through fog might symbolize trust in intuition when clear vision isn't available.\n\nFog concealing something specific suggests information being hidden from you or truths you're not yet ready to see. Mysterious figures appearing in fog often represent aspects of yourself or insights emerging from the unconscious. Fog at the boundary between land and water symbolizes blurred lines between conscious and unconscious awareness. The density of fog can represent the degree of confusion or lack of clarity you're experiencing.",
            category: .elements
        ),
        DreamSymbol(
            name: "Castle",
            iconName: "building.columns",
            shortDescription: "Protection, achievement, and inner sanctuary",
            detailedDescription: "Castles in dreams symbolize protection, achievement, authority, and inner sanctuaries. The condition of the castle and your relationship to it provide specific insights.\n\nA strong, intact castle often represents security, achievement, or strong personal boundaries. Castles under siege might symbolize feeling your accomplishments or security are threatened. Living in a castle can suggest feelings of isolation that come with achievement or authority. Exploring an abandoned castle might represent examining outdated defense systems or old sources of security.\n\nThe different areas of a castle have specific meanings: throne rooms connect to personal authority; dungeons represent repressed material or fears; towers suggest elevated perspective or isolation; and drawbridges relate to how you control access to yourself. Castles on hills or mountains amplify the symbolism of achievement and authority, while castles with moats emphasize strong emotional boundaries between yourself and others.",
            category: .places
        ),
        DreamSymbol(
            name: "Jellyfish",
            iconName: "sparkles",
            shortDescription: "Sensitivity, vulnerability, and hidden stings",
            detailedDescription: "Jellyfish in dreams symbolize sensitivity, vulnerability, hidden dangers, and navigation through emotional currents. Your interaction with the jellyfish reveals insights about these aspects of your experience.\n\nBeautiful, floating jellyfish often represent grace through surrender, allowing emotional currents to carry you, or ethereal beauty. Being stung by a jellyfish might symbolize unexpected emotional pain or the hidden dangers in apparently beautiful situations. Transparent jellyfish can represent things that affect you emotionally but are difficult to see clearly.\n\nJellyfish pulsing through water connect to emotional rhythms and the beating heart. The contrast between a jellyfish's delicate beauty and dangerous sting can symbolize relationships or situations that are simultaneously attractive and harmful. Swarms of jellyfish might represent feeling overwhelmed by emotional sensitivity or vulnerability. The jellyfish's lack of central brain but distributed nervous system can symbolize emotional intelligence that operates differently from logical thinking.",
            category: .animals
        ),
        DreamSymbol(
            name: "Candle",
            iconName: "flame",
            shortDescription: "Guidance, hope, and inner light",
            detailedDescription: "Candles in dreams symbolize guidance, hope, spirituality, inner light, and the fragility of consciousness. The condition of the candle and how it burns provide specific insights.\n\nA steadily burning candle often represents clarity, hope, or spiritual presence. Lighting a candle can symbolize initiating a spiritual practice or bringing consciousness to a dark situation. Candles burning low suggest diminishing energy, time running out, or resources being depleted.\n\nProtecting a candle flame from wind might represent preserving hope or spiritual awareness during challenging times. Extinguished candles can symbolize lost hope, spiritual disconnection, or the end of a situation. Multiple candles often represent community, shared spirituality, or multiple sources of guidance. The quality of light from the candle – whether bright and clear or dim and flickering – reflects the strength and consistency of the guidance or hope available to you.",
            category: .objects
        ),
        DreamSymbol(
            name: "Puzzle",
            iconName: "puzzlepiece",
            shortDescription: "Problem-solving, integration, and missing pieces",
            detailedDescription: "Puzzles in dreams symbolize problem-solving, the integration of different aspects of life or self, and the satisfaction of finding where things fit. The state of the puzzle and your interaction with it provide specific insights.\n\nWorking on a puzzle suggests active integration of understanding or bringing coherence to fragmented aspects of your experience. Completing a puzzle might represent achieving wholeness or resolving a complex situation. Missing puzzle pieces often symbolize lacking information or aspects of yourself that seem lost or unavailable.\n\nFinding a significant puzzle piece can represent a key insight that helps make sense of a larger picture. Puzzles with images emerging as they're completed symbolize gradual understanding of life patterns or personal identity. Puzzle pieces that don't fit might represent forcing situations against their natural order. The complexity of the puzzle often mirrors the complexity of the situation you're trying to understand or resolve.",
            category: .objects
        ),
        DreamSymbol(
            name: "Snake",
            iconName: "scribble.variable",
            shortDescription: "Transformation, healing, and hidden wisdom",
            detailedDescription: "Snakes in dreams often symbolize transformation, renewal, and healing due to their ability to shed their skin and emerge renewed. They may represent wisdom that comes from the unconscious or spiritual realms.\n\nThe context is crucial - a threatening snake might represent fears or unacknowledged challenges, while a peaceful snake could symbolize healing energies. Multiple snakes might indicate complex transformation processes or conflicting energies in your life.\n\nIn many traditions, snakes are associated with kundalini energy - the spiritual energy believed to reside at the base of the spine. Dreaming of a snake rising might represent spiritual awakening or the activation of creative or healing energies within yourself.",
            category: .animals
        ),
        DreamSymbol(
            name: "Waterfall",
            iconName: "water.waves",
            shortDescription: "Emotional release, renewal, and cleansing",
            detailedDescription: "Waterfalls in dreams symbolize emotional release, renewal, and spiritual cleansing. The size, power, and your relationship to the waterfall provide important context.\n\nA powerful, rushing waterfall often represents overwhelming emotions or significant life transitions requiring surrender. Standing beneath a waterfall typically suggests purification, renewal, or accepting powerful emotional energies. Climbing alongside a waterfall might symbolize spiritual or emotional ascension through challenging circumstances.\n\nWaterfalls also represent boundaries between conscious and unconscious, or between different phases of life. The pool at the base of a waterfall can symbolize the gathering of wisdom after an emotional journey. Multiple waterfalls might indicate several concurrent emotional processes or transitions occurring in your life.",
            category: .nature
        ),
        DreamSymbol(
            name: "Clock",
            iconName: "clock",
            shortDescription: "Time awareness, mortality, and pressure",
            detailedDescription: "Clocks in dreams symbolize your relationship with time, mortality, and the pressures of schedules or deadlines. The condition and behavior of the clock provide specific insights.\n\nA ticking clock often represents awareness of passing time or pressure to complete something important. Broken or stopped clocks might symbolize feeling out of sync, denying aging, or wishing to escape time constraints. Clocks running backward suggest desires to revisit the past or undo previous actions.\n\nMultiple clocks showing different times can represent conflicting schedules or priorities in your life. Oversized clocks typically emphasize heightened time awareness or anxiety about deadlines. Ancient or antique timepieces might connect to family history, tradition, or timeless wisdom.",
            category: .objects
        ),
        DreamSymbol(
            name: "Mountain",
            iconName: "mountain.2",
            shortDescription: "Challenges, perspective, and spiritual aspiration",
            detailedDescription: "Mountains in dreams symbolize challenges, obstacles, perspective, and spiritual aspiration. Your interaction with the mountain provides crucial context for interpretation.\n\nClimbing a mountain often represents personal challenges, ambition, or spiritual seeking. Standing at the summit typically symbolizes achievement, clarity, or spiritual insight. Being unable to reach a mountain peak might represent frustrated ambitions or spiritual struggles.\n\nA mountain range on the horizon can symbolize future challenges or aspirations. Mountains shrouded in mist or clouds might represent goals or truths that remain partially obscured. Living on a mountain might symbolize isolation, retreat, or maintaining a heightened perspective on life's challenges.",
            category: .places
        ),
        DreamSymbol(
            name: "Castle",
            iconName: "building.columns",
            shortDescription: "Protection, achievement, and hidden aspects of self",
            detailedDescription: "Castles in dreams symbolize protection, achievement, authority, and sometimes hidden or undeveloped aspects of yourself. The condition and your relationship to the castle provide specific insights.\n\nAn impenetrable castle often represents emotional or psychological defenses. Exploring castle rooms typically symbolizes discovering unknown aspects of your personality or potential. Royal figures in castles might represent your own inner authority or influential people in your life.\n\nAn abandoned or ruined castle could symbolize abandoned potential or neglected aspects of yourself. Castles under siege often represent external pressures on your security or identity. Secret passages in castles frequently connect to unconscious content becoming accessible or discovering unexpected solutions to life challenges.",
            category: .places
        ),
        DreamSymbol(
            name: "Baby",
            iconName: "figure.child",
            shortDescription: "New beginnings, vulnerability, and potential",
            detailedDescription: "Babies in dreams symbolize new beginnings, vulnerability, innocence, and untapped potential. The baby's condition and your interaction with it provide specific insights.\n\nA healthy, happy baby often represents new ideas, relationships, or creative projects in their initial stages. Finding or being given a baby might symbolize receiving new responsibilities or opportunities. Neglected babies frequently represent neglected talents, relationships, or aspects of yourself needing attention.\n\nA crying baby often symbolizes needs or opportunities requiring immediate attention. Multiple babies might represent various new beginnings or responsibilities competing for your energy. Your emotional response to the baby in the dream is significant - feelings of joy suggest openness to new beginnings, while anxiety might indicate concerns about new responsibilities or challenges.",
            category: .people
        ),
        DreamSymbol(
            name: "Candle",
            iconName: "flame",
            shortDescription: "Illumination, guidance, and spiritual presence",
            detailedDescription: "Candles in dreams symbolize illumination, guidance, hope, and spiritual presence. The condition of the candle and its light provide important context.\n\nA steadily burning candle often represents clarity, hope, or spiritual guidance. Lighting a candle typically symbolizes initiating a period of insight or bringing conscious attention to an issue. A candle going out might represent lost hope, the end of a period of understanding, or transitions from one phase of awareness to another.\n\nStruggling to light a candle often symbolizes difficulties accessing insight or clarity. Multiple candles might represent various sources of guidance or inspiration. A circle of candles frequently symbolizes spiritual protection, ritual space, or community support. The color of the candle can add additional meaning - white for purity or spirituality, red for passion or vitality, blue for healing or truth.",
            category: .objects
        ),
        DreamSymbol(
            name: "Mask",
            iconName: "theatermasks",
            shortDescription: "Hidden identity, deception, and social roles",
            detailedDescription: "Masks in dreams symbolize hidden identity, social roles, deception, or protection of the true self. Your interaction with the mask provides specific insights.\n\nWearing a mask often represents hiding aspects of yourself or playing a social role that doesn't reflect your true feelings. Removing a mask typically symbolizes revealing your authentic self or seeing through deception. Being unable to remove a mask might represent feeling trapped in a false identity or role.\n\nSeeing others in masks frequently symbolizes uncertainty about others' true intentions or identity. Different masks can represent different personas or roles you adopt in various contexts. Ritual or theatrical masks might connect to archetypal energies or deeper collective meanings beyond individual identity.",
            category: .objects
        ),
        DreamSymbol(
            name: "Fog",
            iconName: "cloud.fog",
            shortDescription: "Confusion, uncertainty, and transition",
            detailedDescription: "Fog in dreams symbolizes confusion, uncertainty, transition between states, or veiled understanding. Your movement through the fog provides important context.\n\nBeing lost in fog often represents confusion about your direction in life or uncertainty about decisions. Fog lifting typically symbolizes clarity emerging from a period of confusion. Partial fog, where some areas are clear and others obscured, might represent selective understanding or awareness.\n\nWalking confidently through fog despite limited visibility can represent faith or intuitive guidance during uncertain times. Fog at a threshold (doorway, shore, forest edge) often symbolizes the unclear territory between different states of being or phases of life. Colored fog might carry additional symbolism - red for hidden emotional issues, gold for obscured spiritual insights.",
            category: .elements
        ),
        DreamSymbol(
            name: "Telescope",
            iconName: "binoculars",
            shortDescription: "Foresight, clarity, and distant perspective",
            detailedDescription: "Telescopes in dreams symbolize foresight, the ability to see what's distant or not yet fully manifest, and gaining perspective on life patterns. Your use of the telescope provides specific insights.\n\nLooking through a telescope often represents attempts to gain clarity about the future or understanding distant aspects of your experience. A clear view through a telescope typically symbolizes successful insight or foresight. Difficulty focusing a telescope might represent challenges in gaining clarity about future directions or distant matters.\n\nSeeing unexpected things through a telescope can represent surprising revelations or possibilities not previously considered. A broken telescope might symbolize lost perspective or inability to see what's coming. Telescopes pointed at celestial bodies often connect to spiritual seeking or attempting to understand your place in the larger cosmic order.",
            category: .objects
        ),
        DreamSymbol(
            name: "Rose",
            iconName: "leaf",
            shortDescription: "Love, beauty, and emotional complexity",
            detailedDescription: "Roses in dreams symbolize love, beauty, desire, and the complexity of emotions. The condition of the rose and your interaction with it provide specific insights.\n\nA blooming rose often represents flowering love, creativity, or self-development. Receiving roses typically symbolizes being valued or appreciated. Thorny roses frequently represent the dual nature of love or beauty - pleasure intertwined with pain or challenge.\n\nWilting or dying roses might symbolize fading relationships or neglected emotional connections. Different colored roses carry additional meaning - red for passion, white for purity or spirituality, yellow for friendship or jealousy, black for loss or the mysterious aspects of love. A garden of roses often represents the cultivation of various loving relationships or emotional capacities.",
            category: .nature
        ),
        DreamSymbol(
            name: "Anchor",
            iconName: "anchor",
            shortDescription: "Stability, security, and emotional grounding",
            detailedDescription: "Anchors in dreams symbolize stability, security, emotional grounding, or what keeps you connected to your core values. The condition of the anchor and its context provide specific insights.\n\nA secure anchor often represents reliable emotional foundations or stability during challenging times. Dropping anchor typically symbolizes establishing stability or making a commitment. A broken or rusted anchor might represent compromised security or outdated attachments that no longer serve their purpose.\n\nBeing weighed down by an anchor can represent feeling overly restricted by commitments or stability that has become limiting. An anchor being raised might symbolize preparing for new journeys or releasing old securities to embrace change. In some contexts, anchors connect to maritime heritage or family traditions that provide a sense of belonging.",
            category: .objects
        ),
        DreamSymbol(
            name: "Labyrinth",
            iconName: "arrow.triangle.turn.up.right.diamond",
            shortDescription: "Life journey, complexity, and inner exploration",
            detailedDescription: "Labyrinths in dreams symbolize the complex journey of life, self-discovery, spiritual seeking, or complicated situations. Your movement through the labyrinth provides important context.\n\nNavigating a labyrinth confidently often represents trust in your life journey despite not seeing the entire path. Feeling lost in a labyrinth typically symbolizes confusion about life direction or feeling trapped in complex circumstances. Reaching the center of a labyrinth frequently symbolizes achieving self-understanding or spiritual insight.\n\nMonsters or challenges within a labyrinth often represent fears or shadow aspects that must be faced during personal development. Finding unexpected exits or paths can represent creative solutions to seemingly impossible situations. Unlike mazes (which feature dead ends and are designed to confuse), traditional labyrinths have a single path to the center - this can symbolize faith that life's winding path has purpose despite its apparent complexity.",
            category: .places
        ),
        DreamSymbol(
            name: "Tornado",
            iconName: "tornado",
            shortDescription: "Destructive change, emotional turbulence, and transformation",
            detailedDescription: "Tornados in dreams symbolize powerful, often destructive change, emotional turbulence, or transformative forces beyond your control. Your response to the tornado provides crucial context.\n\nWatching a tornado from a distance often represents awareness of powerful changes or emotional upheaval that hasn't yet directly affected you. Being caught in a tornado typically symbolizes feeling overwhelmed by rapid changes or emotional turmoil. Surviving a tornado might represent resilience through major life disruptions.\n\nA tornado destroying familiar structures can symbolize radical change dismantling established patterns in your life. Multiple tornados might represent various simultaneous disruptions or emotional challenges. Your ability to find shelter from the tornado often reflects your capacity to find emotional stability during turbulent times. The aftermath of a tornado can symbolize the opportunity for rebuilding or renewal after a period of destruction.",
            category: .elements
        ),
        DreamSymbol(
            name: "Umbrella",
            iconName: "umbrella",
            shortDescription: "Protection, emotional boundaries, and preparation",
            detailedDescription: "Umbrellas in dreams symbolize protection, emotional boundaries, preparation, or shielding yourself from overwhelming experiences. The condition of the umbrella and weather conditions provide specific insights.\n\nA sturdy umbrella in rain often represents effective emotional boundaries or self-care during challenging times. An umbrella failing to open when needed typically symbolizes unpreparedness for emotional challenges or lack of effective boundaries. Sharing an umbrella frequently symbolizes mutual support or protection in relationships.\n\nAn umbrella in sunshine might represent unnecessary defenses or maintaining boundaries when openness would be more appropriate. A decorative or colorful umbrella can symbolize finding joy or creative expression despite difficulties. Opening an umbrella indoors (traditionally considered unlucky) might symbolize invoking unnecessary caution or barriers in safe situations.",
            category: .objects
        ),
        DreamSymbol(
            name: "Island",
            iconName: "map.fill",
            shortDescription: "Isolation, independence, and self-discovery",
            detailedDescription: "Islands in dreams symbolize isolation, independence, uniqueness, or separate aspects of your experience. Your relationship to the island provides important context.\n\nBeing alone on an island often represents feelings of isolation or self-sufficiency. Exploring an undiscovered island typically symbolizes encountering unknown aspects of yourself or new potentials. Being stranded on an island might represent feeling cut off from support or usual resources.\n\nAn island paradise frequently symbolizes desires for escape or retreat from daily pressures. Building a community on an island can represent creating a separate life domain with its own rules and values. Bridges or boats connecting the island to mainland might symbolize communication channels between conscious and unconscious aspects of self, or between your independent self and wider social connections. Multiple islands might represent various separate aspects of your life or personality that remain somewhat disconnected.",
            category: .places
        ),
        DreamSymbol(
            name: "Crown",
            iconName: "crown",
            shortDescription: "Achievement, authority, and spiritual attainment",
            detailedDescription: "Crowns in dreams symbolize achievement, authority, responsibility, spiritual attainment, or recognition. Your interaction with the crown provides specific insights.\n\nWearing a crown often represents taking on authority, responsibility, or recognizing your own value and power. Being offered a crown typically symbolizes new opportunities for leadership or acknowledgment of your achievements. A heavy crown might represent the burdens of authority or success.\n\nLosing or damaging a crown can symbolize fears about losing status or authority. A crown made of unusual materials might carry additional symbolism - flowers for natural authority or spiritual achievement, thorns for painful leadership or sacrifice, gold for material success or social recognition. Multiple crowns might represent different domains of achievement or conflicting authorities in your life.",
            category: .objects
        ),
        DreamSymbol(
            name: "Elevator",
            iconName: "arrow.up.and.down",
            shortDescription: "Life transitions, social status, and emotional states",
            detailedDescription: "Elevators in dreams symbolize transitions between different levels of consciousness, social status changes, or shifting emotional states. The elevator's movement and condition provide specific insights.\n\nAn ascending elevator often represents rising aspirations, improving circumstances, or accessing higher awareness. A descending elevator typically symbolizes exploring deeper emotions or unconscious content, or concerns about decreasing status. A stalled elevator might represent feeling stuck in a transition or uncertain about changing circumstances.\n\nAn elevator with transparent walls can symbolize awareness during transitions that would typically happen unconsciously. A crowded elevator often represents social pressures or competing influences during periods of change. Elevator buttons might symbolize choices about which level of consciousness or social context you wish to access. Out-of-control elevators frequently represent anxiety about rapid changes in your life circumstances or emotional state.",
            category: .places
        ),
        DreamSymbol(
            name: "Rainbow",
            iconName: "rainbow",
            shortDescription: "Hope, promise, and spiritual connection",
            detailedDescription: "Rainbows in dreams symbolize hope, divine promise, connection between realms, or the integration of diverse aspects into a harmonious whole. Your interaction with the rainbow provides specific insights.\n\nSeeing a vivid rainbow often represents hope emerging after difficulties or spiritual reassurance during challenging times. Following a rainbow typically symbolizes pursuing aspirations or spiritual quests. A double rainbow might symbolize particularly powerful spiritual significance or reinforced promises.\n\nTouching or entering a rainbow can represent direct connection with spiritual realms or accessing extraordinary states of consciousness. A fading rainbow might symbolize hopes or promises that seem to be diminishing. Rainbow colors appearing on objects or people can represent spiritual blessing or the infusion of ordinary reality with higher meaning. In many traditions, rainbows symbolize bridges between physical and spiritual realms.",
            category: .elements
        ),
        DreamSymbol(
            name: "Armor",
            iconName: "shield",
            shortDescription: "Protection, defense, and emotional barriers",
            detailedDescription: "Armor in dreams symbolizes psychological protection, defenses against emotional hurt, strength in adversity, or barriers preventing authentic connection. The condition of the armor and your relationship to it provide important context.\n\nWearing effective armor often represents feeling protected from emotional or psychological threats. Heavy or restrictive armor typically symbolizes defenses that provide protection but limit freedom or authentic expression. Removing armor might represent willingness to be vulnerable or authentic.\n\nDamaged armor can symbolize compromised psychological defenses or vulnerabilities in your protective strategies. Golden or ornamental armor might represent defenses that also serve to impress others or enhance your social standing. Armor that belongs to someone else can symbolize adopting another's defensive strategies or protective values. Different types of armor might carry additional symbolism - modern body armor for contemporary concerns, medieval armor for more traditional or archetypal protections.",
            category: .objects
        ),
        DreamSymbol(
            name: "Hourglass",
            iconName: "hourglass",
            shortDescription: "Passing time, transitions, and limited resources",
            detailedDescription: "Hourglasses in dreams symbolize the passing of time, transitions between states, or awareness of limited resources or opportunities. The movement of sand and your interaction with the hourglass provide specific insights.\n\nWatching sand flow in an hourglass often represents awareness of passing time or life transitions happening in proper sequence. A nearly empty hourglass typically symbolizes feeling that time is running out for a particular opportunity or phase of life. Turning an hourglass over might represent starting fresh or recycling opportunities.\n\nA frozen hourglass with immobile sand can symbolize feeling stuck in time or suspended between life phases. Breaking an hourglass might represent liberation from time constraints or anxiety about disrupting natural timing. Multiple hourglasses could symbolize competing timelines or various life processes operating on different schedules. The size of the hourglass often relates to the perceived importance or scope of the time period it represents.",
            category: .objects
        ),
        DreamSymbol(
            name: "Phoenix",
            iconName: "flame",
            shortDescription: "Rebirth, renewal, and triumph over adversity",
            detailedDescription: "The phoenix in dreams symbolizes rebirth, renewal after destruction, triumph over adversity, or spiritual transformation through challenge. Your interaction with the phoenix provides specific insights.\n\nSeeing a phoenix rise from ashes often represents personal renewal after difficulties or spiritual transformation through challenging experiences. A phoenix in flames typically symbolizes being in the midst of a painful but ultimately regenerative process. Following a phoenix might represent being guided by transformative energies or inspirational examples of resilience.\n\nA wounded or struggling phoenix can symbolize challenges in your regenerative process or doubts about your ability to renew after setbacks. Multiple phoenixes might represent various aspects of yourself undergoing simultaneous regeneration. In some traditions, the phoenix connects to solar symbolism - representing cyclical nature of life energy, with periods of brilliant expression followed by necessary reduction and renewal.",
            category: .animals
        ),
        DreamSymbol(
            name: "Lighthouse",
            iconName: "light.beacon.max",
            shortDescription: "Guidance, warning, and hope in darkness",
            detailedDescription: "Lighthouses in dreams symbolize guidance, warning, hope in darkness, or a stable reference point during confusing times. The condition of the lighthouse and surrounding environment provide specific insights.\n\nA brightly shining lighthouse often represents reliable guidance during confusing circumstances or spiritual illumination during dark emotional periods. A lighthouse in stormy seas typically symbolizes stability and hope despite emotional turbulence. Being inside a lighthouse might represent gaining perspective that allows you to offer guidance to others.\n\nA lighthouse with a failing light can symbolize unreliable guidance or diminishing hope during challenging times. Difficulty reaching a visible lighthouse might represent awareness of available guidance that seems inaccessible. Abandoned lighthouses could symbolize neglected wisdom or discarded warning systems in your life. The rhythm of a lighthouse beam often connects to the intermittent nature of insight - moments of clarity followed by periods of processing.",
            category: .places
        ),
        DreamSymbol(
            name: "Camera",
            iconName: "camera",
            shortDescription: "Perception, memory, and self-image",
            detailedDescription: "Cameras in dreams symbolize how you perceive and record experience, memory formation, self-image, or how you are seen by others. Your interaction with the camera provides specific insights.\n\nTaking photographs often represents attempting to preserve experiences or creating memory anchors for significant moments. Being photographed typically symbolizes awareness of how others perceive you or concerns about your image. A broken camera might represent distorted perception or inability to properly process experiences.\n\nLooking through a camera viewfinder can symbolize adopting a particular perspective or framing of experience. Old photographs might represent connections to past events or how memories influence current identity. Video cameras often connect to narrative continuity and the flow of experience rather than discrete moments. Digital versus film cameras might symbolize different approaches to memory - immediate review and potential deletion versus commitment to processing everything captured.",
            category: .objects
        ),
        DreamSymbol(
            name: "Sword",
            iconName: "wand.and.rays",
            shortDescription: "Clarity, decisiveness, and intellectual discernment",
            detailedDescription: "Swords in dreams symbolize clarity, decisiveness, intellectual discernment, conflict resolution, or the cutting away of what's no longer needed. The condition of the sword and your use of it provide specific insights.\n\nDrawing a sword often represents preparing to face challenges directly or accessing your capacity for clear decision-making. A sharp, gleaming sword typically symbolizes clear thinking or the ability to separate truth from falsehood. A rusty or dull sword might represent compromised clarity or decisiveness that requires renewal.\n\nReceiving a sword can symbolize being granted authority or responsibility that requires discernment. A double-edged sword frequently represents decisions or truths with potential for both benefit and harm. Breaking a sword might symbolize the failure of force or intellectual approaches in situations requiring different tools. In many traditions, swords connect to the element of air - representing the mind, communication, and clarity.",
            category: .objects
        ),
        DreamSymbol(
            name: "Door",
            iconName: "door.left.hand.open",
            shortDescription: "Opportunity, transition, and access to new possibilities",
            detailedDescription: "Doors in dreams symbolize opportunities, transitions between different life states, or access to new possibilities or aspects of yourself. The condition of the door and your interaction with it provide crucial context.\n\nAn open door often represents available opportunities or invitations to new experiences. A closed door typically symbolizes temporarily inaccessible opportunities or aspects of experience. A locked door might represent deliberately blocked access or challenges that must be overcome before proceeding.\n\nSearching for a door can symbolize seeking opportunities or transitions in your life. Multiple doors often represent various options or potential paths forward. Doors of unusual size, material, or location might carry additional symbolism - a tiny door could represent opportunities that require humility to access, while a golden door might represent especially valuable or rare opportunities. The threshold of a door often represents the liminal space between different states of being or phases of life.",
            category: .objects
        ),
        DreamSymbol(
            name: "Mirror",
            iconName: "rectangle.inset.filled",
            shortDescription: "Self-reflection, identity, and truth perception",
            detailedDescription: "Mirrors in dreams symbolize self-reflection, identity, truth perception, and sometimes revelation of hidden aspects of self. The clarity and your interaction with the mirror provide crucial insights.\n\nSeeing a clear reflection often represents accurate self-perception or willingness to face truth about yourself. A distorted or unclear reflection typically symbolizes confusion about identity or self-deception. Breaking a mirror might represent dramatic changes in self-perception or fears about misfortune.\n\nMultiple mirrors can symbolize seeing yourself from different perspectives or fragmentation of identity. Looking into a mirror and seeing someone else might represent identification with another person or awareness of different facets of yourself. Mirrors showing future or past events connect to temporal insights or alternative life possibilities. In many traditions, mirrors are thought to reflect not just physical appearance but deeper spiritual or psychological reality.",
            category: .objects
        ),
        DreamSymbol(
            name: "Owl",
            iconName: "owl",
            shortDescription: "Wisdom, intuition, and perception in darkness",
            detailedDescription: "Owls in dreams symbolize wisdom, intuition, the ability to see what others miss, or perception in darkness and uncertainty. The owl's behavior and your interaction with it provide specific insights.\n\nAn owl watching silently often represents inner wisdom, unconscious knowledge, or patient observation. An owl in flight typically symbolizes the movement of wisdom or the delivery of important insights. Hearing an owl's call might represent receiving intuitive messages or warnings about something beyond conscious awareness.\n\nA hostile or threatening owl could symbolize fears about knowledge or wisdom that might disrupt comfortable illusions. Multiple owls might represent various sources of wisdom or insight available to you. In some traditions, owls connect to the feminine principle of wisdom, the moon, and the ability to navigate through emotional or spiritual darkness with confidence.",
            category: .animals
        ),
        DreamSymbol(
            name: "Book",
            iconName: "book.fill",
            shortDescription: "Knowledge, narrative, and life experiences",
            detailedDescription: "Books in dreams symbolize knowledge, narrative, life experiences, or recorded wisdom. The type of book and your interaction with it provide specific insights.\n\nReading a book often represents seeking knowledge, understanding your life's story, or learning from experience. Writing in a book typically symbolizes authoring your own narrative or recording important insights. Finding an unexpected book might represent discovering knowledge or perspectives previously unknown to you.\n\nAn ancient or magical book can symbolize access to collective wisdom, spiritual knowledge, or ancestral insights. A book in an unfamiliar language might represent knowledge that is available but not yet accessible to your conscious mind. Empty pages in a book often symbolize unwritten future, potential, or aspects of experience not yet processed or integrated.",
            category: .objects
        ),
        DreamSymbol(
            name: "Spider",
            iconName: "ladybug",
            shortDescription: "Creativity, patience, and complex life patterns",
            detailedDescription: "Spiders in dreams symbolize creativity, patience, complex life patterns, or sometimes entanglement and fear. The spider's activity and your emotional response provide crucial context.\n\nA spider weaving its web often represents creative processes, patience in building something intricate, or the construction of life circumstances through consistent effort. Walking across its web typically symbolizes movement across the interconnected aspects of your life or navigation of complex situations. Fear of spiders in dreams might represent anxieties about entanglement or loss of control.\n\nGiant spiders can symbolize exaggerated fears or significant creative forces at work in your life. Multiple spiders might represent various creative projects or concerns competing for attention. In many traditions, spiders connect to feminine creative power, destiny weaving, or the pattern-making aspect of consciousness that creates order from chaos.",
            category: .animals
        ),
        DreamSymbol(
            name: "Bridge",
            iconName: "road.lanes",
            shortDescription: "Connection, transition, and overcoming obstacles",
            detailedDescription: "Bridges in dreams symbolize connections between different states or aspects of life, transitions, or means of overcoming obstacles. The condition of the bridge and your crossing experience provide specific insights.\n\nCrossing a sturdy bridge often represents successful transition between life phases or integration of different aspects of yourself. A broken or dangerous bridge typically symbolizes risky transitions or tenuous connections between different areas of life. Building a bridge might represent creating new connections or pathways between previously separate aspects of experience.\n\nStanding in the middle of a bridge can symbolize being between states, neither here nor there. Bridges over troubled water often represent finding ways to rise above emotional difficulties. Drawbridges or bridges that can be raised might symbolize connections that can be deliberately severed or established when needed.",
            category: .places
        ),
        DreamSymbol(
            name: "Moon",
            iconName: "moon.stars",
            shortDescription: "Intuition, emotion, and the unconscious mind",
            detailedDescription: "The moon in dreams symbolizes intuition, emotion, unconscious mind, feminine energy, or cyclical processes. The phase of the moon and surrounding conditions provide important context.\n\nA full moon often represents heightened intuition, emotional clarity, or the peak of a cyclical process. A new or dark moon typically symbolizes beginning phases, hidden knowledge, or periods of emotional reset. A blood moon or eclipse might represent rare insights or unusual emotional states.\n\nThe moon reflected in water can symbolize emotional understanding or the interplay between conscious and unconscious mind. Multiple moons might represent competing emotional influences or alternative perspectives. In many traditions, the moon connects to intuitive wisdom, the feminine principle, and the emotional tides that influence human experience even when not consciously recognized.",
            category: .elements
        ),
        DreamSymbol(
            name: "Key",
            iconName: "key.fill",
            shortDescription: "Access, solutions, and unlocking potential",
            detailedDescription: "Keys in dreams symbolize access, solutions to problems, unlocking potential, or authority and permission. The type of key and your interaction with it provide specific insights.\n\nFinding a key often represents discovering solutions or gaining access to previously inaccessible knowledge, places, or abilities. Losing a key typically symbolizes missed opportunities or anxiety about losing access to something important. Using a key successfully might represent successfully applying insights or strategies to overcome obstacles.\n\nMultiple keys can symbolize various options or approaches to different life areas. A ornate or ancient key might represent traditional or timeless wisdom applicable to current challenges. A broken key often symbolizes attempted solutions that have failed or access that remains blocked despite efforts. Skeleton keys or master keys frequently symbolize universal insights or approaches that work across multiple situations.",
            category: .objects
        ),
        DreamSymbol(
            name: "Volcano",
            iconName: "flame.fill",
            shortDescription: "Suppressed emotions, creative potential, and transformation",
            detailedDescription: "Volcanoes in dreams symbolize suppressed emotions, dormant creative potential, or transformative powers that may erupt suddenly. The volcano's state provides crucial context.\n\nA dormant volcano often represents powerful emotions or creative energies held in check but still influencing your life. An erupting volcano typically symbolizes the release of long-suppressed feelings, sudden inspiration, or transformative change that may be destructive before becoming creative. Living near a volcano might represent awareness of powerful potential within yourself or your situation.\n\nThe aftermath of a volcanic eruption can symbolize the creative result of emotional release or the fertile new possibilities that emerge after transformative upheaval. Multiple volcanoes might represent various emotional or creative pressures building in different areas of your life. In many traditions, volcanoes connect to the earth's creative-destructive power, representing forces that both destroy and renew.",
            category: .nature
        ),
        DreamSymbol(
            name: "Wolf",
            iconName: "hare",
            shortDescription: "Instinct, freedom, and social connection",
            detailedDescription: "Wolves in dreams symbolize instinct, freedom, social connection, or aspects of yourself that are both wild and cooperative. The wolf's behavior and your interaction provide specific insights.\n\nA lone wolf often represents independence, self-reliance, or feelings of isolation from social groups. A wolf pack typically symbolizes community, cooperation, or the need for social support. A friendly wolf might represent integration of instinctual aspects of yourself or beneficial natural impulses.\n\nA threatening wolf can symbolize fears about loss of control or destructive instincts. Being pursued by wolves might represent feeling threatened by instinctual energies or social pressures. Leading or joining a wolf pack frequently symbolizes finding community that honors both individuality and cooperation. In many traditions, wolves connect to teaching about balance between individual needs and group harmony.",
            category: .animals
        ),
        DreamSymbol(
            name: "Garden",
            iconName: "leaf.fill",
            shortDescription: "Personal growth, creative nurturing, and potential",
            detailedDescription: "Gardens in dreams symbolize personal growth, creative nurturing, potential, or the cultivated aspects of your psyche. The garden's condition and your activity within it provide specific insights.\n\nA flourishing garden often represents successful personal development or creative projects nurtured to fruition. A neglected garden typically symbolizes undeveloped potential or aspects of self requiring attention and care. Planting seeds might represent initiating new ideas or projects with future potential.\n\nHarvesting from a garden can symbolize reaping benefits from previous efforts or integrating the fruits of personal growth. A walled garden frequently symbolizes protected inner development or private aspects of self. Different sections of a garden might represent various aspects of your life requiring different types of attention or nurturing approaches. In many traditions, gardens connect to paradise - representing ideal inner states or the rewards of conscious cultivation of self.",
            category: .places
        ),
        DreamSymbol(
            name: "Map",
            iconName: "map",
            shortDescription: "Life direction, guidance, and perspective",
            detailedDescription: "Maps in dreams symbolize life direction, guidance, perspective on your journey, or understanding of your position within a larger context. The type of map and your interaction with it provide specific insights.\n\nReading a clear map often represents having guidance or understanding your life direction. A confusing or unreadable map typically symbolizes uncertainty about direction or lacking necessary information for decisions. Finding an unexpected map might represent discovering new perspectives or paths previously unconsidered.\n\nAn ancient or treasure map can symbolize guidance from collective wisdom or pursuit of valuable but hidden potentials. Creating or drawing a map might represent actively establishing your own understanding of life's territory. Maps showing terrain not yet visited frequently connect to future possibilities or aspects of self not yet explored. The scale of the map - detailed local versus global - can symbolize perspective shift between immediate concerns and larger life patterns.",
            category: .objects
        ),
        DreamSymbol(
            name: "Lightning",
            iconName: "bolt.fill",
            shortDescription: "Sudden insight, transformation, and creative power",
            detailedDescription: "Lightning in dreams symbolizes sudden insight, breakthrough understanding, transformative moments, or creative power that manifests rapidly. The lightning's impact and surrounding conditions provide crucial context.\n\nLightning illuminating darkness often represents sudden clarity about previously obscure matters. Being struck by lightning typically symbolizes transformative insight or life-changing realizations. Lightning that causes destruction might represent breakthrough awareness that disrupts previous understandings or life structures.\n\nBall lightning or unusual lightning behavior can symbolize unique or persistent insights that defy conventional understanding. Multiple lightning strikes might represent various simultaneous realizations or transformative forces active in different life areas. Controlling or directing lightning frequently symbolizes harnessing creative or transformative energies that are typically beyond conscious control. In many traditions, lightning connects to divine inspiration, representing knowledge or power that enters human experience from transpersonal sources.",
            category: .elements
        ),
        DreamSymbol(
            name: "Cave",
            iconName: "shield.lefthalf.filled",
            shortDescription: "Inner depths, unconscious resources, and shelter",
            detailedDescription: "Caves in dreams symbolize inner depths, unconscious resources, primitive aspects of self, or shelter from external pressures. Your movement and experience within the cave provide specific insights.\n\nEntering a cave often represents willingness to explore unconscious content or primitive aspects of yourself. Finding unexpected resources or treasures within a cave typically symbolizes discovering valuable inner resources or potentials. Feeling trapped in a cave might represent anxieties about exploring inner depths or encountering aspects of self that seem threatening.\n\nCave drawings or artifacts can symbolize ancient wisdom or inherited patterns accessible through inner exploration. Light within a cave frequently symbolizes consciousness illuminating previously unconscious material. Multiple cave chambers might represent various domains of unconscious material or inner resources. In many traditions, caves connect to initiation processes - representing protected spaces where transformation occurs before re-emergence into ordinary awareness.",
            category: .places
        ),
        DreamSymbol(
            name: "Lion",
            iconName: "pawprint",
            shortDescription: "Inner power, courage, and leadership",
            detailedDescription: "Lions in dreams symbolize inner power, courage, leadership, or nobility of spirit. The lion's behavior and your interaction with it provide specific insights.\n\nA majestic or peaceful lion often represents integrated personal power or leadership capabilities. A threatening lion typically symbolizes fears about power (your own or others') or challenges that require courage to face. Riding or befriending a lion might represent successful integration of powerful aspects of yourself.\n\nA wounded lion can symbolize compromised power or leadership that requires healing attention. Multiple lions might represent various expressions of power or authority in your life. A lioness with cubs frequently symbolizes protective nurturing of vulnerable new developments. In many traditions, lions connect to solar symbolism - representing conscious expression of power and the courage to be seen in your full authentic nature.",
            category: .animals
        ),
        DreamSymbol(
            name: "Wind",
            iconName: "wind",
            shortDescription: "Change, invisible forces, and mental patterns",
            detailedDescription: "Wind in dreams symbolizes change, invisible forces, thought patterns, or spiritual influences that can be felt but not seen. The wind's character and your response to it provide important context.\n\nA gentle breeze often represents subtle changes, inspiration, or refreshing new influences. A powerful wind typically symbolizes significant change, overwhelming thoughts, or spiritual forces beyond personal control. Wind that changes direction might represent shifting thoughts, influences, or life circumstances.\n\nWind carrying significant items (leaves, papers, objects) can symbolize thoughts or influences transporting important information or opportunities. Walking against strong wind frequently symbolizes resistance to change or struggling against prevailing influences. Wind entering enclosed spaces might represent new thoughts penetrating established mental structures or external influences affecting private domains. In many traditions, wind connects to the element of air - representing thought, communication, and the invisible patterns that shape visible reality.",
            category: .elements
        ),
        DreamSymbol(
            name: "Forest",
            iconName: "tree",
            shortDescription: "Unconscious depths, life journey, and natural wisdom",
            detailedDescription: "Forests in dreams symbolize unconscious depths, the journey through uncharted aspects of life, or natural wisdom beyond civilization. Your movement and experiences within the forest provide specific insights.\n\nA peaceful, sunlit forest often represents harmonious relationship with unconscious aspects of self or natural wisdom. A dark, threatening forest typically symbolizes fears about exploring unknown aspects of yourself or life situations. Finding a path through dense forest might represent discovering direction through complex, unmapped territory.\n\nA forest clearing can symbolize finding clarity or respite during complex life journeys. Ancient trees within forests frequently symbolize wisdom, stability, or connection to ancestral roots. Forest animals might represent instincts, emotions, or aspects of self that thrive in natural rather than constructed environments. In many traditions, forests connect to initiation journeys - representing the necessary navigation of complexity and mystery before reaching new understanding or life phases.",
            category: .nature
        ),
        DreamSymbol(
            name: "Stars",
            iconName: "star.fill",
            shortDescription: "Aspiration, guidance, and cosmic connection",
            detailedDescription: "Stars in dreams symbolize aspiration, guidance, cosmic connection, or potential yet to be fully realized. The arrangement of stars and your interaction with them provide specific insights.\n\nBright, clear stars often represent inspiration, spiritual guidance, or clarity about highest potentials. Falling stars typically symbolize fleeting insight, wishes, or opportunities that require quick response. A single prominent star might represent a guiding purpose or value that orients your life journey.\n\nConstellations can symbolize meaningful patterns in your experience or established wisdom that helps navigation. Stars disappearing or being obscured might represent losing sight of aspirations or guidance during challenging periods. Reaching toward or traveling to stars frequently symbolizes pursuing highest aspirations or seeking transcendent understanding. In many traditions, stars connect to destiny, representing both the unique pattern of individual life and connection to universal order beyond personal concerns.",
            category: .elements
        ),
        DreamSymbol(
            name: "Dolphin",
            iconName: "fish",
            shortDescription: "Intelligence, playfulness, and emotional wisdom",
            detailedDescription: "Dolphins in dreams symbolize intelligence, playfulness, emotional wisdom, or harmony between conscious mind and deeper intuitive knowledge. Your interaction with the dolphin provides specific insights.\n\nSwimming with dolphins often represents joyful connection with your intuitive wisdom or emotional intelligence. Dolphins guiding you through water typically symbolize intuitive guidance through emotional situations or unconscious territory. A dolphin bringing you objects or messages might represent intuitive insights being delivered to conscious awareness.\n\nA dolphin jumping between water and air can symbolize your ability to move between emotional depths and intellectual understanding. A stranded dolphin might represent intuitive or emotional wisdom that lacks proper expression or environment. Multiple dolphins often symbolize community support that honors both playfulness and wisdom. In many traditions, dolphins connect to healing and protection, representing beneficial intelligence that helps humans navigate challenging territory.",
            category: .animals
        ),
        DreamSymbol(
            name: "River",
            iconName: "water.waves",
            shortDescription: "Life force, emotional flow, and time passage",
            detailedDescription: "Rivers in dreams symbolize life force, emotional flow, time passage, or journeys through changing circumstances. The river's character and your relationship to it provide important context.\n\nA clear, flowing river often represents healthy emotional movement or life progressing in natural rhythm. A turbulent river typically symbolizes emotional upheaval or challenging life transitions. A river changing course might represent unexpected shifts in life direction or emotional orientation.\n\nCrossing a river can symbolize transition between different life phases or emotional states. Standing at a river fork frequently symbolizes important life decisions or diverging emotional responses. Rivers feeding into oceans might represent individual life or emotional patterns merging with collective experience. In many traditions, rivers connect to purification and transformation - representing how continued movement cleanses and shapes both the river itself and everything it touches.",
            category: .nature
        ),
        DreamSymbol(
            name: "Theater",
            iconName: "theatermasks.fill",
            shortDescription: "Social roles, performance, and life narratives",
            detailedDescription: "Theaters in dreams symbolize social roles, performance aspects of identity, life narratives, or the stories you tell yourself and others. Your position and activity within the theater provide specific insights.\n\nBeing on stage often represents awareness of being observed or conscious performance in social situations. Being in the audience typically symbolizes observer perspective on your own life or others' experiences. Forgetting lines or failing on stage might represent anxiety about social performance or authenticity.\n\nWorking behind the scenes can symbolize awareness of how you construct your social presentation or influence narratives without being visible. Empty theaters might represent performing without appropriate audience or recognition. The play or performance itself often symbolizes the specific narratives or roles most active in your current experience. In many traditions, theaters connect to the interplay between authentic and constructed aspects of self - representing the creative tension between who you are and how you present to others.",
            category: .places
        ),
        DreamSymbol(
            name: "Snow",
            iconName: "snowflake",
            shortDescription: "Purity, emotional numbness, and temporary covering",
            detailedDescription: "Snow in dreams symbolizes purity, emotional numbness, temporary covering of what's beneath, or the quieting of usual life patterns. The snow's condition and your interaction with it provide specific insights.\n\nFresh, pristine snow often represents new beginnings, purity, or the beauty of simplified perspective. Being cold or frozen in snow typically symbolizes emotional numbness or disconnection. Creating paths through snow might represent pioneering new directions or breaking through emotional stagnation.\n\nMelting snow can symbolize revealing what has been covered or the return of normal emotional flow after a period of numbness. Snowflakes themselves, with their unique patterns, might represent appreciation for individual differences or the crystallization of specific thoughts or insights. A snowstorm frequently symbolizes emotional overwhelm or forced retreat from usual activities to reassess priorities. In many traditions, snow connects to necessary dormancy - representing periods when visible growth pauses while essential developments continue beneath the surface.",
            category: .elements
        ),
        DreamSymbol(
            name: "Ladder",
            iconName: "stairs",
            shortDescription: "Progress, hierarchy, and spiritual ascension",
            detailedDescription: "Ladders in dreams symbolize progress, hierarchy, spiritual ascension, or step-by-step advancement toward goals. The ladder's condition and your movement on it provide specific insights.\n\nClimbing a ladder often represents advancement toward goals or spiritual development. Descending a ladder typically symbolizes accessing deeper understanding or moving from abstract concepts to practical application. A broken or unstable ladder might represent concerns about the reliability of your advancement methods or support structures.\n\nStanding at the top of a ladder can symbolize achievement of perspective or temporarily reaching a goal. A ladder extending beyond view might represent continuous development possibilities or ambitions whose ultimate destination remains unclear. Multiple ladders frequently symbolize various possible advancement paths or hierarchies operating in different life domains. In many traditions, ladders connect to bridging earth and sky - representing the human capacity to move between practical reality and higher understanding through deliberate, sequential effort.",
            category: .objects
        ),
        DreamSymbol(
            name: "Maze",
            iconName: "rectangle.grid.2x2",
            shortDescription: "Confusion, problem-solving, and finding direction",
            detailedDescription: "Mazes in dreams symbolize confusion, complex problem-solving, finding direction among misleading paths, or the experience of being tested. Your navigation experience within the maze provides crucial insights.\n\nSolving a maze successfully often represents finding your way through confusing circumstances or overcoming mental challenges. Feeling hopelessly lost in a maze typically symbolizes confusion about life direction or feeling trapped in circular thinking. Finding unexpected shortcuts might represent intuitive solutions to problems that rational thinking alone cannot solve.\n\nA maze changing configuration can symbolize dealing with problems where the parameters shift unpredictably. Viewing a maze from above frequently symbolizes gaining perspective that makes complex situations more navigable. Unlike labyrinths (which have a single path to center), mazes feature multiple paths and dead ends - this often symbolizes situations with genuine wrong turns and the need for trial-and-error learning. The complexity of the maze typically mirrors the perceived complexity of your current challenges.",
            category: .places
        ),
        DreamSymbol(
            name: "Feather",
            iconName: "leaf.fill",
            shortDescription: "Spiritual connection, freedom, and communication",
            detailedDescription: "Feathers in dreams symbolize spiritual connection, freedom, truth in communication, or messages from beyond ordinary awareness. The feather's type and your interaction with it provide specific insights.\n\nFinding a feather often represents receiving spiritual guidance or messages that seem coincidental but carry significance. A feather floating or carried by wind typically symbolizes trusting life's flow or the lightness that comes from releasing burdens. Writing with a feather quill might represent authentic communication or recording important truths.\n\nFeathers of specific birds carry additional symbolism - eagle feathers often connect to perspective and spiritual authority, owl feathers to wisdom and insight, peacock feathers to beauty and the spiritual eye. Multiple feathers or wings can symbolize readiness for expanded perspective or spiritual movement. In many traditions, feathers connect to the upper world or realm of thought - representing how human consciousness can elevate beyond immediate concerns to broader understanding.",
            category: .objects
        ),
        DreamSymbol(
            name: "Veil",
            iconName: "scribble",
            shortDescription: "Hidden knowledge, mystery, and reality boundaries",
            detailedDescription: "Veils in dreams symbolize hidden knowledge, mystery, separation between realities, or barriers to clear perception. Your interaction with the veil provides specific insights.\n\nLooking through a veil often represents partial understanding of mysteries or perceiving truth through filters of conditioning or belief. Lifting or removing a veil typically symbolizes revelation, spiritual insight, or removing barriers to perception. Being unable to lift a veil might represent mysteries that remain inaccessible or truths you're not yet prepared to face.\n\nWearing a veil can symbolize protecting your own mysteries, maintaining healthy boundaries, or filtering what you reveal to others. Multiple veils might represent layers of understanding that must be penetrated sequentially. In many traditions, veils connect to initiatory processes - representing how truth is revealed gradually as the seeker demonstrates readiness for deeper understanding. The material and color of the veil may add specific significance to its symbolic meaning in your dream.",
            category: .objects
        ),
        DreamSymbol(
            name: "Dragon",
            iconName: "lizard",
            shortDescription: "Primal power, wisdom, and transformative challenges",
            detailedDescription: "Dragons in dreams symbolize primal power, ancient wisdom, transformative challenges, or guardian energy testing readiness for advancement. Your interaction with the dragon provides crucial insights.\n\nBattling a dragon often represents confronting your greatest fears or challenges that guard significant treasure or advancement. Befriending or riding a dragon typically symbolizes integrating powerful energies that seemed threatening but become allies when properly approached. A dragon guarding treasure might represent how your greatest resources are often protected by your most significant challenges.\n\nA sleeping dragon can symbolize dormant potential or power not yet awakened. Multiple dragons might represent various primal energies or challenging forces operating in different life domains. In Eastern traditions, dragons often connect to beneficial power and wisdom, while Western traditions frequently emphasize their challenging aspects - this dual nature often represents how primal energies can be either destructive or beneficial depending on your relationship with them.",
            category: .animals
        )
    ]
}

// Categories for organizing symbols
enum SymbolCategory: String, CaseIterable {
    case nature = "Nature"
    case animals = "Animals"
    case objects = "Objects"
    case places = "Places"
    case people = "People"
    case body = "Body"
    case actions = "Actions"
    case elements = "Elements"
    
    var iconName: String {
        switch self {
        case .nature: return "leaf"
        case .animals: return "hare"
        case .objects: return "cube"
        case .places: return "map"
        case .people: return "person.2"
        case .body: return "figure.stand"
        case .actions: return "figure.walk"
        case .elements: return "flame"
        }
    }
}

// Symbol Detail View - Shown as a modal when a symbol is selected
struct SymbolDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    let symbol: DreamSymbol
    
    @State private var showShareSheet = false
    
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header with Icon
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(lightPurple)
                                .frame(width: 100, height: 100)
                            
                            Image(systemName: symbol.iconName)
                                .font(.system(size: 50))
                                .foregroundColor(primaryPurple)
                        }
                        
                        Text(symbol.name)
                            .font(.system(size: 32, weight: .bold))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Text(symbol.category.rawValue)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(primaryPurple)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(lightPurple)
                            )
                    }
                    .padding(.top, 24)
                    
                    // Divider
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(lightPurple)
                        .padding(.horizontal)
                    
                    // Detailed Description
                    VStack(alignment: .leading, spacing: 16) {
                        Text("What it means in dreams")
                            .font(.system(size: 20, weight: .semibold))
                            .padding(.horizontal)
                        
                        Text(symbol.detailedDescription)
                            .font(.system(size: 16))
                            .lineSpacing(4)
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                    // Share Button
                    Button {
                        // Show share sheet
                        HapticManager.shared.buttonPress()
                        showShareSheet = true
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 16, weight: .semibold))
                            Text("SHARE THIS SYMBOL")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(primaryPurple)
                        )
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 32)
                    .sheet(isPresented: $showShareSheet) {
                        let textToShare = "\(symbol.name) Dream Symbol\n\n\(symbol.detailedDescription)\n\nShared from Lunara Dream Journal"
                        
                        ActivityViewController(activityItems: [textToShare])
                    }
                }
            }
            .navigationBarItems(trailing: Button("Done") {
                dismiss()
            })
            .background(Color(.systemBackground))
        }
    }
}

// Activity View Controller for sharing
struct ActivityViewController: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}
}

// Symbols Library View - Main catalog view
struct SymbolsLibraryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedCategory: SymbolCategory? = nil
    @State private var searchText = ""
    @State private var selectedSymbol: DreamSymbol? = nil
    @State private var showingSubscription = false
    @StateObject private var subscriptionService = SubscriptionService.shared
    
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    
    private var filteredSymbols: [DreamSymbol] {
        let symbols = selectedCategory != nil
            ? DreamSymbol.allSymbols.filter { $0.category == selectedCategory }
            : DreamSymbol.allSymbols
        
        if searchText.isEmpty {
            return symbols
        }
        
        return symbols.filter { $0.name.lowercased().contains(searchText.lowercased()) ||
            $0.shortDescription.lowercased().contains(searchText.lowercased())
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search symbols...", text: $searchText)
                        .foregroundColor(.primary)
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.secondarySystemBackground))
                )
                .padding(.horizontal, 16)
                .padding(.top, 16)
                
                // Category Selector
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        CategoryButton(
                            title: "All",
                            iconName: "circle.grid.3x3.fill",
                            isSelected: selectedCategory == nil,
                            action: { selectedCategory = nil }
                        )
                        
                        ForEach(SymbolCategory.allCases, id: \.self) { category in
                            CategoryButton(
                                title: category.rawValue,
                                iconName: category.iconName,
                                isSelected: selectedCategory == category,
                                action: { selectedCategory = category }
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                
                // Symbols List
                if filteredSymbols.isEmpty {
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 40))
                            .foregroundColor(primaryPurple.opacity(0.5))
                        Text("No symbols found")
                            .font(.headline)
                        Text("Try another search term or category")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    Spacer()
                } else {
                    List {
                        ForEach(filteredSymbols) { symbol in
                            SymbolRow(symbol: symbol, onTap: {
                                // Check subscription status before showing symbol detail
                                if subscriptionService.isSubscribed() {
                                    // Paid user - show symbol details
                                    selectedSymbol = symbol
                                } else {
                                    // Free user - show subscription view
                                    showingSubscription = true
                                }
                            })
                        }
                        .listRowBackground(colorScheme == .dark ? Color(white: 0.15) : .white)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    }
                    .listStyle(PlainListStyle())
                    .background(Color(.systemBackground))
                }
            }
            .navigationTitle("Dream Symbols")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button(action: {
                // Give haptic feedback when tapped
                HapticManager.shared.buttonPress()
                
                dismiss()
            }) {
                ZStack {
                    Circle()
                        .fill(lightPurple)
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(primaryPurple)
                }
            })
            .background(Color(.systemBackground))
            .sheet(item: $selectedSymbol) { symbol in
                SymbolDetailView(symbol: symbol)
            }
            .fullScreenCover(isPresented: $showingSubscription) {
                SubscriptionView()
            }
        }
    }
    
    // Category Button Component
    struct CategoryButton: View {
        let title: String
        let iconName: String
        let isSelected: Bool
        let action: () -> Void
        
        private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
        private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
        
        var body: some View {
            Button(action: {
                HapticManager.shared.buttonPress()
                action()
            }) {
                HStack(spacing: 6) {
                    Image(systemName: iconName)
                        .font(.system(size: 14))
                    Text(title)
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundColor(isSelected ? .white : primaryPurple)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? primaryPurple : lightPurple)
                )
            }
        }
    }
    
    // Symbol Row Component
    struct SymbolRow: View {
        let symbol: DreamSymbol
        let onTap: () -> Void
        @State private var isPressed = false
        
        private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
        private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
        
        var body: some View {
            HStack(spacing: 16) {
                // Symbol Icon
                ZStack {
                    Circle()
                        .fill(lightPurple)
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: symbol.iconName)
                        .font(.system(size: 26))
                        .foregroundColor(primaryPurple)
                }
                
                // Symbol Details
                VStack(alignment: .leading, spacing: 4) {
                    Text(symbol.name)
                        .font(.system(size: 18, weight: .semibold))
                    
                    Text(symbol.shortDescription)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .opacity(isPressed ? 0.7 : 0.5)
                    .offset(x: isPressed ? 5 : 0)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(lightPurple, lineWidth: isPressed ? 2 : 1)
            )
            .shadow(color: Color.black.opacity(isPressed ? 0.01 : 0.03), radius: isPressed ? 3 : 5, x: 0, y: isPressed ? 1 : 2)
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
            .contentShape(Rectangle())
            .onTapGesture {
                // Give haptic feedback
                HapticManager.shared.itemSelected()
                
                // Show press effect
                withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                    isPressed = true
                }
                
                // Delay to show animation before showing details
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                        isPressed = false
                    }
                    
                    // Call the onTap closure
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        onTap()
                    }
                }
            }
        }
    }
}

// Add DailySymbolService after MoodService
class DailySymbolService {
    static let shared = DailySymbolService()
    
    private let userDefaults = UserDefaults.standard
    private let symbolKeyPrefix = "dailySymbol_"
    
    // Save a symbol ID for a specific date
    func saveSymbol(_ symbolId: UUID, for date: Date) {
        let dateKey = dateToKey(date)
        userDefaults.set(symbolId.uuidString, forKey: symbolKeyPrefix + dateKey)
    }
    
    // Get symbol for a specific date
    func getSymbol(for date: Date) -> DreamSymbol? {
        let dateKey = dateToKey(date)
        guard let symbolIdString = userDefaults.string(forKey: symbolKeyPrefix + dateKey),
              let symbolId = UUID(uuidString: symbolIdString) else {
            return nil
        }
        
        return DreamSymbol.allSymbols.first { $0.id == symbolId }
    }
    
    // Check if we already have a symbol for a specific date
    func hasSymbolFor(date: Date) -> Bool {
        return getSymbol(for: date) != nil
    }
    
    // Get (or create) symbol for yesterday
    func getOrCreateYesterdaySymbol() -> DreamSymbol {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        
        if let symbol = getSymbol(for: yesterday) {
            return symbol
        } else {
            let randomSymbol = getRandomSymbol()
            saveSymbol(randomSymbol.id, for: yesterday)
            return randomSymbol
        }
    }
    
    // Get (or create) symbol for today
    func getOrCreateTodaySymbol() -> DreamSymbol {
        let today = Date()
        
        if let symbol = getSymbol(for: today) {
            return symbol
        } else {
            let randomSymbol = getRandomSymbol()
            saveSymbol(randomSymbol.id, for: today)
            return randomSymbol
        }
    }
    
    // Get (or create) symbol for tomorrow
    func getOrCreateTomorrowSymbol() -> DreamSymbol {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        
        if let symbol = getSymbol(for: tomorrow) {
            return symbol
        } else {
            let randomSymbol = getRandomSymbol()
            saveSymbol(randomSymbol.id, for: tomorrow)
            return randomSymbol
        }
    }
    
    // Get random symbol different from specified IDs to avoid duplicates
    private func getRandomSymbol(excluding ids: [UUID] = []) -> DreamSymbol {
        let availableSymbols = DreamSymbol.allSymbols.filter { symbol in
            !ids.contains(symbol.id)
        }
        
        let randomIndex = Int.random(in: 0..<availableSymbols.count)
        return availableSymbols[randomIndex]
    }
    
    // Convert date to a string key (YYYY-MM-DD format)
    private func dateToKey(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    // Check if a new day has started and update symbols if needed
    func checkAndUpdateForNewDay() {
        let today = Date()
        let todayKey = dateToKey(today)
        
        // Key to track the last updated day
        let lastUpdatedKey = "lastUpdatedDailySymbols"
        
        if let lastUpdated = userDefaults.string(forKey: lastUpdatedKey), lastUpdated != todayKey {
            // It's a new day, shift symbols
            shiftSymbols()
            
            // Update the last updated day
            userDefaults.set(todayKey, forKey: lastUpdatedKey)
        } else if userDefaults.string(forKey: lastUpdatedKey) == nil {
            // First time running the app
            userDefaults.set(todayKey, forKey: lastUpdatedKey)
        }
    }
    
    // Shift symbols: yesterday <- today, today <- tomorrow, tomorrow <- new random
    private func shiftSymbols() {
        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today) ?? today
        let dayBeforeYesterday = Calendar.current.date(byAdding: .day, value: -2, to: today) ?? today
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today) ?? today
        
        // Remove symbol from day before yesterday
        userDefaults.removeObject(forKey: symbolKeyPrefix + dateToKey(dayBeforeYesterday))
        
        // If we have today's symbol, move it to yesterday
        if let todaySymbol = getSymbol(for: today) {
            saveSymbol(todaySymbol.id, for: yesterday)
        }
        
        // If we have tomorrow's symbol, move it to today
        if let tomorrowSymbol = getSymbol(for: tomorrow) {
            saveSymbol(tomorrowSymbol.id, for: today)
        }
        
        // Generate new symbol for tomorrow, avoiding duplicates
        let usedSymbolIds = [getSymbol(for: today)?.id, getSymbol(for: yesterday)?.id].compactMap { $0 }
        let newTomorrowSymbol = getRandomSymbol(excluding: usedSymbolIds)
        saveSymbol(newTomorrowSymbol.id, for: tomorrow)
    }
}

// Add the DailySymbolCard view before JournalView
struct DailySymbolCard: View {
    let symbol: DreamSymbol
    let title: String
    let isToday: Bool
    
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    private let grayText = Color.gray
    
    @State private var showingSymbolDetail = false
    @State private var showingSubscription = false
    @StateObject private var subscriptionService = SubscriptionService.shared
    
    var body: some View {
        VStack(spacing: 0) {
            // Spacer at the top for padding
            Spacer()
                .frame(height: 24)
            
            // Title at the top (all caps, gray)
            Text(title)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(grayText)
            
            // Spacer between title and icon
            Spacer()
                .frame(height: 24)
            
            // Large centered icon
            ZStack {
                Circle()
                    .fill(lightPurple)
                    .frame(width: 130, height: 130)
                
                Image(systemName: symbol.iconName)
                    .font(.system(size: 55))
                    .foregroundColor(primaryPurple)
            }
            
            // Spacer between icon and name
            Spacer()
                .frame(height: 24)
            
            // Symbol name (large, bold, centered)
            Text(symbol.name)
                .font(.system(size: 24, weight: .bold))
                .multilineTextAlignment(.center)
            
            // Small spacer between name and description
            Spacer()
                .frame(height: 8)
            
            // Description (centered, gray)
            Text(symbol.shortDescription)
                .font(.system(size: 16))
                .foregroundColor(grayText)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 28)
            
            // Flexible spacer that pushes button to bottom
            Spacer()
                .frame(minHeight: 20) // Minimum height to ensure space for 2 lines
            
            // Full-width button with star icon
            Button {
                HapticManager.shared.buttonPress()
                
                // Check subscription status
                if subscriptionService.isSubscribed() {
                    // Subscribed user - show details
                    showingSymbolDetail = true
                } else {
                    // Free user - show subscription view
                    showingSubscription = true
                }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 14))
                    Text("SHOW MORE")
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundColor(primaryPurple)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .strokeBorder(primaryPurple, lineWidth: 1)
                )
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 28)
        }
        .frame(height: 380)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(Color(.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28)
                .strokeBorder(Color(white: 0.9), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 2)
        .sheet(isPresented: $showingSymbolDetail) {
            SymbolDetailView(symbol: symbol)
        }
        .fullScreenCover(isPresented: $showingSubscription) {
            SubscriptionView()
        }
    }
}

struct DailySymbolsCarousel: View {
    @State private var currentIndex = 1  // Start with today (index 1)
    @State private var yesterdaySymbol: DreamSymbol
    @State private var todaySymbol: DreamSymbol
    @State private var tomorrowSymbol: DreamSymbol
    
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    
    // Date formatter for titles
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()
    
    // Dates
    private var yesterday: Date {
        Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
    }
    
    private var tomorrow: Date {
        Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    }
    
    init() {
        let service = DailySymbolService.shared
        _yesterdaySymbol = State(initialValue: service.getOrCreateYesterdaySymbol())
        _todaySymbol = State(initialValue: service.getOrCreateTodaySymbol())
        _tomorrowSymbol = State(initialValue: service.getOrCreateTomorrowSymbol())
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Title
            HStack {
                Text("Daily Dream Symbols")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
                
                // Page indicators
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(currentIndex == index ? primaryPurple : lightPurple)
                            .frame(width: 8, height: 8)
                    }
                }
            }
            .padding(.horizontal, 16)
            
            // Carousel - adjusted height for new card design
            TabView(selection: $currentIndex) {
                // Yesterday
                DailySymbolCard(
                    symbol: yesterdaySymbol,
                    title: "SYMBOL OF YESTERDAY",
                    isToday: false
                )
                .tag(0)
                
                // Today
                DailySymbolCard(
                    symbol: todaySymbol,
                    title: "SYMBOL OF THE DAY",
                    isToday: true
                )
                .tag(1)
                
                // Tomorrow
                DailySymbolCard(
                    symbol: tomorrowSymbol,
                    title: "SYMBOL OF TOMORROW",
                    isToday: false
                )
                .tag(2)
            }
            .frame(height: 400)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onAppear {
                // Set initial page to Today
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    currentIndex = 1
                }
            }
        }
    }
}

struct JournalView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var showAddJournalEntrySheet = false
    @State private var selectedDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
    @State private var selectedMood: MoodOption?
    @State private var showMoodLoggedAnimation = false
    @State private var selectedTab = 0 // Default to Tracker tab now (0)
    @State private var showingDreamDetails = false
    @State private var selectedDream: DreamEntry?
    @State private var showingBiographyInput = false
    @State private var userBiography = ""
    @State private var showingSymbolsLibrary = false
    @State private var calendarRefreshID = UUID() // Add this line to track calendar refresh state
    @State private var showDreamEntrySheet = false
    @State private var isAppearing = false
    @State private var tabChanged = false
    @State private var calendarMonthChanged = false
    @State private var exploreButtonScale: CGFloat = 1.0
    @State private var showSubscriptionSheet = false
    @StateObject private var subscriptionService = SubscriptionService.shared
    
    // Mock data - replace with Core Data
    @State private var dreams: [DreamEntry] = []
    @State private var dreamsByDate: [Date: [DreamEntry]] = [:]
    
    // Custom colors
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    
    private var selectedDate: Date {
        Calendar.current.date(from: selectedDateComponents) ?? Date()
    }
    
    private var monthYearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
            TopBarView(
                        title: "Journal",
                primaryPurple: primaryPurple,
                colorScheme: colorScheme,
                rightButtons: [
                            TopBarButton(icon: "calendar", action: {
                                // Switch to Calendar tab with animation
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                    selectedTab = 1
                                    tabChanged = true
                                }
                                HapticManager.shared.light()
                            }),
                            TopBarButton(icon: "plus", action: {
                                // Check if user can interpret dreams before showing the flow
                                HapticManager.shared.buttonPress()
                                if subscriptionService.canInterpretDream() {
                                    showDreamEntrySheet = true
                                } else {
                                    // No free attempts left, show subscription view directly
                                    showSubscriptionSheet = true
                                }
                            })
                        ]
                    )
                    .opacity(isAppearing ? 1 : 0)
                    .offset(y: isAppearing ? 0 : -20)
                    .animation(AppAnimation.spring.delay(0.1), value: isAppearing)
                    
                    // Tab Selection - Updated to include Tracker tab
                    Picker("View Selection", selection: $selectedTab) {
                        Text("Tracker").tag(0)
                        Text("Calendar").tag(1)
                        Text("All Dreams").tag(2)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .onChange(of: selectedTab) { _, _ in
                        // Trigger tab change animation
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            tabChanged = true
                        }
                        
                        // Reset after animation completes
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            tabChanged = false
                        }
                        
                        // Provide haptic feedback
                        HapticManager.shared.light()
                    }
                    .opacity(isAppearing ? 1 : 0)
                    .offset(y: isAppearing ? 0 : -10)
                    .animation(AppAnimation.spring.delay(0.2), value: isAppearing)
                    
                    if selectedTab == 0 {
                        TrackerTabView
                            .transition(.asymmetric(
                                insertion: .opacity.combined(with: .move(edge: .leading)),
                                removal: .opacity.combined(with: .move(edge: .trailing))
                            ))
                            .id("tracker-\(tabChanged)")
                    } else if selectedTab == 1 {
                        CalendarTabView
                            .transition(.asymmetric(
                                insertion: selectedTab > 0 ? .opacity.combined(with: .move(edge: .trailing)) : .opacity.combined(with: .move(edge: .leading)),
                                removal: selectedTab > 1 ? .opacity.combined(with: .move(edge: .leading)) : .opacity.combined(with: .move(edge: .trailing))
                            ))
                            .id("calendar-\(tabChanged)-\(calendarMonthChanged)")
                    } else {
                        AllDreamsTabView
                            .transition(.asymmetric(
                                insertion: .opacity.combined(with: .move(edge: .trailing)),
                                removal: .opacity.combined(with: .move(edge: .leading))
                            ))
                            .id("allDreams-\(tabChanged)")
                    }
                }
                .opacity(isAppearing ? 1 : 0)
                .animation(AppAnimation.spring.delay(0.3), value: isAppearing)
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showDreamEntrySheet) {
                DreamEntryFlow()
            }
            .sheet(isPresented: $showingBiographyInput) {
                BiographyInputView(parentBiography: $userBiography)
            }
            .sheet(isPresented: $showingSymbolsLibrary) {
                SymbolsLibraryView()
            }
            .fullScreenCover(isPresented: $showSubscriptionSheet) {
                SubscriptionView()
            }
            .fullScreenCover(isPresented: $showingDreamDetails, onDismiss: {
                print("Dream details dismissed in JournalView")
                // Reset selected dream when sheet is dismissed
                selectedDream = nil
            }) {
                if let dream = selectedDream {
                    NavigationView {
                        DreamInterpretationCoordinatorView(dream: dream)
                            .background(Color(.systemBackground))
                            .onAppear {
                                print("Presenting dream in JournalView - ID: \(dream.id), Name: \(dream.dreamName)")
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
                // Load dreams when view appears
                loadDreams()
                
                // Trigger appearance animations
                withAnimation(AppAnimation.gentleSpring) {
                    isAppearing = true
                }
            }
        }
    }
    
    // MARK: - Tab Views
    
    private var TrackerTabView: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Biography Tile - Styled like Dream Interpreter
                    VStack(spacing: 0) {
                    HStack(alignment: .center, spacing: 16) {
                            // Left part - Icon
                            ZStack {
                                Circle()
                                .fill(lightPurple)
                                    .frame(width: 70, height: 70)
                            Image(systemName: "person.text.rectangle.fill")
                                    .font(.system(size: 28))
                                    .foregroundColor(primaryPurple)
                            }
                            
                            // Right part - Text
                            VStack(alignment: .leading, spacing: 4) {
                            Text("Your Biography")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                            
                            // Get structured biography
                            let structuredBiography = BiographyService.shared.getStructuredBiography()
                            
                            if structuredBiography.isEmpty && userBiography.isEmpty {
                                Text("Adding a biography will help personalize your dream interpretations")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .lineSpacing(2)
                            } else {
                                Text("Your personal details help create more accurate dream interpretations")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .lineSpacing(2)
                            }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                        
                    // Display biography summary if exists
                    let structuredBiography = BiographyService.shared.getStructuredBiography()
                    if !structuredBiography.isEmpty || !userBiography.isEmpty {
                        Divider()
                            .background(lightPurple)
                            .padding(.horizontal, 16)
                        
                        if !structuredBiography.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                // Display structured information by category
                                if !structuredBiography.lifestyle.isEmpty {
                                    BiographyCategoryView(
                                        icon: "briefcase.fill", 
                                        title: "Lifestyle",
                                        items: structuredBiography.lifestyle.map { $0.rawValue }
                                    )
                                }
                                
                                if !structuredBiography.sleepHabits.isEmpty {
                                    BiographyCategoryView(
                                        icon: "bed.double.fill", 
                                        title: "Sleep Habits",
                                        items: structuredBiography.sleepHabits.map { $0.rawValue }
                                    )
                                }
                                
                                if !structuredBiography.personalFactors.isEmpty {
                                    BiographyCategoryView(
                                        icon: "person.fill", 
                                        title: "Personality",
                                        items: structuredBiography.personalFactors.map { $0.rawValue }
                                    )
                                }
                                
                                if !structuredBiography.healthFactors.isEmpty {
                                    BiographyCategoryView(
                                        icon: "heart.fill", 
                                        title: "Health",
                                        items: structuredBiography.healthFactors.map { $0.rawValue }
                                    )
                                }
                                
                                if !structuredBiography.dailyActivities.isEmpty {
                                    BiographyCategoryView(
                                        icon: "calendar.badge.clock", 
                                        title: "Activities",
                                        items: structuredBiography.dailyActivities.map { $0.rawValue }
                                    )
                                }
                                
                                // Display additional notes if available
                                if !structuredBiography.additionalNotes.isEmpty {
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack(spacing: 6) {
                                            Image(systemName: "note.text")
                                                .font(.system(size: 12))
                                                .foregroundColor(primaryPurple)
                                            
                                            Text("Additional Notes")
                                                .font(.system(size: 12, weight: .medium))
                                                .foregroundColor(primaryPurple)
                                        }
                                        
                                        Text(structuredBiography.additionalNotes)
                                            .font(.system(size: 12))
                                            .foregroundColor(.primary)
                                            .lineLimit(3)
                                            .padding(.top, 2)
                                    }
                                    .padding(.horizontal, 16)
                                }
                            }
                            .padding(.vertical, 12)
                        } else if !userBiography.isEmpty {
                            // For backward compatibility, show legacy format if no structured data
                        Text(userBiography)
                            .font(.system(size: 14))
                            .foregroundColor(.primary)
                            .lineLimit(3)
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                        }
                    }
                    
                    Divider()
                        .background(lightPurple)
                        .padding(.horizontal, 16)
                    
                    Button {
                        // Action to add/edit biography
                        HapticManager.shared.buttonPress()
                        showingBiographyInput = true
                    } label: {
                            HStack(spacing: 8) {
                            Image(systemName: structuredBiography.isEmpty && userBiography.isEmpty ? "pencil" : "pencil.line")
                                    .font(.system(size: 16, weight: .semibold))
                            Text(structuredBiography.isEmpty && userBiography.isEmpty ? "ADD BIOGRAPHY" : "EDIT BIOGRAPHY")
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
                            .fill(colorScheme == .dark ? Color(white: 0.15) : .white)
                    )
                    .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .strokeBorder(lightPurple, lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 4)
                .padding(.horizontal, 16)
                
                // Mood Report Tile - Styled like Biometric Analysis
                VStack(spacing: 0) {
                    HStack(alignment: .center, spacing: 16) {
                        // Left part - Icon
                        ZStack {
                            Circle()
                                .fill(lightPurple)
                                .frame(width: 70, height: 70)
                            Image(systemName: "face.smiling")
                                .font(.system(size: 28))
                                .foregroundColor(primaryPurple)
                        }
                        
                        // Right part - Text
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Daily Mood")
                                .font(.title3)
                                .fontWeight(.semibold)
                            if selectedMood != nil {
                                Text("Your mood for today has been recorded")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .lineSpacing(2)
                            } else {
                        Text("How are you feeling today?")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .lineSpacing(2)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    
                    Divider()
                        .background(lightPurple)
                        .padding(.horizontal, 16)
                    
                    // Mood Selector
                    VStack(spacing: 16) {
                        ZStack {
                            // Mood options
                            HStack(spacing: 32) {
                                ForEach(MoodOption.allCases, id: \.self) { mood in
                                    Button {
                                        // Add haptic feedback
                                        HapticManager.shared.buttonPress()
                                        
                                        // Set selected mood
                                        selectedMood = mood
                                        
                                        // Save mood for today
                                        MoodService.shared.saveMood(mood, for: Date())
                                        
                                        // Show logged animation
                                        withAnimation(.spring(response: 0.3)) {
                                            showMoodLoggedAnimation = true
                                        }
                                        
                                        // Hide animation after delay
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                            withAnimation {
                                                showMoodLoggedAnimation = false
                                            }
                                        }
                                    } label: {
                                        Text(mood.emoji)
                                            .font(.system(size: 32))
                                            .opacity(selectedMood == mood ? 1.0 : 0.5)
                                            .scaleEffect(selectedMood == mood ? 1.2 : 1.0)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .animation(.spring(response: 0.3), value: selectedMood)
                                }
                            }
                            
                            // Success checkmark animation overlay
                            if showMoodLoggedAnimation {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(primaryPurple.opacity(0.2))
                                        .frame(height: 70)
                                    
                                    HStack(spacing: 12) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 24))
                                            .foregroundColor(primaryPurple)
                                        
                                        Text("Mood logged!")
                                            .font(.headline)
                                            .foregroundColor(primaryPurple)
                                    }
                                }
                                .transition(.opacity)
                            }
                        }
                        
                        Text(selectedMood?.description ?? "Select your mood")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(selectedMood != nil ? primaryPurple : .secondary)
                            .animation(.easeInOut, value: selectedMood)
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 16)
                }
                    .background(
                    RoundedRectangle(cornerRadius: 24)
                            .fill(colorScheme == .dark ? Color(white: 0.15) : .white)
                    )
                    .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .strokeBorder(lightPurple, lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 4)
                .padding(.horizontal, 16)
                
                // REPLACING the "Symbol of the Day" tile with the new carousel
                DailySymbolsCarousel()
                    .padding(.horizontal, 16)
                
                // Explore Symbols Button - Like Unlock all features
                Button {
                    // Action to explore symbols
                    HapticManager.shared.buttonPress()
                    
                    // Button animation
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                        exploreButtonScale = 0.95
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                            exploreButtonScale = 1.0
                        }
                    }
                    
                    // Show symbols library
                    showingSymbolsLibrary = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 16, weight: .semibold))
                        Text("EXPLORE ALL SYMBOLS")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(primaryPurple)
                    )
                }
                .scaleEffect(exploreButtonScale)
                .padding(.horizontal, 16)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
            }
            .padding(.vertical, 24)
            .padding(.bottom, 80) // Add extra padding at the bottom to prevent overlap with tab bar
        }
    }
    
    private func loadDreams() {
        dreams = DreamStorageService.shared.getAllDreams()
        dreamsByDate = DreamStorageService.shared.getDreamsGroupedByMonth()
        
        // Load the user's biography
        userBiography = BiographyService.shared.getBiography()
    }
    
    private var AllDreamsTabView: some View {
        ScrollView {
            VStack(spacing: 16) {
                        if dreams.isEmpty {
                    VStack(spacing: 16) {
                                Image(systemName: "moon.zzz.fill")
                            .font(.system(size: 48))
                                    .foregroundColor(primaryPurple.opacity(0.5))
                            .scaleEffect(isAppearing ? 1.0 : 0.8)
                            .opacity(isAppearing ? 1.0 : 0.0)
                            .animation(AppAnimation.spring.delay(0.4), value: isAppearing)
                        
                        Text("No Dreams Recorded Yet")
                            .font(.headline)
                                    .foregroundColor(.secondary)
                            .opacity(isAppearing ? 1.0 : 0.0)
                            .offset(y: isAppearing ? 0 : 10)
                            .animation(AppAnimation.spring.delay(0.5), value: isAppearing)
                        
                        Text("Your dream interpretations will appear here once you save them.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                            .opacity(isAppearing ? 1.0 : 0.0)
                            .offset(y: isAppearing ? 0 : 10)
                            .animation(AppAnimation.spring.delay(0.6), value: isAppearing)
                            }
                            .frame(maxWidth: .infinity)
                    .padding(.vertical, 100)
                        } else {
                    ForEach(Array(dreams.enumerated()), id: \.element.id) { index, dream in
                        DreamListItem(
                            dream: dream,
                            isLast: index == dreams.count - 1,
                            primaryPurple: primaryPurple,
                            onTap: {
                                print("Dream selected in JournalView AllDreamsTab: \(dream.id), \(dream.dreamName)")
                                self.selectedDream = dream
                                self.showingDreamDetails = true
                            }
                        )
                        .onAppear {
                            // Trigger the isAppearing state for each item with a staggered delay
                            let delay = Double(index) * 0.1
                            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                                withAnimation(AppAnimation.spring) {
                                    // This will trigger the animation in DreamListItem
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 24)
            .padding(.bottom, 80) // Add extra padding at the bottom to prevent overlap with tab bar
        }
    }
    
    private var CalendarTabView: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Calendar View
                            VStack(spacing: 16) {
                    // Month header with navigation
                    HStack {
                                    Button(action: {
                            navigateToPreviousMonth()
                            // Provide haptic feedback
                            HapticManager.shared.light()
                            
                            // Trigger month change animation
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                calendarMonthChanged = true
                            }
                            
                            // Reset after animation completes
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                calendarMonthChanged = false
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                                .foregroundColor(primaryPurple)
                                .padding(8)
                                .background(Circle().fill(DynamicColors.backgroundSecondary))
                                .scaleEffect(calendarMonthChanged ? 0.9 : 1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: calendarMonthChanged)
                        }
                        
                                            Spacer()
                        
                        Text(monthYearFormatter.string(from: selectedDate))
                            .font(.headline)
                            .opacity(calendarMonthChanged ? 0.5 : 1.0)
                            .offset(x: calendarMonthChanged ? -20 : 0)
                            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: calendarMonthChanged)
                        
                        Spacer()
                        
                        Button(action: {
                            navigateToNextMonth()
                            // Provide haptic feedback
                            HapticManager.shared.light()
                            
                            // Trigger month change animation
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                calendarMonthChanged = true
                            }
                            
                            // Reset after animation completes
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                calendarMonthChanged = false
                            }
                        }) {
                            Image(systemName: "chevron.right")
                                .foregroundColor(primaryPurple)
                                .padding(8)
                                .background(Circle().fill(DynamicColors.backgroundSecondary))
                                .scaleEffect(calendarMonthChanged ? 0.9 : 1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: calendarMonthChanged)
                        }
                    }
                    .padding(.horizontal, 8)
                    
                    // Custom Calendar Implementation (replacing DatePicker)
                    VStack(spacing: 12) {
                        // Weekday headers
                        HStack(spacing: 0) {
                            ForEach(["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"], id: \.self) { day in
                                Text(day)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .padding(.top, 8)
                        
                        // Calendar grid
                        let daysInMonth = numberOfDaysInMonth(selectedDate)
                        let firstWeekday = getFirstWeekdayOfMonth(selectedDate)
                        let totalDays = firstWeekday - 1 + daysInMonth
                        let totalWeeks = (totalDays + 6) / 7
                        
                        GeometryReader { geometry in
                            VStack(spacing: 0) {
                                ForEach(0..<totalWeeks, id: \.self) { week in
                                    HStack(spacing: 0) {
                                        ForEach(0..<7, id: \.self) { weekday in
                                            let day = week * 7 + weekday + 1 - (firstWeekday - 1)
                                            if day > 0 && day <= daysInMonth {
                                                Button(action: {
                                                    selectDate(day: day)
                                                }) {
                                                    ZStack {
                                                        // Selection indicator
                                                        if isSelectedDay(day) {
                                                            Circle()
                                                                .fill(primaryPurple)
                                                                .frame(width: 36, height: 36)
                                                        }
                                                        
                                                        Text("\(day)")
                                                            .foregroundColor(isSelectedDay(day) ? .white : DynamicColors.textPrimary)
                                                        
                                                        // Dream indicator
                                                        if hasDreamsOnDay(day) {
                                                            let count = dreamCountForDay(day)
                                                            DreamIndicator(count: count)
                                                                .offset(x: 12, y: -12)
                                                        }
                                                    }
                                                }
                                                .frame(width: geometry.size.width / 7, height: geometry.size.height / CGFloat(totalWeeks))
                                            } else {
                                                // Empty cell
                                                Color.clear
                                                    .frame(width: geometry.size.width / 7, height: geometry.size.height / CGFloat(totalWeeks))
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .frame(height: 300)
                    }
                    .padding(.top, 4)
                    }
                    .padding()
                    .background(
                    RoundedRectangle(cornerRadius: 24)
                            .fill(colorScheme == .dark ? Color(white: 0.15) : .white)
                    )
                    .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .strokeBorder(lightPurple, lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.0 : 0.05), radius: 15, x: 0, y: 4)
                
                // Dreams for selected date
                VStack(alignment: .leading, spacing: 16) {
                    Text("Dreams on \(formatDateHeader(selectedDate))")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .opacity(calendarMonthChanged ? 0.0 : 1.0)
                        .offset(y: calendarMonthChanged ? 10 : 0)
                        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: calendarMonthChanged)
                    
                    let dreamsForDate = dreams.filter { Calendar.current.isDate($0.createdAt, inSameDayAs: selectedDate) }
                    
                    if dreamsForDate.isEmpty {
                        EmptyDreamsView(primaryPurple: primaryPurple)
                            .opacity(calendarMonthChanged ? 0.0 : 1.0)
                            .offset(y: calendarMonthChanged ? 10 : 0)
                            .animation(.spring(response: 0.4, dampingFraction: 0.7).delay(0.1), value: calendarMonthChanged)
                    } else {
                        ForEach(Array(dreamsForDate.enumerated()), id: \.element.id) { index, dream in
                            DreamListItem(
                                dream: dream,
                                isLast: index == dreamsForDate.count - 1,
                                primaryPurple: primaryPurple,
                                onTap: {
                                    print("Dream selected in JournalView CalendarTab: \(dream.id), \(dream.dreamName)")
                                    self.selectedDream = dream
                                    self.showingDreamDetails = true
                                }
                            )
                            .opacity(calendarMonthChanged ? 0.0 : 1.0)
                            .offset(y: calendarMonthChanged ? 10 : 0)
                            .animation(
                                .spring(response: 0.4, dampingFraction: 0.7)
                                .delay(0.1 + Double(index) * 0.05),
                                value: calendarMonthChanged
                            )
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(colorScheme == .dark ? Color(white: 0.15) : .white)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .strokeBorder(lightPurple, lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.0 : 0.05), radius: 15, x: 0, y: 4)
            }
            .padding(16)
            .padding(.bottom, 80) // Add extra padding at the bottom to prevent overlap with tab bar
        }
    }
    
    // MARK: - Helper Methods
    
    private func navigateToPreviousMonth() {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)
        components.month = (components.month ?? 1) - 1
        if let newDate = Calendar.current.date(from: components) {
            selectedDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: newDate)
        }
    }
    
    private func navigateToNextMonth() {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)
        components.month = (components.month ?? 1) + 1
        if let newDate = Calendar.current.date(from: components) {
            selectedDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: newDate)
        }
    }
    
    private func formatDateHeader(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    // Helper functions for calendar indicators
    private func getDatesWithDreams() -> [Date] {
        var uniqueDates = Set<Date>()
        for dream in dreams {
            let startOfDay = Calendar.current.startOfDay(for: dream.createdAt)
            uniqueDates.insert(startOfDay)
        }
        return Array(uniqueDates).sorted()
    }
    
    private func getDatesWithDreamsForDisplayedMonth() -> [Date] {
        // Get year and month from selected date
        let calendar = Calendar.current
        let year = calendar.component(.year, from: selectedDate)
        let month = calendar.component(.month, from: selectedDate)
        
        return getDatesWithDreams().filter { date in
            let components = calendar.dateComponents([.year, .month], from: date)
            return components.year == year && components.month == month
        }
    }
    
    private func isDateInCurrentMonth(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month], from: date)
        let selectedComponents = calendar.dateComponents([.year, .month], from: selectedDate)
        
        return dateComponents.year == selectedComponents.year && 
               dateComponents.month == selectedComponents.month
    }
    
    private func getDateFrame(for date: Date, in geometry: GeometryProxy) -> CGRect? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        guard let day = components.day,
              let month = components.month,
              let year = components.year else { return nil }
        
        // Get first day of the month
        let firstOfMonth = calendar.date(from: DateComponents(year: year, month: month, day: 1))!
        
        // Get the weekday of the first day (1 = Sunday, 2 = Monday, etc.)
        let firstWeekday = calendar.component(.weekday, from: firstOfMonth)
        
        // Calculate grid position
        let weekday = calendar.component(.weekday, from: date)
        let week = (day + firstWeekday - 2) / 7
        let dayOfWeek = (weekday + 5) % 7 // Convert to 0-based index where Monday is 0
        
        let width = geometry.size.width / 7
        let height = (geometry.size.height - 32) / 6 // Adjusted for header
        
        return CGRect(
            x: CGFloat(dayOfWeek) * width + width/2,
            y: 32 + CGFloat(week) * height + height - 4,
            width: width,
            height: height
        )
    }
    
    // Helper methods for the custom calendar
    private func numberOfDaysInMonth(_ date: Date) -> Int {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    
    private func getFirstWeekdayOfMonth(_ date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        let firstDayOfMonth = calendar.date(from: components)!
        
        // 1 is Sunday in Calendar.current, but we want Monday to be 1
        let weekday = calendar.component(.weekday, from: firstDayOfMonth)
        return (weekday + 5) % 7 + 1 // Convert from Sunday=1 to Monday=1
    }
    
    private func isSelectedDay(_ day: Int) -> Bool {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: selectedDate)
        return components.day == day
    }
    
    private func selectDate(day: Int) {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month], from: selectedDate)
        components.day = day
        if let newDate = calendar.date(from: components) {
            selectedDateComponents = calendar.dateComponents([.year, .month, .day], from: newDate)
        }
    }
    
    private func hasDreamsOnDay(_ day: Int) -> Bool {
        return dreamCountForDay(day) > 0
    }
    
    private func dreamCountForDay(_ day: Int) -> Int {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month], from: selectedDate)
        components.day = day
        
        guard let date = calendar.date(from: components) else { return 0 }
        
        return dreams.filter { dream in
            calendar.isDate(dream.createdAt, inSameDayAs: date)
        }.count
    }
}

// MARK: - Helper Views
struct BiographyCategoryView: View {
    let icon: String
    let title: String
    let items: [String]
    
    // Add color definition
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Category header
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 12))
                    .foregroundColor(primaryPurple)
                
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(primaryPurple)
            }
            
            // Flow layout for tags
            FlowLayout(spacing: 4) {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .font(.system(size: 12))
                        .foregroundColor(.primary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(UIColor.systemGray6))
                        )
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

// Flow layout to arrange items in rows
struct FlowLayout: Layout {
    var spacing: CGFloat
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? .infinity
        var height: CGFloat = 0
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        
        var rowWidth: CGFloat = 0
        var rowHeight: CGFloat = 0
        
        for size in sizes {
            if rowWidth + size.width > width {
                // Start a new row
                height += rowHeight + spacing
                rowWidth = size.width
                rowHeight = size.height
            } else {
                // Add to current row
                rowWidth += size.width + (rowWidth > 0 ? spacing : 0)
                rowHeight = max(rowHeight, size.height)
            }
        }
        
        // Add the last row
        if rowHeight > 0 {
            height += rowHeight
        }
        
        return CGSize(width: width, height: height)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        
        var rowX = bounds.minX
        var rowY = bounds.minY
        var rowHeight: CGFloat = 0
        
        for (index, subview) in subviews.enumerated() {
            let size = sizes[index]
            
            if rowX + size.width > bounds.maxX {
                // Start a new row
                rowX = bounds.minX
                rowY += rowHeight + spacing
                rowHeight = size.height
            } else {
                // Continue in current row
                rowHeight = max(rowHeight, size.height)
            }
            
            subview.place(
                at: CGPoint(x: rowX, y: rowY),
                proposal: ProposedViewSize(size)
            )
            
            rowX += size.width + spacing
        }
    }
}

#Preview {
    JournalView()
} 