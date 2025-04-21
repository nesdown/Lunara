import SwiftUI
import Models
import AVFoundation

enum DreamEntryStep: Int {
    case description
    case wakeUp
    case emotions
    case intensity
    case interpretation
    case results
    case subscription
}

struct DreamEntryFlow: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = DreamInterpretationViewModel()
    @StateObject private var subscriptionService = SubscriptionService.shared
    @State private var currentStep: DreamEntryStep = .description
    @State private var previousStep: DreamEntryStep?
    @State private var isAnimating = false
    
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    
    var body: some View {
        NavigationView {
            VStack {
                // Animate the content based on the step transition direction
                ZStack {
                    currentStepView
                        .transition(getTransition())
                        .animation(AppAnimation.gentleSpring, value: currentStep)
                        .animation(AppAnimation.gentleSpring, value: previousStep)
                }
                .animation(AppAnimation.gentleSpring, value: currentStep)
            }
            .padding(.horizontal, 20)
            .navigationBarTitle(navigationTitle, displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: { 
                    // Add haptic feedback and animation for back button
                    HapticManager.shared.light()
                    withAnimation {
                        dismiss() 
                    }
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                        .frame(width: 32, height: 32)
                        .background(
                            Circle()
                                .fill(Color(.systemGray6))
                        )
                },
                trailing: currentStep == .results || currentStep == .subscription ? nil : skipButton
            )
            .background(Color(.systemBackground))
        }
    }
    
    @ViewBuilder
    private var currentStepView: some View {
        switch currentStep {
        case .description:
            DreamDescriptionView(
                dreamDescription: $viewModel.description,
                onNext: { navigateToNextStep(.wakeUp) }
            )
            
        case .wakeUp:
            DreamWakeUpView(
                didWakeUp: $viewModel.didWakeUp,
                onNext: { navigateToNextStep(.emotions) },
                onSkip: { navigateToNextStep(.emotions) }
            )
            
        case .emotions:
            DreamEmotionsView(
                hadNegativeEmotions: $viewModel.hadNegativeEmotions,
                onNext: { navigateToNextStep(.intensity) },
                onSkip: { navigateToNextStep(.intensity) }
            )
            
        case .intensity:
            DreamIntensityView(
                intensityLevel: Binding(
                    get: { Double(viewModel.intensityLevel) },
                    set: { viewModel.intensityLevel = Int($0) }
                ),
                onNext: {
                    // Check if user can interpret dream before proceeding
                    if subscriptionService.canInterpretDream() {
                        navigateToNextStep(.interpretation)
                        subscriptionService.incrementInterpretationAttempts()
                        Task {
                            await viewModel.interpretDream(
                                description: viewModel.description,
                                didWakeUp: viewModel.didWakeUp,
                                hadNegativeEmotions: viewModel.hadNegativeEmotions,
                                intensityLevel: viewModel.intensityLevel
                            )
                            // Delay the navigation to results to show loading animation
                            try? await Task.sleep(nanoseconds: 500_000_000)
                            withAnimation(AppAnimation.gentleSpring) {
                                currentStep = .results
                            }
                        }
                    } else {
                        // User has used up free attempts, show subscription
                        navigateToNextStep(.subscription)
                    }
                },
                onSkip: {
                    // Check if user can interpret dream before proceeding
                    if subscriptionService.canInterpretDream() {
                        navigateToNextStep(.interpretation)
                        subscriptionService.incrementInterpretationAttempts()
                        Task {
                            await viewModel.interpretDream(
                                description: viewModel.description,
                                didWakeUp: viewModel.didWakeUp,
                                hadNegativeEmotions: viewModel.hadNegativeEmotions,
                                intensityLevel: viewModel.intensityLevel
                            )
                            // Delay the navigation to results to show loading animation
                            try? await Task.sleep(nanoseconds: 500_000_000)
                            withAnimation(AppAnimation.gentleSpring) {
                                currentStep = .results
                            }
                        }
                    } else {
                        // User has used up free attempts, show subscription
                        navigateToNextStep(.subscription)
                    }
                }
            )
            
        case .interpretation:
            DreamLoadingView()
                .transition(.opacity)
            
        case .results:
            if let error = viewModel.error {
                VStack {
                    Text("Something went wrong")
                        .font(.title)
                        .padding()
                        .appearanceAnimation()
                    
                    Text(error.localizedDescription)
                        .multilineTextAlignment(.center)
                        .padding()
                        .appearanceAnimation(delay: 0.1)
                    
                    Button("Try Again") {
                        // No need to check subscription here as we've already 
                        // used an attempt and are just retrying due to an error
                        navigateToNextStep(.interpretation)
                        Task {
                            await viewModel.interpretDream(
                                description: viewModel.description,
                                didWakeUp: viewModel.didWakeUp,
                                hadNegativeEmotions: viewModel.hadNegativeEmotions,
                                intensityLevel: viewModel.intensityLevel
                            )
                            withAnimation(AppAnimation.gentleSpring) {
                                currentStep = .results
                            }
                        }
                    }
                    .padding()
                    .appearanceAnimation(delay: 0.2)
                }
            } else {
                DreamInterpretationView(viewModel: viewModel)
                    .transition(.opacity)
            }
            
        case .subscription:
            SubscriptionView()
                .transition(.opacity)
        }
    }
    
    // Helper function to navigate between steps with proper animation
    private func navigateToNextStep(_ nextStep: DreamEntryStep) {
        HapticManager.shared.light()
        previousStep = currentStep
        
        withAnimation(AppAnimation.gentleSpring) {
            currentStep = nextStep
        }
    }
    
    // Determine the appropriate transition based on navigation direction
    private func getTransition() -> AnyTransition {
        guard let previousStep = previousStep else {
            return .opacity
        }
        
        if previousStep.rawValue < currentStep.rawValue {
            return .asymmetric(
                insertion: .opacity.combined(with: .move(edge: .trailing)),
                removal: .opacity.combined(with: .move(edge: .leading))
            )
        } else {
            return .asymmetric(
                insertion: .opacity.combined(with: .move(edge: .leading)),
                removal: .opacity.combined(with: .move(edge: .trailing))
            )
        }
    }
    
    private var navigationTitle: String {
        switch currentStep {
        case .description:
            return "New Dream"
        case .wakeUp:
            return "Dream Details"
        case .emotions:
            return "Dream Emotions"
        case .intensity:
            return "Dream Intensity"
        case .interpretation:
            return "Interpreting Dream"
        case .results:
            return "Dream Interpretation"
        case .subscription:
            return "Unlock Premium"
        }
    }
    
    private var skipButton: some View {
        Button(action: {
            switch currentStep {
            case .description:
                break // Can't skip description
            case .wakeUp:
                navigateToNextStep(.emotions)
            case .emotions:
                navigateToNextStep(.intensity)
            case .intensity:
                // Check if user can interpret dream before proceeding
                if subscriptionService.canInterpretDream() {
                    navigateToNextStep(.interpretation)
                    subscriptionService.incrementInterpretationAttempts()
                    Task {
                        await viewModel.interpretDream(
                            description: viewModel.description,
                            didWakeUp: viewModel.didWakeUp,
                            hadNegativeEmotions: viewModel.hadNegativeEmotions,
                            intensityLevel: viewModel.intensityLevel
                        )
                        try? await Task.sleep(nanoseconds: 500_000_000)
                        withAnimation(AppAnimation.gentleSpring) {
                            currentStep = .results
                        }
                    }
                } else {
                    // User has used up free attempts, show subscription
                    navigateToNextStep(.subscription)
                }
            case .interpretation, .results, .subscription:
                break
            }
        }) {
            Text("Skip")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(primaryPurple)
        }
        .opacity(currentStep == .description ? 0 : 1)
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.2), value: currentStep)
    }
}

