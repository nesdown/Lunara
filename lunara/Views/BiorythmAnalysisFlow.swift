import SwiftUI
import Foundation // For Date operations

struct BiorythmAnalysisFlow: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var viewModel = BiorythmAnalysisViewModel()
    
    // Custom colors
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground).edgesIgnoringSafeArea(.all)
                
                // Flow content
                VStack(spacing: 0) {
                    // Top Bar
                    HStack {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primary)
                                .padding(10)
                                .background(Color(.systemGray6))
                                .clipShape(Circle())
                        }
                        .padding(.leading)
                        
                        Spacer()
                        
                        Text("Biorythm Analysis")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        // For visual balance (empty button-sized space)
                        Circle()
                            .fill(Color.clear)
                            .frame(width: 36, height: 36)
                            .padding(.trailing)
                    }
                    .padding(.top)
                    .padding(.bottom, 16)
                    
                    // Progress indicator
                    if !viewModel.isShowingResults && viewModel.currentStep <= 5 {
                        ProgressBar(currentStep: viewModel.currentStep, totalSteps: 5)
                            .padding(.horizontal)
                            .padding(.bottom, 24)
                    }
                    
                    // Content based on current step
                    ScrollView {
                        VStack(spacing: 24) {
                            if viewModel.isShowingResults {
                                resultsView
                            } else {
                                switch viewModel.currentStep {
                                case 1:
                                    informationView
                                case 2:
                                    birthDateView
                                case 3:
                                    dreamFrequencyView
                                case 4:
                                    nightmareFrequencyView
                                case 5:
                                    sleepDurationView
                                case 6:
                                    loadingView
                                default:
                                    EmptyView()
                                }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                    }
                    
                    // Navigation buttons
                    if !viewModel.isShowingResults && viewModel.currentStep <= 5 {
                        HStack(spacing: 16) {
                            // Back button (except on first step)
                            if viewModel.currentStep > 1 {
                                Button {
                                    withAnimation {
                                        viewModel.currentStep -= 1
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
                                    if viewModel.currentStep == 5 {
                                        viewModel.submitAnalysis()
                                    } else {
                                        viewModel.currentStep += 1
                                    }
                                }
                            } label: {
                                Text(viewModel.currentStep == 5 ? "Get Results" : "Continue")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.vertical, 16)
                                    .frame(maxWidth: .infinity)
                                    .background(primaryPurple)
                                    .cornerRadius(24)
                            }
                            .disabled(viewModel.isNextButtonDisabled)
                        }
                        .padding()
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Step Views
    
    // Step 1: Information View
    private var informationView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Image(systemName: "waveform.path.ecg")
                .font(.system(size: 60))
                .foregroundColor(primaryPurple)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 10)
            
            Text("How Biorythm Analysis Works")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("Sleep biorhythms help you understand how your natural cycles affect your daily energy and focus. By using your birth date and analyzing your sleep journal, the app calculates a personalized \"biorhythm number,\" revealing your peak times for productivity, rest, and focus.")
                .font(.body)
                .lineSpacing(4)
                .padding(.bottom, 10)
            
            Text("Sleep biorhythms help you understand how your natural cycles affect your daily energy and focus. By using your birth date and analyzing your sleep journal, the app calculates a personalized \"biorhythm number,\" revealing your peak times for productivity, rest, and focus.")
                .font(.body)
                .lineSpacing(4)
                
            Spacer()
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
    
    // Step 2: Birth Date View
    private var birthDateView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Enter Your Birth Date")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("Your birth date is used to calculate your personal biorhythm cycle. This information is stored locally on your device and is not shared with anyone.")
                .font(.body)
                .lineSpacing(4)
                .padding(.bottom, 10)
            
            DatePicker(
                "Birth Date",
                selection: $viewModel.birthDate,
                displayedComponents: .date
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .frame(maxHeight: 400)
            .tint(primaryPurple)
            
            Spacer()
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
    
    // Step 3: Dream Frequency View
    private var dreamFrequencyView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("How often do you see dreams?")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("Dream frequency is a key indicator of your sleep quality and REM cycle patterns. This helps us understand your natural sleep rhythm.")
                .font(.body)
                .lineSpacing(4)
                .padding(.bottom, 20)
            
            ForEach(DreamFrequency.allCases, id: \.self) { frequency in
                Button {
                    viewModel.dreamFrequency = frequency
                } label: {
                    HStack {
                        Text(frequency.rawValue)
                            .font(.body)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        if viewModel.dreamFrequency == frequency {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(primaryPurple)
                        } else {
                            Circle()
                                .stroke(Color.gray, lineWidth: 1)
                                .frame(width: 24, height: 24)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(viewModel.dreamFrequency == frequency ? 
                                 lightPurple.opacity(0.3) : 
                                 (colorScheme == .dark ? Color(.systemGray5) : Color(.systemGray6)))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(viewModel.dreamFrequency == frequency ? primaryPurple : Color.clear, lineWidth: 1)
                    )
                }
                .padding(.bottom, 8)
            }
            
            Spacer()
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
    
    // Step 4: Nightmare Frequency View
    private var nightmareFrequencyView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("How many of those are nightmares?")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("Nightmares can be indicators of stress levels and emotional processing during sleep. This information helps us understand your sleep quality.")
                .font(.body)
                .lineSpacing(4)
                .padding(.bottom, 20)
            
            ForEach(NightmareFrequency.allCases, id: \.self) { frequency in
                Button {
                    viewModel.nightmareFrequency = frequency
                } label: {
                    HStack {
                        Text(frequency.rawValue)
                            .font(.body)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        if viewModel.nightmareFrequency == frequency {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(primaryPurple)
                        } else {
                            Circle()
                                .stroke(Color.gray, lineWidth: 1)
                                .frame(width: 24, height: 24)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(viewModel.nightmareFrequency == frequency ? 
                                 lightPurple.opacity(0.3) : 
                                 (colorScheme == .dark ? Color(.systemGray5) : Color(.systemGray6)))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(viewModel.nightmareFrequency == frequency ? primaryPurple : Color.clear, lineWidth: 1)
                    )
                }
                .padding(.bottom, 8)
            }
            
            Spacer()
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
    
    // Step 5: Sleep Duration View
    private var sleepDurationView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("How long do you usually sleep?")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("Sleep duration directly affects your biorhythm cycles and overall health. This helps us calculate your optimal rest and activity periods.")
                .font(.body)
                .lineSpacing(4)
                .padding(.bottom, 20)
            
            ForEach(SleepDuration.allCases, id: \.self) { duration in
                Button {
                    viewModel.sleepDuration = duration
                } label: {
                    HStack {
                        Text(duration.rawValue)
                            .font(.body)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        if viewModel.sleepDuration == duration {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(primaryPurple)
                        } else {
                            Circle()
                                .stroke(Color.gray, lineWidth: 1)
                                .frame(width: 24, height: 24)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(viewModel.sleepDuration == duration ? 
                                 lightPurple.opacity(0.3) : 
                                 (colorScheme == .dark ? Color(.systemGray5) : Color(.systemGray6)))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(viewModel.sleepDuration == duration ? primaryPurple : Color.clear, lineWidth: 1)
                    )
                }
                .padding(.bottom, 8)
            }
            
            Spacer()
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
    
    // Loading View
    private var loadingView: some View {
        VStack(spacing: 24) {
            ZStack {
                // Outer pulsing circle
                Circle()
                    .fill(primaryPurple.opacity(0.2))
                    .frame(width: 120, height: 120)
                    .scaleEffect(viewModel.pulsateAnimation ? 1.2 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true),
                        value: viewModel.pulsateAnimation
                    )
                
                // Middle circle
                Circle()
                    .fill(primaryPurple.opacity(0.3))
                    .frame(width: 90, height: 90)
                
                // Inner circle with icon
                Circle()
                    .fill(primaryPurple.opacity(0.5))
                    .frame(width: 70, height: 70)
                
                // Icon inside
                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                    .rotationEffect(Angle(degrees: viewModel.rotationAnimation ? 360 : 0))
                    .animation(
                        Animation.linear(duration: 10)
                            .repeatForever(autoreverses: false),
                        value: viewModel.rotationAnimation
                    )
            }
            .onAppear {
                viewModel.pulsateAnimation = true
                viewModel.rotationAnimation = true
            }
            
            Text("Calculating your biorhythm...")
                .font(.title3)
                .fontWeight(.medium)
            
            Text("We're analyzing your sleep patterns and calculating your personal biorhythm number.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
        .padding(.horizontal, 24)
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
    
    // Results View
    private var resultsView: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Spacer()
                ZStack {
                    Circle()
                        .fill(primaryPurple.opacity(0.2))
                        .frame(width: 120, height: 120)
                    
                    Circle()
                        .fill(primaryPurple.opacity(0.4))
                        .frame(width: 100, height: 100)
                    
                    Text(viewModel.biorythmNumber)
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(primaryPurple)
                }
                Spacer()
            }
            .padding(.vertical, 16)
            
            Text("Your Biorhythm Number")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 16)
            
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "questionmark.circle.fill")
                            .foregroundColor(primaryPurple)
                        Text("What does this mean?")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    
                    Text(viewModel.biorythmMeaning)
                        .font(.body)
                        .lineSpacing(4)
                }
                
                Divider()
                    .background(lightPurple)
                    .padding(.vertical, 8)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "calendar.circle.fill")
                            .foregroundColor(primaryPurple)
                        Text("How this impacts your daily life")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    
                    Text(viewModel.dailyImpact)
                        .font(.body)
                        .lineSpacing(4)
                }
                
                Divider()
                    .background(lightPurple)
                    .padding(.vertical, 8)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "lightbulb.circle.fill")
                            .foregroundColor(primaryPurple)
                        Text("What to do with this information")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    
                    Text(viewModel.recommendations)
                        .font(.body)
                        .lineSpacing(4)
                }
            }
            .padding(.horizontal, 4)
            
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Done")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .background(primaryPurple)
                    .cornerRadius(24)
            }
            .padding(.top, 24)
        }
        .padding(24)
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
}

