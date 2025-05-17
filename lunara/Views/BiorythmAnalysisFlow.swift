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
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.primary)
                                .frame(width: 32, height: 32)
                                .background(
                                    Circle()
                                        .fill(Color(.systemGray6))
                                )
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
                            .frame(width: 32, height: 32)
                            .padding(.trailing)
                    }
                    .padding(.top)
                    .padding(.bottom, 8)
                    
                    // Progress indicator
                    if !viewModel.isShowingResults && viewModel.currentStep <= 5 {
                        StepProgressBar(currentStep: viewModel.currentStep, totalSteps: 5)
                            .padding(.horizontal)
                            .padding(.bottom, 12)
                    }
                    
                    // Content based on current step
                    Group {
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
                    .padding(.horizontal, 16)
                    
                    Spacer(minLength: 0)
                    
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
        VStack(alignment: .leading, spacing: 16) {
            Image(systemName: "waveform.path.ecg")
                .font(.system(size: 50))
                .foregroundColor(primaryPurple)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 4)
            
            Text("How Biorythm Analysis Works")
                .font(.title3)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("Sleep biorhythms help you understand how your natural cycles affect your daily energy and focus. By using your birth date and analyzing your sleep journal, the app calculates a personalized \"biorhythm number,\" revealing your peak times for productivity, rest, and focus.")
                .font(.subheadline)
                .lineSpacing(2)
                .padding(.bottom, 4)
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
        VStack(alignment: .leading, spacing: 16) {
            Text("Enter Your Birth Date")
                .font(.title3)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("Your birth date is used to calculate your personal biorhythm cycle. This information is stored locally on your device.")
                .font(.subheadline)
                .lineSpacing(2)
                .padding(.bottom, 4)
            
            DatePicker(
                "Birth Date",
                selection: $viewModel.birthDate,
                displayedComponents: .date
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .frame(maxHeight: 320)
            .tint(primaryPurple)
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
        VStack(alignment: .leading, spacing: 12) {
            Text("How often do you see dreams?")
                .font(.title3)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("Dream frequency is a key indicator of your sleep quality and REM cycle patterns.")
                .font(.subheadline)
                .lineSpacing(2)
                .padding(.bottom, 8)
            
            ForEach(BiorythmDreamFrequency.allCases, id: \.self) { frequency in
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
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
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
                .padding(.bottom, 4)
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
    
    // Step 4: Nightmare Frequency View
    private var nightmareFrequencyView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("How many of those are nightmares?")
                .font(.title3)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("Nightmares can be indicators of stress levels and emotional processing during sleep.")
                .font(.subheadline)
                .lineSpacing(2)
                .padding(.bottom, 8)
            
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
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
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
                .padding(.bottom, 4)
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
    
    // Step 5: Sleep Duration View
    private var sleepDurationView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("How long do you usually sleep?")
                .font(.title3)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("Sleep duration directly affects your biorhythm cycles and overall health.")
                .font(.subheadline)
                .lineSpacing(2)
                .padding(.bottom, 8)
            
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
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
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
                .padding(.bottom, 4)
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
        ScrollView {
        VStack(alignment: .leading, spacing: 20) {
                // Number and Title
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
                    .padding(.bottom, 8)
                
                // Dashboard with infographics
                VStack(spacing: 16) {
                    Text("Your Biorhythm Dashboard")
                            .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 4)
                    
                    // Energy levels throughout the day
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Daily Energy Flow")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        ZStack(alignment: .bottom) {
                            // Background grid
                            VStack(spacing: 0) {
                                ForEach(0..<4) { i in
                                    Divider()
                                        .background(Color.gray.opacity(0.3))
                                        .frame(height: 1)
                                    if i < 3 {
                                        Spacer()
                                            .frame(height: 30)
                                    }
                                }
                            }
                            .frame(height: 110)
                            
                            // Energy line chart
                            GeometryReader { geometry in
                                let width = geometry.size.width
                                let pointSpacing = width / 24
                                let bioNumber = Int(viewModel.biorythmNumber) ?? 7
                                
                                // Path for the energy line
                                Path { path in
                                    // Start at the first point
                                    let startHeight = getEnergyHeight(for: 0, biorhythmNumber: bioNumber)
                                    let startY = 110 - startHeight
                                    path.move(to: CGPoint(x: 0, y: startY))
                                    
                                    // Add points for each hour
                                    for hour in 1..<24 {
                                        let height = getEnergyHeight(for: hour, biorhythmNumber: bioNumber)
                                        let x = CGFloat(hour) * pointSpacing
                                        let y = 110 - height
                                        
                                        // Use a curve for smoother transitions
                                        let prevHeight = getEnergyHeight(for: hour-1, biorhythmNumber: bioNumber)
                                        let prevY = 110 - prevHeight
                                        let prevX = CGFloat(hour-1) * pointSpacing
                                        
                                        let controlPoint1 = CGPoint(x: prevX + (pointSpacing * 0.5), y: prevY)
                                        let controlPoint2 = CGPoint(x: x - (pointSpacing * 0.5), y: y)
                                        
                                        path.addCurve(to: CGPoint(x: x, y: y),
                                                     control1: controlPoint1,
                                                     control2: controlPoint2)
                                    }
                                }
                                .trim(from: 0, to: 1)
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [primaryPurple.opacity(0.7), primaryPurple]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ),
                                    style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
                                )
                                .shadow(color: primaryPurple.opacity(0.3), radius: 3, x: 0, y: 2)
                                .animation(.easeInOut(duration: 1.5), value: bioNumber)
                                
                                // Peak indicators
                                ForEach(0..<24, id: \.self) { hour in
                                    if isPeakHour(hour: hour, biorhythmNumber: bioNumber) {
                                        let height = getEnergyHeight(for: hour, biorhythmNumber: bioNumber)
                                        let x = CGFloat(hour) * pointSpacing
                                        let y = 110 - height
                                        
                                        Circle()
                                            .fill(Color.yellow)
                                            .frame(width: 8, height: 8)
                                            .position(x: x, y: y)
                                            .shadow(color: Color.yellow.opacity(0.6), radius: 2, x: 0, y: 0)
                                        
                                        Image(systemName: "star.fill")
                                            .font(.system(size: 8))
                                            .foregroundColor(.yellow)
                                            .position(x: x, y: y - 15)
                                    }
                                }
                                
                                // Time markers at bottom - add only a few to avoid clutter
                                ForEach([0, 6, 12, 18, 23], id: \.self) { hour in
                                    let x = CGFloat(hour) * pointSpacing
                                    
                                    Text(formatHour(hour))
                                        .font(.system(size: 8))
                                        .foregroundColor(.secondary)
                                        .position(x: x, y: 125)
                                }
                            }
                            .frame(height: 140)
                        }
                        .padding(.trailing, 8)
                        .padding(.bottom, 8)
                        
                        // Legend
                        HStack(spacing: 12) {
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 10))
                                    .foregroundColor(.yellow)
                                
                                Text("Peak Energy")
                                    .font(.system(size: 10))
                                    .foregroundColor(.secondary)
                            }
                            
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(primaryPurple)
                                    .frame(width: 8, height: 8)
                                
                                Text("Energy Flow")
                                    .font(.system(size: 10))
                                    .foregroundColor(.secondary)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    // Key stats in a grid
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                        StatCard(
                            title: "Sleep Efficiency",
                            value: getSleepEfficiency(),
                            icon: "bed.double.fill"
                        )
                        
                        StatCard(
                            title: "Dream Recall",
                            value: getDreamRecall(),
                            icon: "cloud.moon.fill"
                        )
                        
                        StatCard(
                            title: "Optimal Sleep",
                            value: getOptimalSleep(),
                            icon: "clock.fill"
                        )
                        
                        StatCard(
                            title: "Peak Hours",
                            value: getPeakHours(),
                            icon: "bolt.fill"
                        )
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(colorScheme == .dark ? Color(.systemGray6).opacity(0.8) : Color(.systemGray6).opacity(0.3))
                )
                
                // Detailed Analysis Sections
                VStack(alignment: .leading, spacing: 24) {
                    // Core Meaning
                    AnalysisSection(
                        icon: "questionmark.circle.fill",
                        title: "What does this mean?",
                        content: viewModel.biorythmMeaning
                    )
                    
                    // Daily Impact
                    AnalysisSection(
                        icon: "calendar.circle.fill",
                        title: "Daily Impact",
                        content: viewModel.dailyImpact
                    )
                    
                    // Dream Insights
                    AnalysisSection(
                        icon: "moon.stars.fill",
                        title: "Dream Insights",
                        content: viewModel.dreamInsights
                    )
                    
                    // Sleep Cycle Analysis
                    AnalysisSection(
                        icon: "waveform.path.ecg.rectangle.fill",
                        title: "Sleep Cycle Analysis",
                        content: viewModel.sleepCycleAnalysis
                    )
                    
                    // Monthly Patterns
                    AnalysisSection(
                        icon: "chart.bar.fill",
                        title: "Monthly Patterns",
                        content: viewModel.monthlyPatterns
                    )
                    
                    // Energy Peaks
                    AnalysisSection(
                        icon: "bolt.circle.fill",
                        title: "Energy Peaks",
                        content: viewModel.energyPeaks
                    )
                    
                    // Rest Needs
                    AnalysisSection(
                        icon: "bed.double.circle.fill",
                        title: "Rest Requirements",
                        content: viewModel.restNeeds
                    )
                    
                    // Recommendations
                    AnalysisSection(
                        icon: "lightbulb.circle.fill",
                        title: "Recommendations",
                        content: viewModel.recommendations
                    )
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
        }
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
    
    // Helper view for stat cards in dashboard
    private struct StatCard: View {
        let title: String
        let value: String
        let icon: String
        
        private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
        
        var body: some View {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(primaryPurple)
                
                Text(value)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(height: 85)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
            )
        }
    }
    
    // Helper functions for dashboard
    private func getEnergyHeight(for hour: Int, biorhythmNumber: Int) -> CGFloat {
        // Different energy patterns based on biorhythm number
        switch biorhythmNumber {
        case 1: // Night owl
            let pattern: [CGFloat] = [20, 15, 10, 10, 15, 25, 35, 45, 55, 65, 55, 45, 40, 35, 30, 35, 45, 55, 65, 75, 90, 95, 80, 40]
            return pattern[hour]
        case 2: // Intuitive
            let pattern: [CGFloat] = [25, 20, 15, 10, 15, 35, 75, 85, 80, 70, 60, 50, 40, 45, 55, 65, 80, 90, 85, 75, 60, 45, 35, 30]
            return pattern[hour]
        case 3: // Creative waves
            let pattern: [CGFloat] = [30, 25, 20, 15, 20, 30, 45, 60, 80, 95, 85, 65, 75, 85, 70, 55, 65, 80, 90, 75, 60, 50, 40, 35]
            return pattern[hour]
        case 4: // Structured
            let pattern: [CGFloat] = [30, 25, 20, 15, 25, 45, 75, 95, 90, 85, 75, 65, 55, 45, 40, 35, 30, 25, 30, 35, 40, 45, 40, 35]
            return pattern[hour]
        case 5: // Adaptable
            let pattern: [CGFloat] = [40, 30, 25, 20, 30, 50, 75, 90, 70, 60, 80, 65, 50, 70, 85, 65, 45, 60, 80, 65, 50, 40, 35, 30]
            return pattern[hour]
        case 6: // Balanced
            let pattern: [CGFloat] = [40, 35, 30, 25, 35, 50, 65, 80, 85, 80, 75, 70, 65, 60, 65, 70, 75, 80, 75, 70, 65, 55, 45, 40]
            return pattern[hour]
        case 7: // Contemplative
            let pattern: [CGFloat] = [35, 30, 25, 20, 30, 45, 75, 90, 95, 85, 70, 50, 40, 35, 45, 60, 75, 85, 95, 90, 80, 65, 50, 40]
            return pattern[hour]
        case 8: // Powerful
            let pattern: [CGFloat] = [45, 40, 35, 30, 40, 55, 85, 95, 90, 85, 80, 75, 65, 55, 50, 60, 70, 80, 85, 75, 65, 55, 50, 45]
            return pattern[hour]
        case 9: // Universal
            let pattern: [CGFloat] = [60, 50, 40, 35, 45, 70, 95, 90, 75, 65, 60, 70, 80, 75, 60, 50, 65, 80, 95, 85, 70, 60, 55, 50]
            return pattern[hour]
        default:
            return 50
        }
    }
    
    private func getEnergyColor(height: CGFloat) -> Color {
        let hue = 0.7 - (height / 150) // Purple to blue gradient based on height
        return Color(hue: hue, saturation: 0.7, brightness: 0.9)
    }
    
    // Helper function to format hour labels (12-hour format with AM/PM)
    private func formatHour(_ hour: Int) -> String {
        let h = hour % 12 == 0 ? 12 : hour % 12
        return "\(h)\(hour < 12 ? "a" : "p")"
    }
    
    // Helper function to determine if an hour is a peak energy hour
    private func isPeakHour(hour: Int, biorhythmNumber: Int) -> Bool {
        switch biorhythmNumber {
        case 1: return hour == 21 || hour == 22 // 9PM-10PM
        case 2: return hour == 8 || hour == 19 // 8AM, 7PM
        case 3: return hour == 10 || hour == 17 // 10AM, 5PM
        case 4: return hour == 8 || hour == 9 // 8AM-9AM
        case 5: return hour == 7 || hour == 14 // 7AM, 2PM
        case 6: return hour == 10 || hour == 17 // 10AM, 5PM
        case 7: return hour == 8 || hour == 18 // 8AM, 6PM
        case 8: return hour == 9 || hour == 10 // 9AM-10AM
        case 9: return hour == 6 || hour == 18 // 6AM, 6PM (dawn/dusk)
        default: return hour == 9 || hour == 17 // 9AM, 5PM
        }
    }
    
    private func getSleepEfficiency() -> String {
        let bioNumber = Int(viewModel.biorythmNumber) ?? 7
        
        switch bioNumber {
        case 1: return "82%"
        case 2: return "78%"
        case 3: return "84%"
        case 4: return "91%"
        case 5: return "77%"
        case 6: return "89%"
        case 7: return "87%"
        case 8: return "93%"
        case 9: return "85%"
        default: return "85%"
        }
    }
    
    private func getDreamRecall() -> String {
        let bioNumber = Int(viewModel.biorythmNumber) ?? 7
        
        switch bioNumber {
        case 1: return "Medium"
        case 2: return "Very High"
        case 3: return "High"
        case 4: return "Medium"
        case 5: return "Variable"
        case 6: return "Consistent"
        case 7: return "Deep"
        case 8: return "Vivid"
        case 9: return "Prophetic"
        default: return "Medium"
        }
    }
    
    private func getOptimalSleep() -> String {
        let bioNumber = Int(viewModel.biorythmNumber) ?? 7
        
        switch bioNumber {
        case 1: return "6-7 hrs"
        case 2: return "7-8 hrs"
        case 3: return "6-8 hrs"
        case 4: return "7.5 hrs"
        case 5: return "6-8 hrs"
        case 6: return "8 hrs"
        case 7: return "7-9 hrs"
        case 8: return "6-7 hrs"
        case 9: return "6-10 hrs"
        default: return "7-8 hrs"
        }
    }
    
    private func getPeakHours() -> String {
        let bioNumber = Int(viewModel.biorythmNumber) ?? 7
        
        switch bioNumber {
        case 1: return "10PM-2AM"
        case 2: return "9AM, 7PM"
        case 3: return "11AM, 5PM"
        case 4: return "7AM-10AM"
        case 5: return "Variable"
        case 6: return "10AM, 5PM"
        case 7: return "8AM, 6PM"
        case 8: return "8AM-11AM"
        case 9: return "Dawn/Dusk"
        default: return "9AM, 5PM"
        }
    }
    
    // Helper view for analysis sections
    private struct AnalysisSection: View {
        let icon: String
        let title: String
        let content: String
        
        private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
        private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(primaryPurple)
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                
                Text(content)
                    .font(.body)
                    .lineSpacing(4)
                
                Divider()
                    .background(lightPurple)
                    .padding(.top, 8)
            }
        }
    }
}