struct DreamDescriptionView: View {
    @Binding var dreamDescription: String
    let onNext: () -> Void
    @State private var isEditing = false
    @FocusState private var isTextFieldFocused: Bool
    
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 32) {
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(lightPurple)
                            .frame(width: 80, height: 80)
                        Image(systemName: "cloud.moon.fill")
                            .font(.system(size: 40))
                            .foregroundColor(primaryPurple)
                    }
                    .padding(.bottom, 8)
                    .appearanceAnimation()
                    
                    Text("WHAT WAS YOUR DREAM ABOUT?")
                        .font(.system(size: 24, weight: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                        .appearanceAnimation(delay: 0.05)
                    
                    Text("Share the details of your dream experience")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .appearanceAnimation(delay: 0.1)
                }
                .padding(.top, 20)
                
                VStack(spacing: 16) {
                    VStack(spacing: 0) {
                        ZStack(alignment: .bottomTrailing) {
                            TextEditor(text: $dreamDescription)
                                .frame(height: 180)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color(UIColor.secondarySystemBackground))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(primaryPurple.opacity(isEditing ? 0.3 : 0.15), lineWidth: 1.5)
                                )
                                .overlay(
                                    Group {
                                        if dreamDescription.isEmpty {
                                            Text("e.g. flying over the city on a beautiful night...")
                                                .foregroundColor(.secondary)
                                                .padding(.horizontal, 24)
                                                .padding(.vertical, 24)
                                                .onTapGesture {
                                                    isTextFieldFocused = true
                                                }
                                        }
                                    },
                                    alignment: .topLeading
                                )
                                .focused($isTextFieldFocused)
                                .toolbar {
                                    ToolbarItemGroup(placement: .keyboard) {
                                        Spacer()
                                        Button("Done") {
                                            isTextFieldFocused = false
                                        }
                                        .foregroundColor(primaryPurple)
                                        .font(.system(size: 16, weight: .semibold))
                                    }
                                }
                                .onTapGesture {
                                    isTextFieldFocused = true
                                }
                                .onChange(of: dreamDescription) { _, _ in
                                    isEditing = true
                                    // Reset after animation duration
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        isEditing = false
                                    }
                                }
                                .animation(.easeInOut(duration: 0.3), value: isEditing)
                            
                            VoiceInputButton(color: primaryPurple) { text in
                                if dreamDescription.isEmpty {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        dreamDescription = text
                                    }
                                } else {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        dreamDescription += " " + text
                                    }
                                }
                                // Add haptic feedback when text is updated
                                HapticManager.shared.success()
                                
                                // Unfocus the text field after speech input
                                isTextFieldFocused = false
                            }
                            .padding([.bottom, .trailing], 16)
                            .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .padding(.horizontal, 0)
                    .appearanceAnimation(delay: 0.15)
                    
                    Text("The more details you provide, the more accurate your dream interpretation will be. Include emotions, colors, and key events.")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .fixedSize(horizontal: false, vertical: true)
                        .appearanceAnimation(delay: 0.2)
                }
                
                Spacer(minLength: 20)
                
                VStack(spacing: 16) {
                    Button(action: {
                        isTextFieldFocused = false
                        onNext()
                    }) {
                        HStack(spacing: 8) {
                            Text("NEXT STEP")
                                .font(.system(size: 16, weight: .semibold))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(!dreamDescription.isEmpty ? primaryPurple : primaryPurple.opacity(0.5))
                        )
                    }
                    .scaleEffect(!dreamDescription.isEmpty ? 1.0 : 0.98)
                    .disabled(dreamDescription.isEmpty)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: dreamDescription.isEmpty)
                    .appearanceAnimation(delay: 0.25)
                    
                    HStack(spacing: 8) {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 14))
                        Text("Your dreams are fully confidential")
                            .font(.system(size: 14))
                    }
                    .foregroundColor(.secondary)
                    .padding(.bottom, 16)
                    .appearanceAnimation(delay: 0.3)
                }
            }
            .padding(.bottom, 16)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

