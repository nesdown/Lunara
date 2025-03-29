import SwiftUI
import UserNotifications
import StoreKit

// MARK: - OnboardingViewModel
class OnboardingViewModel: ObservableObject {
    @Published var currentPage = 0
    @Published var userName = ""
    @Published var hasCompletedOnboarding = false
    @Published var shouldShowNotificationPermission = false
    
    // Animation states
    @Published var isAnimating = false
    @Published var showContent = false
    @Published var iconOffset: CGFloat = 0
    
    // Magic transition states
    @Published var isTransitioning = false
    @Published var portalScale: CGFloat = 0.001
    @Published var portalOpacity: Double = 0
    @Published var showStars = false
    @Published var rotationAngle: Double = 0
    @Published var cosmicDustOpacity: Double = 0
    @Published var starfieldScale: CGFloat = 0.1
    @Published var showWaves = false
    @Published var showWelcomeText = false
    @Published var welcomeTextOpacity: Double = 0
    
    // Optimization flags
    @Published var isTextFieldFocused = false
    
    // Colors - Enhanced purple palette
    let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    let darkPurple = Color(red: 102/255, green: 51/255, blue: 153/255)
    let deepPurple = Color(red: 76/255, green: 40/255, blue: 130/255)
    let veryLightPurple = Color(red: 245/255, green: 240/255, blue: 255/255)
    
    // Onboarding content
    let pages = [
        OnboardingPage(
            title: "Welcome to Lunara!",
            description: "Your journey to understanding dreams and unlocking their potential starts here.",
            imageName: "star.fill",
            additionalImages: ["moon.stars.fill", "sparkles", "cloud.moon.fill"]
        ),
        OnboardingPage(
            title: "We spend 1/3 of our lives dreaming",
            description: "Yet the nature and meaning of our dreams remain unexplained. We will help you interpret your dreams.",
            imageName: "moon.stars.fill",
            additionalImages: ["sparkles", "moon.fill", "star.fill"]
        ),
        OnboardingPage(
            title: "Not all nightmares mean something bad",
            description: "However, not all good dreams are for the better. We will help you understand the dreams' meaning.",
            imageName: "cloud.moon.fill",
            additionalImages: ["bolt.fill", "moon.fill", "cloud.sun.fill"]
        ),
        OnboardingPage(
            title: "Have you ever regretted forgetting your dreams?",
            description: "We've got you. With our Meanings Journal™, all your dreams will be saved and organized.",
            imageName: "book.closed.fill",
            additionalImages: ["square.text.square.fill", "bookmark.fill", "pencil"]
        ),
        OnboardingPage(
            title: "Your privacy is our paramount",
            description: "The meaning of dreams can be intimidating. We value your privacy, so all you share in the app is secure.",
            imageName: "lock.shield.fill",
            additionalImages: ["hand.raised.fill", "checkmark.seal.fill", "key.fill"],
            showNotificationPrompt: true
        ),
        OnboardingPage(
            title: "What should we call you?",
            description: "We'd love to know your name to provide a more personalized experience.",
            imageName: "person.fill",
            additionalImages: ["heart.fill", "star.fill", "wand.and.stars"],
            isNameInputPage: true
        )
    ]
    
    func completeOnboarding() {
        // Provide haptic feedback when completing onboarding
        HapticManager.shared.success()
        
        // Save user name
        if !userName.isEmpty {
            UserDefaults.standard.set(userName, forKey: "userName")
        } else {
            // Set a default name if the user didn't enter one
            UserDefaults.standard.set("Dreamer", forKey: "userName")
        }
        
        // Mark onboarding as completed
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        
        // Start magical transition instead of immediately setting hasCompletedOnboarding
        startMagicalTransition()
    }
    
    func startMagicalTransition() {
        isTransitioning = true
        
        // Initial cosmic dust appears
        withAnimation(.easeIn(duration: 0.3)) {
            cosmicDustOpacity = 0.7
        }
        
        // Portal begins to form
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                self.portalOpacity = 1
                self.portalScale = 1
            }
            