// MARK: - Progress Bar
struct StepProgressBar: View {
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
    @Published var dreamFrequency: BiorythmDreamFrequency?
    @Published var nightmareFrequency: NightmareFrequency?
    @Published var sleepDuration: SleepDuration?
    
    @Published var isShowingResults = false
    @Published var biorythmNumber = "7"
    @Published var biorythmMeaning = ""
    @Published var dailyImpact = ""
    @Published var recommendations = ""
    @Published var dreamInsights = ""
    @Published var sleepCycleAnalysis = ""
    @Published var monthlyPatterns = ""
    @Published var energyPeaks = ""
    @Published var restNeeds = ""
    
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
        // Calculate base number as before
        let daysSinceBirth = Calendar.current.dateComponents([.day], from: birthDate, to: Date()).day ?? 0
        var baseNumber = (daysSinceBirth % 9) + 1
        
        // Apply adjustments with renamed enum
        if dreamFrequency == .never {
            baseNumber = max(1, baseNumber - 2)
        } else if dreamFrequency == .eachNight {
            baseNumber = min(9, baseNumber + 2)
        }
        
        if nightmareFrequency == .eachOne {
            baseNumber = max(1, baseNumber - 1)
        } else if nightmareFrequency == NightmareFrequency.none {
            baseNumber = min(9, baseNumber + 1)
        }
        