struct DreamWakeUpView: View {
    @Binding var didWakeUp: Bool?
    let onNext: () -> Void
    let onSkip: () -> Void
    
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    
    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(lightPurple)
                        .frame(width: 80, height: 80)
                    Image(systemName: "moon.zzz.fill")
                        .font(.system(size: 40))
                        .foregroundColor(primaryPurple)
                }
                .padding(.bottom, 8)
                
                Text("DID THE DREAM WAKE YOU UP?")
                    .font(.system(size: 24, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                
                Text("Understanding your sleep patterns helps analyze dream significance")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 20)
            
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    SelectionButton(
                        title: "Yes",
                        isSelected: didWakeUp == true,
                        action: { didWakeUp = true }
                    )
                    
                    SelectionButton(
                        title: "No",
                        isSelected: didWakeUp == false,
                        action: { didWakeUp = false }
                    )
                }
                .padding(.horizontal, 8)
                
                if didWakeUp != nil {
                    Text(didWakeUp == true ? 
                        "Dreams that wake us often carry important messages from our subconscious" :
                        "Dreams that don't disturb sleep can reveal our deeper emotional state"
                    )
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .transition(.opacity)
                }
            }
            
            Spacer()
            
            VStack(spacing: 12) {
                Button(action: onNext) {
                    HStack(spacing: 8) {
                        Text("CONTINUE")
                            .font(.system(size: 16, weight: .semibold))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(didWakeUp != nil ? primaryPurple : primaryPurple.opacity(0.5))
                    )
                }
                .disabled(didWakeUp == nil)
                .animation(.easeInOut, value: didWakeUp)
                
                Button(action: onSkip) {
                    HStack(spacing: 8) {
                        Text("SKIP")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(primaryPurple)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(primaryPurple.opacity(0.5), lineWidth: 1.5)
                    )
                }
            }
            .padding(.bottom, 16)
        }
        .padding(.bottom, 16)
    }
}