            // Provide haptic feedback for portal appearance
            HapticManager.shared.medium()
        }
        
        // Stars appear
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.showStars = true
            withAnimation(.easeInOut(duration: 1.5)) {
                self.starfieldScale = 1.8
                self.rotationAngle = 180
            }
            
            // Provide gentle haptic for stars
            HapticManager.shared.light()
        }
        
        // Waves effect
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            self.showWaves = true
            
            // Another haptic for waves
            HapticManager.shared.light()
        }
        
        // Welcome text appears
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            self.showWelcomeText = true
            withAnimation(.easeIn(duration: 1.0)) {
                self.welcomeTextOpacity = 1
            }
            
            // Final haptic for completion
            HapticManager.shared.success()
        }
        
        // Finally, complete the onboarding process
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            self.hasCompletedOnboarding = true
        }
    }
    
    func handleNextAction() {
        // Provide haptic feedback for navigation
        HapticManager.shared.selection()
        
        // Check if we need to show notification permission
        if pages[currentPage].showNotificationPrompt && !shouldShowNotificationPermission {
            requestNotificationPermission()
            return
        }
        
        // Check if we're on the last page or move to the next
        if currentPage == pages.count - 1 {
            completeOnboarding()
        } else {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                currentPage += 1
            }
            
            // Reset animation states for new page
            resetAnimationStates()
        }
    }
    
    func requestNotificationPermission() {
        shouldShowNotificationPermission = true
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                // Move to the next page after requesting permission
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    self.currentPage += 1
                }
                
                // Reset animation states for new page
                self.resetAnimationStates()
                
                // Save notification preference
                UserDefaults.standard.set(granted, forKey: "notificationsEnabled")
            }
        }
    }
    
    private func resetAnimationStates() {
        // Reset animation states
        showContent = false
        isAnimating = false
        
        // Trigger animations for new page after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeOut(duration: 0.5)) {
                self.showContent = true
            }
            self.isAnimating = true
        }
    }
}

// MARK: - OnboardingPage Model
struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
    let additionalImages: [String]
    var showNotificationPrompt: Bool = false
    var isNameInputPage: Bool = false
}

// MARK: - OnboardingView
struct OnboardingFlow: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @FocusState private var isNameFieldFocused: Bool
    
    var body: some View {
        ZStack {
            // Main content
            if !viewModel.isTransitioning {
                onboardingContent
                    .background(backgroundGradient)
            }
            
            // Magic transition when onboarding completes
            if viewModel.isTransitioning {
                magicalTransitionView
            }
        }
        .onChange(of: isNameFieldFocused) { _, isFocused in
            viewModel.isTextFieldFocused = isFocused
        }
    }
    
    // MARK: - Main Onboarding Content
    private var onboardingContent: some View {
        VStack {
            // Page content
            TabView(selection: $viewModel.currentPage) {
                ForEach(0..<viewModel.pages.count, id: \.self) { index in
                    PageView(page: viewModel.pages[index], viewModel: viewModel)
                        .tag(index)
                        .focused($isNameFieldFocused, equals: index == viewModel.pages.count - 1)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.easeInOut, value: viewModel.currentPage)
            
            // Bottom bar with pagination and button
            HStack {
                // Page indicator
                PageIndicator(currentPage: viewModel.currentPage, pageCount: viewModel.pages.count)
                
                Spacer()
                
                // Next/Complete button
                Button(action: viewModel.handleNextAction) {
                    Text(viewModel.currentPage == viewModel.pages.count - 1 ? "Complete" : "Next")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 16)
                        .background(
                            Capsule()
                                .fill(viewModel.primaryPurple)
                        )
                        .overlay(
                            Capsule()
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                        .shadow(color: viewModel.darkPurple.opacity(0.5), radius: 8, x: 0, y: 4)
                }
                .buttonStyle(ScaleButtonStyle())
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
        }
    }
    
    // MARK: - Magical Transition
    private var magicalTransitionView: some View {
        ZStack {
            // Background
            viewModel.deepPurple
                .ignoresSafeArea()
            
            // Cosmic dust effect
            CosmicDustView()
                .opacity(viewModel.cosmicDustOpacity)
            
            // Starfield
            StarfieldView(scale: viewModel.starfieldScale)
                .opacity(viewModel.showStars ? 1 : 0)
            
            // Portal effect
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            .white,
                            viewModel.lightPurple,
                            viewModel.primaryPurple,
                            viewModel.darkPurple.opacity(0.8),
                            viewModel.deepPurple.opacity(0.3),
                            .clear
                        ]),
                        center: .center,
                        startRadius: 10,
                        endRadius: 200
                    )
                )
                .frame(width: 300, height: 300)
                .scaleEffect(viewModel.portalScale)
                .opacity(viewModel.portalOpacity)
                .rotationEffect(Angle(degrees: viewModel.rotationAngle))
            
            // Radial wave effect
            if viewModel.showWaves {
                RadialWavesView()
            }
            
            // Welcome text
            if viewModel.showWelcomeText {
                WelcomeTextView(opacity: viewModel.welcomeTextOpacity)
            }
        }
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                viewModel.deepPurple,
                viewModel.darkPurple,
                viewModel.primaryPurple.opacity(0.85)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