// MARK: - Progress Bar
struct ProgressBar: View {
    let currentStep: Int
    let totalSteps: Int
    
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    
    var body: some View {
        VStack(spacing: 4) {
            HStack {
                ForEach(1...totalSteps, id: \.self) { step in
                    Capsule()
                        .fill(step <= currentStep ? primaryPurple : Color.gray.opacity(0.3))
                        .frame(height: 4)
                    
                    if step < totalSteps {
                        Spacer()
                    }
                }
            }
            
            HStack {
                Text("Step \(currentStep) of \(totalSteps)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
        }
    }
}

// MARK: - ViewModel
class BiorythmAnalysisViewModel: ObservableObject {
    @Published var currentStep = 1
    @Published var birthDate = Calendar.current.date(byAdding: .year, value: -30, to: Date()) ?? Date()
    @Published var dreamFrequency: DreamFrequency?
    @Published var nightmareFrequency: NightmareFrequency?
    @Published var sleepDuration: SleepDuration?
    
    @Published var isShowingResults = false
    @Published var biorythmNumber = "7"
    @Published var biorythmMeaning = "Your biorhythm number indicates you have a balanced energy cycle with peaks in the morning hours."
    @Published var dailyImpact = "You likely experience your highest energy and focus in the morning between 7-10 AM. Your natural dip occurs in the mid-afternoon, around 2-4 PM, when you may feel less productive."
    @Published var recommendations = "Schedule important tasks during your morning peak hours. Take a short rest or perform less demanding tasks during your afternoon dip. Consider going to bed around 10 PM to align with your natural sleep cycle."
    
    @Published var pulsateAnimation = false
    @Published var rotationAnimation = false
    
    var isNextButtonDisabled: Bool {
        switch currentStep {
        case 3:
            return dreamFrequency == nil
        case 4:
            return nightmareFrequency == nil
        case 5:
            return sleepDuration == nil
        default:
            return false
        }
    }
    
    func submitAnalysis() {
        // In a real app, we would send data to OpenAI here
        // For this example, we'll just simulate a request
        
        // Add haptic feedback when starting analysis
        HapticManager.shared.medium()
        
        // Save birth date to UserDefaults
        UserDefaults.standard.set(birthDate, forKey: "userBirthDate")
        
        // Show loading state first
        withAnimation {
            currentStep = 6
        }
        
        // Start animations
        pulsateAnimation = true
        rotationAnimation = true
        
        // Simulate loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else { return }
            
            // In a real implementation, these values would come from OpenAI
            self.calculateBiorythm()
            
            // Add haptic feedback when showing results
            HapticManager.shared.analysisRevealed()
            
            // Show results
            withAnimation {
                self.currentStep = 7
                self.isShowingResults = true
            }
        }
    }
    
    private func calculateBiorythm() {
        // This is a placeholder for the actual calculation
        // In a real implementation, this would process the OpenAI response
        
        // Calculate days since birth
        let daysSinceBirth = Calendar.current.dateComponents([.day], from: birthDate, to: Date()).day ?? 0
        
        // Generate a number between 1-9 based on dream frequency, nightmares, and sleep duration
        var baseNumber = (daysSinceBirth % 9) + 1
        
        // Adjust based on dream frequency
        if dreamFrequency == .never {
            baseNumber = max(1, baseNumber - 2)
        } else if dreamFrequency == .eachNight {
            baseNumber = min(9, baseNumber + 2)
        }
        
        // Adjust based on nightmare frequency
        if nightmareFrequency == .eachOne {
            baseNumber = max(1, baseNumber - 1)
        } else if nightmareFrequency == NightmareFrequency.none {
            baseNumber = min(9, baseNumber + 1)
        }
        
        // Adjust based on sleep duration
        if sleepDuration == .lessThan5Hours {
            baseNumber = max(1, baseNumber - 1)
        } else if sleepDuration == .moreThan9Hours {
            baseNumber = min(9, baseNumber + 1)
        }
        
        biorythmNumber = String(baseNumber)
        
        // Set appropriate descriptions based on the number
        switch baseNumber {
        case 1:
            biorythmMeaning = "Your biorhythm number indicates you have a highly analytical mind with strong independence."
            dailyImpact = "You tend to be most productive when working alone. Your energy peaks in the late evening and you may prefer staying up late."
            recommendations = "Schedule creative or complex problem-solving tasks for evening hours. Consider creating a dedicated workspace free from distractions."
        case 2:
            biorythmMeaning = "Your biorhythm number shows you're naturally intuitive and sensitive to the energies around you."
            dailyImpact = "Your energy is most balanced in mid-morning and early evening. You may experience emotional fluctuations throughout the day."
            recommendations = "Maintain a consistent sleep schedule, going to bed and waking up at the same time. Practice grounding techniques if you feel emotionally overwhelmed."
        case 3:
            biorythmMeaning = "Your biorhythm number reveals a creative and expressive nature, with rhythmic energy flow."
            dailyImpact = "You experience energy bursts throughout the day rather than a single peak. You're most creative in the late morning and early evening."
            recommendations = "Break your day into focused creative sessions of 60-90 minutes followed by short breaks. Use meditation to reset your energy between tasks."
        case 4:
            biorythmMeaning = "Your biorhythm number indicates a practical and disciplined nature with a need for structure."
            dailyImpact = "Your energy is most stable in the early morning hours, with a consistent decline throughout the day."
            recommendations = "Front-load your most demanding tasks in the first half of your day. Create a structured sleep routine, ideally going to bed before 10 PM."
        case 5:
            biorythmMeaning = "Your biorhythm number shows adaptability and a need for variety in daily rhythms."
            dailyImpact = "Your energy fluctuates more than most, with mini-peaks throughout the day. This makes you adaptable but sometimes inconsistent."
            recommendations = "Embrace your changing energy by planning different types of activities throughout the day. Use your high-energy moments for challenging tasks."
        case 6:
            biorythmMeaning = "Your biorhythm number indicates a harmonious nature and balanced energy cycles."
            dailyImpact = "You maintain relatively steady energy throughout the day with a slight dip in the afternoon."
            recommendations = "Create a balanced daily schedule that alternates between mental and physical activities. Allow for a short afternoon rest to maintain evening energy."
        case 7:
            biorythmMeaning = "Your biorhythm number reveals a contemplative nature with deep intuitive insights."
            dailyImpact = "You experience strong morning energy, a significant afternoon dip, and a second wind in the evening."
            recommendations = "Use mornings for analytical work, afternoons for routine tasks, and evenings for creative or introspective activities."
        case 8:
            biorythmMeaning = "Your biorhythm number shows an ambitious nature with powerful energy cycles."
            dailyImpact = "You have sustained high energy for long periods followed by deeper recovery needs."
            recommendations = "Work in focused 90-minute blocks during your peak hours. Ensure you get adequate deep sleep to fuel your high-energy periods."
        case 9:
            biorythmMeaning = "Your biorhythm number indicates a universally connected nature with cyclical energy patterns."
            dailyImpact = "Your energy follows larger weekly and monthly cycles more than daily ones. You may feel extraordinarily energetic for days, then need deeper rest."
            recommendations = "Track your energy patterns over weeks to identify your unique long-term cycles. Plan major projects and rest periods according to these patterns."
        default:
            break
        }
    }
}

// MARK: - Enums
enum DreamFrequency: String, CaseIterable {
    case never = "Never"
    case rarely = "Rarely"
    case severalTimesAWeek = "Several Times a Week"
    case eachNight = "Each Night"
}

enum NightmareFrequency: String, CaseIterable {
    case eachOne = "Each one"
    case oneIn3To5 = "One in 3-5"
    case oneInDozen = "One in a dozen"
    case none = "None"
}

enum SleepDuration: String, CaseIterable {
    case lessThan5Hours = "< 5 hours"
    case fiveTo7Hours = "5-7 hours"
    case sevenTo9Hours = "7-9 hours"
    case moreThan9Hours = "> 9 hours"
}

struct BiorythmAnalysisFlow_Previews: PreviewProvider {
    static var previews: some View {
        BiorythmAnalysisFlow()
    }
} 