struct DreamEmotionsView: View {
    @Binding var hadNegativeEmotions: Bool?
    let onNext: () -> Void
    let onSkip: () -> Void
    
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    
    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(lightPurple)
                        .frame(width: 80, height: 80)
                    Image(systemName: "heart.fill")
                        .font(.system(size: 40))
                        .foregroundColor(primaryPurple)
                }
                .padding(.bottom, 8)
                
                Text("DID YOU EXPERIENCE NEGATIVE FEELINGS?")
                    .font(.system(size: 24, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                
                Text("Emotional content is key to understanding dream symbolism")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 20)
            
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    SelectionButton(
                        title: "Yes",
                        isSelected: hadNegativeEmotions == true,
                        action: { hadNegativeEmotions = true }
                    )
                    
                    SelectionButton(
                        title: "No",
                        isSelected: hadNegativeEmotions == false,
                        action: { hadNegativeEmotions = false }
                    )
                }
                .padding(.horizontal, 8)
                
                if hadNegativeEmotions != nil {
                    Text(hadNegativeEmotions == true ? 
                        "Negative emotions in dreams often highlight areas in life that need attention" :
                        "Neutral or positive dreams can reveal opportunities and hidden potential"
                    )
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .transition(.opacity)
                }
            }
            
            Spacer()
            
            VStack(spacing: 12) {
                Button(action: onNext) {
                    HStack(spacing: 8) {
                        Text("CONTINUE")
                            .font(.system(size: 16, weight: .semibold))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(hadNegativeEmotions != nil ? primaryPurple : primaryPurple.opacity(0.5))
                    )
                }
                .disabled(hadNegativeEmotions == nil)
                .animation(.easeInOut, value: hadNegativeEmotions)
                
                Button(action: onSkip) {
                    HStack(spacing: 8) {
                        Text("SKIP")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(primaryPurple)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(primaryPurple.opacity(0.5), lineWidth: 1.5)
                    )
                }
            }
            .padding(.bottom, 16)
        }
        .padding(.bottom, 16)
    }
}

struct DreamIntensityView: View {
    @Binding var intensityLevel: Double
    let onNext: () -> Void
    let onSkip: () -> Void
    
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    
    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(lightPurple)
                        .frame(width: 80, height: 80)
                    Image(systemName: "gauge.high")
                        .font(.system(size: 40))
                        .foregroundColor(primaryPurple)
                }
                .padding(.bottom, 8)
                
                Text("HOW INTENSE WAS\nYOUR DREAM?")
                    .font(.system(size: 24, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 20)
                
                Text("Dream intensity often correlates with its significance")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            .padding(.top, 20)
            
            VStack(spacing: 32) {
                Text("\(Int(intensityLevel))")
                    .font(.system(size: 64, weight: .bold))
                    .foregroundColor(primaryPurple)
                    .frame(height: 80)
                    .animation(.easeInOut(duration: 0.2), value: intensityLevel)
                
                VStack(spacing: 20) {
                    VStack(spacing: 12) {
                        Slider(value: $intensityLevel, in: 1...10, step: 1)
                            .tint(primaryPurple)
                        
                        HStack {
                            Text("Mild")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("Intense")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 4)
                    }
                    
                    Text(intensityLevel <= 3 ? 
                        "Mild dreams can reveal subtle influences in your life" :
                        intensityLevel <= 7 ? 
                        "Moderate intensity dreams often contain important insights" :
                        "Highly intense dreams typically carry significant messages"
                    )
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal)
                    .id("intensity-description-\(Int(intensityLevel))")
                    .animation(.easeInOut, value: Int(intensityLevel))
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(UIColor.secondarySystemBackground))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(primaryPurple.opacity(0.15), lineWidth: 1.5)
                )
            }
            
            Spacer()
            
            VStack(spacing: 12) {
                Button(action: onNext) {
                    HStack(spacing: 8) {
                        Text("CONTINUE")
                            .font(.system(size: 16, weight: .semibold))
                        Image(systemName: "arrow.right")
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
                .animation(.easeInOut, value: intensityLevel)
                
                Button(action: onSkip) {
                    HStack(spacing: 8) {
                        Text("SKIP")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(primaryPurple)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(primaryPurple.opacity(0.5), lineWidth: 1.5)
                    )
                }
            }
            .padding(.bottom, 16)
        }
        .padding(.bottom, 16)
    }
}

struct SelectionButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20, weight: .semibold))
                } else {
                    Circle()
                        .strokeBorder(Color.secondary.opacity(0.3), lineWidth: 1.5)
                        .frame(width: 20, height: 20)
                }
            }
            .foregroundColor(isSelected ? primaryPurple : .primary)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? lightPurple : Color(UIColor.secondarySystemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(isSelected ? primaryPurple : Color.clear, lineWidth: 1.5)
            )
            .animation(.spring(response: 0.2), value: isSelected)
        }
    }
} 