// MARK: - Page View
struct PageView: View {
    let page: OnboardingPage
    @ObservedObject var viewModel: OnboardingViewModel
    @FocusState private var isInputFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Main icon with animations (optimized)
            if !viewModel.isTextFieldFocused {
                ZStack {
                    Image(systemName: page.imageName)
                        .font(.system(size: 80))
                        .foregroundColor(.white)
                        .offset(y: viewModel.iconOffset)
                        .shadow(color: viewModel.darkPurple.opacity(0.8), radius: 10, x: 0, y: 5)
                        .opacity(viewModel.showContent ? 1 : 0)
                        .scaleEffect(viewModel.showContent ? 1 : 0.7)
                        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: viewModel.showContent)
                    
                    // Only show orbital icons when not on name input or notification page
                    if !page.isNameInputPage && !viewModel.isTextFieldFocused {
                        orbitalIcons
                            .opacity(viewModel.showContent ? 1 : 0)
                            .animation(.easeInOut(duration: 0.5).delay(0.1), value: viewModel.showContent)
                    }
                }
                .frame(height: 200) // Fixed height to avoid layout shifts
                .padding(.top, 40)
            }
            
            // Content - optimized animations
            VStack(spacing: 24) {
                Text(page.title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 24)
                    .opacity(viewModel.showContent ? 1 : 0)
                    .offset(y: viewModel.showContent ? 0 : 20)
                    .animation(.easeOut(duration: 0.4), value: viewModel.showContent)
                
                Text(page.description)
                    .font(.system(size: 17, weight: .medium))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.9))
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 32)
                    .opacity(viewModel.showContent ? 1 : 0)
                    .offset(y: viewModel.showContent ? 0 : 15)
                    .animation(.easeOut(duration: 0.4).delay(0.1), value: viewModel.showContent)
            }
            .padding(.top, viewModel.isTextFieldFocused ? 100 : 40)
            
            // Name input field for the name page
            if page.isNameInputPage {
                nameInputField
                    .opacity(viewModel.showContent ? 1 : 0)
                    .offset(y: viewModel.showContent ? 0 : 20)
                    .animation(.easeOut(duration: 0.4).delay(0.2), value: viewModel.showContent)
                    .focused($isInputFieldFocused)
                    .onChange(of: isInputFieldFocused) { _, isFocused in
                        // Provide haptic feedback when focusing the text field
                        if isFocused {
                            HapticManager.shared.light()
                        }
                    }
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            if page.isNameInputPage {
                // Optimize by delaying focusing the text field
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isInputFieldFocused = true
                }
            }
        }
    }
    
    // Optimized orbital icons view
    private var orbitalIcons: some View {
        GeometryReader { geometry in
            ForEach(0..<min(page.additionalImages.count, 3), id: \.self) { index in
                let distance = CGFloat.random(in: 70...110)
                let rotation = Double(index) * 120.0
                let delay = Double(index) * 0.2
                
                Image(systemName: page.additionalImages[index])
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                    .offset(
                        x: cos(Angle(degrees: rotation).radians) * distance,
                        y: sin(Angle(degrees: rotation).radians) * distance
                    )
                    .rotationEffect(Angle(degrees: viewModel.isAnimating ? rotation + 5 : rotation - 5))
                    .animation(
                        Animation.easeInOut(duration: 3)
                            .repeatForever(autoreverses: true)
                            .delay(delay),
                        value: viewModel.isAnimating
                    )
                    .scaleEffect(viewModel.isAnimating ? 1 : 0.8)
                    .animation(
                        Animation.easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true)
                            .delay(delay),
                        value: viewModel.isAnimating
                    )
            }
        }
        .frame(height: 240)
    }
    
    // MARK: - Name Input Field
    private var nameInputField: some View {
        VStack(spacing: 12) {
            TextField("Your name", text: $viewModel.userName)
                .font(.system(size: 17))
                .foregroundColor(.white)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(viewModel.primaryPurple.opacity(0.2))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(viewModel.lightPurple.opacity(0.5), lineWidth: 1)
                )
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .autocapitalization(.words)
                .onChange(of: viewModel.userName) { _, _ in
                    // Haptic feedback when typing name
                    HapticManager.shared.selection()
                }
        }
    }
}