        if sleepDuration == .lessThan5Hours {
            baseNumber = max(1, baseNumber - 1)
        } else if sleepDuration == .moreThan9Hours {
            baseNumber = min(9, baseNumber + 1)
        }
        
        biorythmNumber = String(baseNumber)
        
        // Enhanced analysis based on the number
        switch baseNumber {
        case 1:
            biorythmMeaning = "Your biorhythm number reveals a highly analytical and independent mind with a unique sleep-wake pattern that sets you apart from traditional rhythms."
            
            dailyImpact = """
            Your natural energy flow peaks during unconventional hours, typically between 10 PM and 2 AM. This night owl tendency is linked to heightened analytical abilities and creative problem-solving during quiet hours.
            
            You experience mini-energy surges throughout the day, with your strongest mental clarity occurring in 90-minute cycles, especially during evening hours.
            """
            
            dreamInsights = """
            Your dreams tend to be more analytical and solution-focused, often processing complex problems or creative challenges. The relatively lower dream recall frequency suggests your mind processes information differently, favoring logical analysis over emotional processing during sleep.
            """
            
            sleepCycleAnalysis = """
            Your sleep architecture shows:
            • Longer initial sleep latency (time to fall asleep)
            • Extended REM periods in later sleep cycles
            • Shorter overall sleep need (5.5-7 hours optimal)
            • Higher quality deep sleep phases
            """
            
            monthlyPatterns = """
            Your monthly biorhythm indicates:
            • Peak mental clarity: Days 1-7 of your cycle
            • Highest creativity: Days 15-21
            • Best problem-solving: Days 22-28
            • Recovery needs: Days 8-14
            """
            
            energyPeaks = """
            Optimal times for different activities:
            • Complex problem-solving: 10 PM - 1 AM
            • Creative work: 8 PM - 10 PM
            • Physical exercise: 4 PM - 6 PM
            • Social interaction: 2 PM - 4 PM
            """
            
            restNeeds = """
            Your unique rest pattern requires:
            • 20-minute power naps between 2-3 PM
            • 5-10 minute meditation breaks every 2 hours
            • Longer wind-down period before sleep (1-1.5 hours)
            • Dark, quiet environment for optimal sleep initiation
            """
            
            recommendations = """
            Optimize your natural rhythm by:
            1. Creating a dedicated night workspace for peak productivity hours
            2. Using blue light blocking glasses after sunset
            3. Scheduling important meetings for late afternoon
            4. Taking advantage of quiet night hours for deep work
            5. Using a biphasic sleep schedule with a longer evening rest and shorter afternoon nap
            6. Maintaining a consistent sleep schedule even on weekends
            7. Practicing mindfulness during energy transitions
            """
            
        case 2:
            biorythmMeaning = "Your biorhythm number indicates a highly intuitive and emotionally attuned individual with sensitive sleep patterns influenced by environmental and emotional factors."
            
            dailyImpact = """
            Your energy patterns are closely tied to emotional and environmental cues, with natural peaks during transition periods (dawn and dusk). You're most balanced during the mid-morning hours and early evening, with heightened sensitivity to others' energies throughout the day.
            
            Your emotional state significantly influences your energy levels, making emotional regulation crucial for maintaining steady energy flow.
            """
            
            dreamInsights = """
            Your dreams are typically vivid and emotionally charged, serving as important processing tools for daily experiences. You have a higher than average recall rate and often experience precognitive or intuitive dreams that provide valuable insights.
            """
            
            sleepCycleAnalysis = """
            Your sleep architecture shows:
            • Shorter sleep cycles (80-85 minutes vs. typical 90)
            • More frequent REM periods
            • Sensitive to sleep environment changes
            • Strong connection between emotional state and sleep quality
            """
            
            monthlyPatterns = """
            Your monthly biorhythm indicates:
            • Highest intuition: Days 1-8
            • Emotional processing: Days 9-16
            • Social connectivity: Days 17-24
            • Introspection needs: Days 25-30
            """
            
            energyPeaks = """
            Optimal times for different activities:
            • Emotional work: 7 AM - 9 AM
            • Creative projects: 10 AM - 12 PM
            • Social interaction: 3 PM - 5 PM
            • Spiritual practices: 6 PM - 8 PM
            """
            
            restNeeds = """
            Your sensitive system requires:
            • Regular emotional processing breaks
            • Quiet time before sleep (1.5-2 hours)
            • Consistent sleep environment
            • Nature exposure during the day
            """
            
            recommendations = """
            Harmonize with your natural rhythm by:
            1. Creating a calming morning routine with meditation or journaling
            2. Using aromatherapy to signal sleep and wake times
            3. Maintaining an emotion-processing journal
            4. Taking regular nature breaks during the day
            5. Practicing energy clearing techniques before bed
            6. Limiting exposure to others' emotional energy in the evening
            7. Using sound therapy for sleep enhancement
            8. Creating environmental cues for different activities
            """
            
        case 3:
            biorythmMeaning = "Your biorhythm number reveals a creative and expressive nature with dynamic energy patterns that flow in artistic waves throughout the day."
            
            dailyImpact = """
            Rather than a single daily peak, you experience multiple creative surges throughout the day. Your energy moves in artistic waves, with particularly strong creative potential during the late morning and early evening hours.
            
            Your rhythm is characterized by intense periods of inspiration followed by necessary integration periods.
            """
            
            dreamInsights = """
            Your dreams are highly symbolic and often contain creative solutions or artistic inspiration. You frequently experience lucid dreams and have the ability to consciously interact with dream content, making your sleep time valuable for creative problem-solving.
            """
            
            sleepCycleAnalysis = """
            Your sleep architecture shows:
            • Extended REM periods rich in creative content
            • Variable sleep onset based on creative energy
            • Strong dream recall ability
            • Multiple wake-sleep cycles optimal for creativity
            """
            
            monthlyPatterns = """
            Your monthly biorhythm indicates:
            • Peak creativity: Days 1-7
            • Technical skill peaks: Days 8-14
            • Collaborative energy: Days 15-21
            • Reflective period: Days 22-30
            """
            
            energyPeaks = """
            Optimal times for different activities:
            • Artistic work: 10 AM - 12 PM
            • Technical tasks: 2 PM - 4 PM
            • Creative collaboration: 4 PM - 6 PM
            • Inspiration gathering: 7 PM - 9 PM
            """
            
            restNeeds = """
            Your creative rhythm requires:
            • Inspiration breaks throughout the day
            • Creative visualization before sleep
            • Art-integrated rest periods
            • Movement-based energy renewal
            """
            
            recommendations = """
            Enhance your creative rhythm by:
            1. Starting each day with creative visualization
            2. Taking artistic breaks between focused work periods
            3. Using color therapy in your environment
            4. Incorporating movement in your creative process
            5. Maintaining a dream inspiration journal
            6. Creating dedicated spaces for different types of creative work
            7. Balancing structured and unstructured creative time
            8. Using music to enhance your natural rhythms
            """
            
        case 4:
            biorythmMeaning = "Your biorhythm number indicates a highly structured and disciplined nature with a strong preference for routine and methodical energy management."
            
            dailyImpact = """
            Your energy follows a precise daily pattern with peak performance in the early morning hours. You experience a steady, predictable decline throughout the day, making morning hours crucial for important tasks.
            
            Your rhythm thrives on structure and becomes disrupted when regular patterns are broken.
            """
            
            dreamInsights = """
            Your dreams often reflect organizational themes and tend to be more linear and structured than most. They frequently contain practical solutions to daily challenges and are best recalled when you maintain a consistent sleep schedule.
            """
            
            sleepCycleAnalysis = """
            Your sleep architecture shows:
            • Precise 90-minute sleep cycles
            • Strong slow-wave sleep in early cycles
            • Consistent sleep onset when routine is maintained
            • Optimal 7.5-hour total sleep duration
            """
            
            monthlyPatterns = """
            Your monthly biorhythm indicates:
            • Planning efficiency: Days 1-8
            • Implementation peak: Days 9-16
            • System optimization: Days 17-24
            • Review and adjust: Days 25-30
            """
            
            energyPeaks = """
            Optimal times for different activities:
            • Strategic planning: 5 AM - 7 AM
            • Complex tasks: 7 AM - 10 AM
            • Routine work: 11 AM - 2 PM
            • Organization: 3 PM - 5 PM
            """
            
            restNeeds = """
            Your structured nature requires:
            • Consistent bedtime routine
            • Organized sleep environment
            • Regular recovery periods
            • Systematic wind-down process
            """
            
            recommendations = """
            Optimize your structured rhythm by:
            1. Creating a detailed daily schedule
            2. Setting up environmental cues for different activities
            3. Using time-blocking techniques
            4. Maintaining consistent meal times
            5. Implementing a precise evening routine
            6. Tracking sleep metrics
            7. Adjusting light exposure throughout the day
            8. Creating backup plans for routine disruptions
            """
            
        case 5:
            biorythmMeaning = "Your biorhythm number reveals an adaptable and dynamic nature with variable energy patterns that require flexible management strategies."
            
            dailyImpact = """
            Your energy fluctuates more than most, with multiple mini-peaks throughout the day. This makes you highly adaptable but requires careful attention to energy management.
            
            You excel at quick transitions and can readily adjust to changing circumstances, though this flexibility comes with a need for intentional stability practices.
            """
            
            dreamInsights = """
            Your dreams are characterized by variety and often contain multiple scenarios or parallel storylines. Dream content frequently shifts between different themes, reflecting your adaptable nature and providing insights into managing change.
            """
            
            sleepCycleAnalysis = """
            Your sleep architecture shows:
            • Variable sleep cycle lengths
            • Adaptive REM patterns
            • Quick sleep stage transitions
            • Flexible total sleep needs (6-8 hours)
            """
            
            monthlyPatterns = """
            Your monthly biorhythm indicates:
            • Adaptation phase: Days 1-7
            • Innovation peak: Days 8-15
            • Integration period: Days 16-23
            • Reset and prepare: Days 24-30
            """
            
            energyPeaks = """
            Optimal times for different activities:
            • Dynamic tasks: 8 AM - 10 AM
            • Creative work: 11 AM - 1 PM
            • Physical activity: 3 PM - 5 PM
            • Learning: 6 PM - 8 PM
            """
            
            restNeeds = """
            Your adaptable system requires:
            • Flexible rest periods
            • Multiple short breaks
            • Variable recovery activities
            • Adaptive sleep schedule
            """
            
            recommendations = """
            Enhance your adaptive rhythm by:
            1. Creating flexible routines that can adapt to energy levels
            2. Using energy tracking tools to identify patterns
            3. Implementing dynamic work environments
            4. Practicing adaptable meditation techniques
            5. Maintaining a variety of sleep preparation methods
            6. Developing multiple energy management strategies
            7. Creating environmental flexibility
            8. Building in regular pattern reassessment
            """
            
        case 6:
            biorythmMeaning = "Your biorhythm number indicates a harmonious and balanced nature with steady energy cycles that promote consistent performance and well-being."
            
            dailyImpact = """
            Your energy maintains a remarkably steady flow throughout the day, with only a mild afternoon dip. This balanced pattern allows for sustained productivity and emotional stability.
            
            You naturally gravitate toward harmony in all aspects of life, including sleep-wake patterns.
            """
            
            dreamInsights = """
            Your dreams often reflect themes of balance and integration, with a good mix of emotional and practical content. Dream recall is consistent and dreams frequently provide insights into maintaining life harmony.
            """
            
            sleepCycleAnalysis = """
            Your sleep architecture shows:
            • Well-balanced sleep stages
            • Consistent 90-minute cycles
            • Smooth stage transitions
            • Optimal 8-hour sleep duration
            """
            
            monthlyPatterns = """
            Your monthly biorhythm indicates:
            • Harmony building: Days 1-7
            • Integration: Days 8-15
            • Balance adjustment: Days 16-23
            • Reflection and renewal: Days 24-30
            """
            
            energyPeaks = """
            Optimal times for different activities:
            • Mental tasks: 9 AM - 11 AM
            • Physical activities: 2 PM - 4 PM
            • Creative work: 4 PM - 6 PM
            • Social interaction: 6 PM - 8 PM
            """
            
            restNeeds = """
            Your balanced system requires:
            • Regular rest intervals
            • Balanced activity types
            • Consistent sleep timing
            • Harmonious environment
            """
            
            recommendations = """
            Maintain your harmonious rhythm by:
            1. Creating balanced daily schedules
            2. Alternating between different types of activities
            3. Implementing regular transition periods
            4. Maintaining consistent sleep-wake times
            5. Practicing balanced nutrition timing
            6. Using harmony-promoting environmental elements
            7. Incorporating both active and passive rest
            8. Developing mindful transition practices
            """
            
        case 7:
            biorythmMeaning = "Your biorhythm number reveals a deeply contemplative nature with intuitive cycles that favor periods of intense focus followed by reflective recovery."
            
            dailyImpact = """
            Your energy pattern shows distinct peaks and valleys, with strong morning potential, a significant afternoon dip, and a powerful evening revival. This creates natural periods for different types of mental and spiritual work.
            
            Your rhythm is particularly attuned to subtle environmental and cosmic influences.
            """
            
            dreamInsights = """
            Your dreams are often profound and multilayered, featuring strong symbolic content and spiritual themes. Dream recall is enhanced during certain lunar phases, and dreams frequently provide guidance for life decisions.
            """
            
            sleepCycleAnalysis = """
            Your sleep architecture shows:
            • Extended deep sleep periods
            • Cyclical REM patterns
            • Sensitivity to lunar cycles
            • Optimal sleep duration varies (7-9 hours)
            """
            
            monthlyPatterns = """
            Your monthly biorhythm indicates:
            • Intuitive peak: Days 1-7
            • Deep processing: Days 8-14
            • Integration: Days 15-21
            • Spiritual connection: Days 22-30
            """
            
            energyPeaks = """
            Optimal times for different activities:
            • Meditation: 5 AM - 7 AM
            • Analytical work: 9 AM - 12 PM
            • Creative insight: 4 PM - 6 PM
            • Spiritual practice: 8 PM - 10 PM
            """
            
            restNeeds = """
            Your contemplative nature requires:
            • Regular meditation periods
            • Solitary reflection time
            • Nature connection breaks
            • Quiet sleep environment
            """
            
            recommendations = """
            Enhance your intuitive rhythm by:
            1. Starting each day with meditation or contemplation
            2. Creating sacred spaces for different activities
            3. Aligning activities with natural cycles
            4. Maintaining a dream and insight journal
            5. Practicing regular energy clearing
            6. Implementing mindful transitions
            7. Using sound therapy for state changes
            8. Developing personalized spiritual practices
            """
            
        case 8:
            biorythmMeaning = "Your biorhythm number indicates a powerful and ambitious nature with intense energy cycles that support extended periods of high performance."
            
            dailyImpact = """
            Your energy pattern is characterized by sustained high-intensity periods followed by necessary deep recovery phases. This creates natural cycles of powerful productivity and essential restoration.
            
            You have the capacity for exceptional endurance when properly managing your energy cycles.
            """
            
            dreamInsights = """
            Your dreams often contain themes of achievement and mastery, with strong actionable content. Dream experiences tend to be vivid and energetic, often providing strategic insights for your ambitious pursuits.
            """
            
            sleepCycleAnalysis = """
            Your sleep architecture shows:
            • Intense deep sleep phases
            • Efficient sleep cycles
            • Rapid recovery ability
            • Need for quality over quantity
            """
            
            monthlyPatterns = """
            Your monthly biorhythm indicates:
            • Power phase: Days 1-8
            • Strategic planning: Days 9-16
            • Implementation: Days 17-24
            • Recovery and integration: Days 25-30
            """
            
            energyPeaks = """
            Optimal times for different activities:
            • High-intensity work: 7 AM - 11 AM
            • Strategic planning: 2 PM - 4 PM
            • Physical training: 4 PM - 6 PM
            • Recovery: 8 PM - 10 PM
            """
            
            restNeeds = """
            Your powerful system requires:
            • Strategic recovery periods
            • High-quality sleep environment
            • Intense but brief rest phases
            • Active recovery techniques
            """
            
            recommendations = """
            Optimize your powerful rhythm by:
            1. Implementing strategic work-rest ratios
            2. Using high-intensity interval principles in daily planning
            3. Creating optimal recovery environments
            4. Maintaining energy tracking systems
            5. Practicing power meditation techniques
            6. Developing personal performance rituals
            7. Using advanced sleep optimization
            8. Building in strategic deload periods
            """
            
        case 9:
            biorythmMeaning = "Your biorhythm number reveals a universally connected nature with cyclical energy patterns that align with larger natural and cosmic rhythms."
            
            dailyImpact = """
            Your energy patterns operate on multiple time scales, from daily to monthly and seasonal cycles. You experience extended periods of extraordinary energy followed by necessary deep restoration phases.
            
            Your rhythm is particularly sensitive to natural cycles and environmental influences.
            """
            
            dreamInsights = """
            Your dreams often contain universal themes and connect to collective consciousness. Dream experiences can be prophetic or provide insights into larger patterns and cycles affecting your life and others.
            """
            
            sleepCycleAnalysis = """
            Your sleep architecture shows:
            • Complex multilayered cycles
            • Strong seasonal variations
            • Cosmic rhythm sensitivity
            • Variable sleep needs (6-10 hours)
            """
            
            monthlyPatterns = """
            Your monthly biorhythm indicates:
            • Universal connection: Days 1-9
            • Personal integration: Days 10-18
            • Collective work: Days 19-27
            • Spiritual alignment: Days 28-30
            """
            
            energyPeaks = """
            Optimal times for different activities:
            • Spiritual practice: Dawn and Dusk
            • Creative work: 10 AM - 2 PM
            • Healing work: 2 PM - 6 PM
            • Meditation: 8 PM - 10 PM
            """
            
            restNeeds = """
            Your cyclical nature requires:
            • Alignment with natural rhythms
            • Regular nature connection
            • Seasonal adjustment periods
            • Sacred rest practices
            """
            
            recommendations = """
            Enhance your universal rhythm by:
            1. Aligning daily activities with natural cycles
            2. Creating seasonal routine adjustments
            3. Developing cosmic awareness practices
            4. Maintaining connection with nature
            5. Implementing cyclic planning methods
            6. Using energy alignment techniques
            7. Practicing universal meditation
            8. Building in regular pattern recognition
            """
            
        default:
            break
        }
    }
}

// MARK: - Enums
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

enum BiorythmDreamFrequency: String, CaseIterable {
    case never = "Never"
    case rarely = "Rarely"
    case severalTimesAWeek = "Several Times a Week"
    case eachNight = "Each Night"
}

struct BiorythmAnalysisFlow_Previews: PreviewProvider {
    static var previews: some View {
        BiorythmAnalysisFlow()
    }
} 