// MARK: - Supporting Views

// Scale Button Style with Haptic Feedback
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// Page Indicator with Haptic Feedback
struct PageIndicator: View {
    let currentPage: Int
    let pageCount: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<pageCount, id: \.self) { page in
                Circle()
                    .fill(page == currentPage ? Color.white : Color.white.opacity(0.4))
                    .frame(width: 8, height: 8)
                    .scaleEffect(page == currentPage ? 1.2 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
            }
        }
    }
}

// Simplified Starfield View for better performance
struct StarfieldView: View {
    let scale: CGFloat
    let starCount = 100 // Reduced from 200 for better performance
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Stars
                ForEach(0..<starCount, id: \.self) { i in
                    let size = CGFloat.random(in: 1...3)
                    let x = CGFloat.random(in: 0...geometry.size.width)
                    let y = CGFloat.random(in: 0...geometry.size.height)
                    
                    Circle()
                        .fill(Color.white)
                        .frame(width: size, height: size)
                        .position(x: x, y: y)
                }
            }
            .scaleEffect(scale)
        }
    }
}

// Optimized cosmic dust effect
struct CosmicDustView: View {
    var body: some View {
        ZStack {
            ForEach(0..<20, id: \.self) { _ in // Reduced from original for better performance
                Circle()
                    .fill(Color.white.opacity(Double.random(in: 0.05...0.2)))
                    .frame(width: CGFloat.random(in: 2...6), height: CGFloat.random(in: 2...6))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .blur(radius: CGFloat.random(in: 0...3))
            }
        }
    }
}

// Optimized radial waves
struct RadialWavesView: View {
    @State private var waveScale: CGFloat = 0.2
    @State private var waveOpacity: Double = 0.8
    
    var body: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { i in // Reduced for performance
                Circle()
                    .stroke(Color.white.opacity(max(0, waveOpacity - Double(i) * 0.3)), lineWidth: 2)
                    .scaleEffect(waveScale + CGFloat(i) * 0.4)
            }
        }
        .onAppear {
            withAnimation(Animation.easeOut(duration: 2.0).repeatForever(autoreverses: false)) {
                waveScale = 2.0
                waveOpacity = 0
            }
        }
    }
}

struct WelcomeTextView: View {
    let opacity: Double
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Welcome to Your Dreams")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .shadow(color: Color.purple.opacity(0.8), radius: 8, x: 0, y: 0)
            
            Text("Let the magic begin...")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white.opacity(0.9))
                .shadow(color: Color.purple.opacity(0.6), radius: 6, x: 0, y: 0)
        }
        .opacity(opacity)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.01)) // Nearly invisible but captures gestures
    }
} 