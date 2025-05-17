import SwiftUI
import UserNotifications
import StoreKit

// MARK: - OnboardingViewModel
class OnboardingViewModel: ObservableObject {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false
    @Published var currentPage = 0
    @Published var userName = ""
    @Published var shouldShowNotificationPermission = false
    @Published var showSubscription = false
    @Published var showReminderTimePicker = false
    @AppStorage("isReminderEnabled") private var isReminderEnabled = false
    @AppStorage("reminderTime") var reminderTimeString: String = "08:00"
    @Published var reminderDate = Calendar.current.date(from: DateComponents(hour: 8, minute: 0)) ?? Date()
    
    // Animation states
    @Published var isAnimating = false
    @Published var showContent = false
    @Published var iconScale: CGFloat = 0.8
    @Published var iconOpacity: Double = 0
    @Published var isTextFieldFocused = false
    
    // Quiz responses
    @Published var dreamFrequency: OnboardingDreamFrequency = .sometimes
    @Published var dreamType: DreamType = .adventure
    @Published var dreamRecall: DreamRecall = .moderate
    
    // Add a new property to track if onboarding data has been saved
    @Published var onboardingDataSaved = false
    
    // Colors
    let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    let darkPurple = Color(red: 102/255, green: 51/255, blue: 153/255)
    let deepPurple = Color(red: 76/255, green: 40/255, blue: 130/255)
    let veryLightPurple = Color(red: 245/255, green: 240/255, blue: 255/255)
    
    // Onboarding story pages - alternating between feature and quiz
    let pages: [OnboardingPage] = [
        // Page 1: Welcome to Lunara (Feature)
        OnboardingPage(
            type: .feature,
            title: "Unlock the World of Dreams",
            description: "Discover the hidden meanings behind your dreams and understand your subconscious mind.",
            imageName: "moon.stars.fill",
            backgroundElements: [
                BackgroundElement(imageName: "star.fill", size: 30, position: .topLeading, offset: CGPoint(x: 40, y: 120)),
                BackgroundElement(imageName: "sparkles", size: 30, position: .topTrailing, offset: CGPoint(x: -30, y: 160)),
                BackgroundElement(imageName: "cloud.moon.fill", size: 40, position: .bottomLeading, offset: CGPoint(x: 60, y: -140))
            ],
            animation: .float
        ),
        
        // Page 2: Dream Frequency (Quiz)
        OnboardingPage(
            type: .quiz,
            title: "How often do you remember your dreams?",
            description: "This helps us personalize your dream interpretation experience.",
            imageName: "moon.zzz.fill",
            quizType: .dreamFrequency,
            animation: .pulse
        ),
        
        // Page 3: Dream Journal Feature (Feature)
        OnboardingPage(
            type: .feature,
            title: "Never Forget Your Dreams",
            description: "Lunara's dream journal helps you record and organize your dreams, making patterns easier to identify.",
            imageName: "book.fill",
            backgroundElements: [
                BackgroundElement(imageName: "pencil", size: 24, position: .topTrailing, offset: CGPoint(x: -50, y: 140)),
                BackgroundElement(imageName: "chart.bar.fill", size: 30, position: .bottomLeading, offset: CGPoint(x: 40, y: -120)),
                BackgroundElement(imageName: "tag.fill", size: 26, position: .bottomTrailing, offset: CGPoint(x: -60, y: -150))
            ],
            animation: .reveal
        ),
        
        // Page 4: Dream Type (Quiz)
        OnboardingPage(
            type: .quiz,
            title: "What type of dreams do you have most often?",
            description: "Your common dream themes help us provide more accurate interpretations.",
            imageName: "cloud.sun.rain.fill",
            quizType: .dreamType,
            animation: .pulse
        ),
        
        // Page 5: AI Interpretation (Feature)
        OnboardingPage(
            type: .feature,
            title: "AI-Powered Dream Analysis",
            description: "Our advanced AI helps you uncover deep insights and meanings behind your most mysterious dreams.",
            imageName: "brain.head.profile",
            backgroundElements: [
                BackgroundElement(imageName: "waveform.path", size: 40, position: .topLeading, offset: CGPoint(x: 30, y: 110)),
                BackgroundElement(imageName: "network", size: 34, position: .bottomTrailing, offset: CGPoint(x: -50, y: -130)),
                BackgroundElement(imageName: "sparkles", size: 30, position: .bottomLeading, offset: CGPoint(x: 40, y: -140))
            ],
            animation: .float
        ),
        
        // Page 6: Dream Recall (Quiz)
        OnboardingPage(
            type: .quiz,
            title: "How well do you remember your dreams?",
            description: "This helps us tailor techniques to improve your dream recall abilities.",
            imageName: "brain.fill",
            quizType: .dreamRecall,
            animation: .pulse
        ),
        
        // NEW PAGE: Dream Logging Discipline (Feature) with notification permission
        OnboardingPage(
            type: .feature,
            title: "The Power of Daily Logging",
            description: "Consistently recording your dreams is key to understanding your dream patterns. Regular logging significantly improves your recall ability and leads to deeper insights.",
            imageName: "clock.badge.checkmark.fill",
            backgroundElements: [
                BackgroundElement(imageName: "bell.fill", size: 26, position: .topTrailing, offset: CGPoint(x: -40, y: 130)),
                BackgroundElement(imageName: "calendar.badge.clock", size: 28, position: .bottomLeading, offset: CGPoint(x: 50, y: -120))
            ],
            animation: .pulse,
            showNotificationPrompt: true,
            showReminderSetting: true
        ),
        
        // Page 7: Personalization (Feature/Input)
        OnboardingPage(
            type: .nameInput,
            title: "Personalize Your Journey",
            description: "Tell us your name to create a more personalized dream exploration experience.",
            imageName: "person.fill.viewfinder",
            backgroundElements: [
                BackgroundElement(imageName: "person.text.rectangle.fill", size: 26, position: .topTrailing, offset: CGPoint(x: -40, y: 130)),
                BackgroundElement(imageName: "sparkles", size: 24, position: .bottomLeading, offset: CGPoint(x: 50, y: -120))
            ],
            animation: .reveal
        ),
        
        // Page 8: Final Onboarding (Feature - leads to subscription)
        OnboardingPage(
            type: .final,
            title: "Congratulations!",
            description: "You've completed the onboarding process. Your personal dream exploration journey is about to begin!",
            imageName: "sparkles",
            backgroundElements: [
                BackgroundElement(imageName: "moon.stars.fill", size: 40, position: .topLeading, offset: CGPoint(x: 40, y: 120)),
                BackgroundElement(imageName: "star.fill", size: 30, position: .topTrailing, offset: CGPoint(x: -30, y: 160)),
                BackgroundElement(imageName: "wand.and.stars", size: 36, position: .bottomLeading, offset: CGPoint(x: 60, y: -140))
            ],
            animation: .float,
            showSubscriptionButton: false
        )
    ]
    
    init() {
        // Ensure onboarding is not marked as completed on init
        hasCompletedOnboarding = false
        
        // Check if we have a saved name
        if let savedName = UserDefaults.standard.string(forKey: "userName") {
            userName = savedName
        }
        
        // Load saved quiz responses if they exist
        if let savedFrequency = UserDefaults.standard.string(forKey: "dreamFrequency"),
           let frequency = OnboardingDreamFrequency(rawValue: savedFrequency) {
            dreamFrequency = frequency
        }
        
        if let savedType = UserDefaults.standard.string(forKey: "dreamType"),
           let type = DreamType(rawValue: savedType) {
            dreamType = type
        }
        
        if let savedRecall = UserDefaults.standard.string(forKey: "dreamRecall"),
           let recall = DreamRecall(rawValue: savedRecall) {
            dreamRecall = recall
        }
    }
    
    func completeOnboarding() {
        // Save user name
        if !userName.isEmpty {
            UserDefaults.standard.set(userName, forKey: "userName")
        } else {
            // Set a default name if the user didn't enter one
            UserDefaults.standard.set("Dreamer", forKey: "userName")
        }
        
        // Save quiz responses
        UserDefaults.standard.set(dreamFrequency.rawValue, forKey: "dreamFrequency")
        UserDefaults.standard.set(dreamType.rawValue, forKey: "dreamType")
        UserDefaults.standard.set(dreamRecall.rawValue, forKey: "dreamRecall")
        
        // Mark that we've saved the data
        onboardingDataSaved = true
    }
    
    func handleNextAction() {
        // Provide haptic feedback for navigation
        HapticManager.shared.selection()
        
        // If we're on the notification prompt page and haven't shown it yet
        if pages[currentPage].showNotificationPrompt && !shouldShowNotificationPermission {
            requestNotificationPermission()
            return
        }
        
        // If we're on the reminder setting page and haven't shown it yet
        if pages[currentPage].showReminderSetting && !showReminderTimePicker && shouldShowNotificationPermission {
            showReminderTimePicker = true
            return
        }
        
        // If we're on the last page
        if currentPage == pages.count - 1 {
            // Complete onboarding
            completeOnboarding()
            
            // No longer showing subscription view
            hasCompletedOnboarding = true
            
            // Request app store review after onboarding (part of our rating strategy)
            // We'll use our RatingService to track this request
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                RatingService.shared.requestSystemReview()
            }
        } else {
            // Move to the next page
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
                // Save notification preference
                UserDefaults.standard.set(granted, forKey: "notificationsEnabled")
                
                // We don't advance to the next page here anymore
                // Instead we'll show the reminder time picker if permissions were granted
                if granted {
                    self.isReminderEnabled = true
                }
            }
        }
    }
    
    func saveReminderTime() {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        reminderTimeString = timeFormatter.string(from: reminderDate)
        
        // Schedule the notification
        if isReminderEnabled {
            scheduleDreamReminders()
        }
        
        // After setting up reminders, move to the next page
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            currentPage += 1
        }
        
        // Reset animation states for new page
        resetAnimationStates()
    }
    
    // Function to schedule daily notifications
    private func scheduleDreamReminders() {
        guard isReminderEnabled else { return }
        
        // Create reminder text options
        let reminderTexts = [
            "Good morning! Remember any dreams last night? Take a moment to record them while they're still fresh.",
            "Rise and shine! Did you have any interesting dreams? Open Lunara to log them before they fade away.",
            "Morning! Your dream journal is waiting for today's entry. What adventures did your mind take you on?",
            "Hey dreamer! Time to capture those nighttime thoughts before they disappear. Open Lunara now."
        ]
        
        // Extract hour and minute components from the selected date
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: reminderDate)
        let minute = calendar.component(.minute, from: reminderDate)
        
        // Set up notification content
        let notificationCenter = UNUserNotificationCenter.current()
        
        // Create a date component for the notification
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        // Create the trigger (repeating daily)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // Choose one reminder text randomly for consistency
        let randomIndex = Int.random(in: 0..<reminderTexts.count)
        let reminderText = reminderTexts[randomIndex]
        
        // Create the content
        let content = UNMutableNotificationContent()
        content.title = "Dream Journal Reminder"
        content.body = reminderText
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        // Create the request with a single identifier
        let request = UNNotificationRequest(
            identifier: "dreamDailyReminder",
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
    
    private func resetAnimationStates() {
        // Reset animation states
        showContent = false
        isAnimating = false
        iconOpacity = 0
        iconScale = 0.8
        
        // Trigger animations for new page after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeOut(duration: 0.6)) {
                self.showContent = true
                self.iconOpacity = 1
                self.iconScale = 1
            }
            self.isAnimating = true
        }
    }
}

// MARK: - Enum Types for Quiz Questions
enum OnboardingDreamFrequency: String, CaseIterable, Identifiable {
    case rarely = "Rarely"
    case sometimes = "Sometimes"
    case often = "Often"
    
    var id: String { self.rawValue }
}

enum DreamType: String, CaseIterable, Identifiable {
    case flying = "Flying Dreams"
    case adventure = "Adventure Dreams"
    case nightmare = "Nightmares"
    
    var id: String { self.rawValue }
}

enum DreamRecall: String, CaseIterable, Identifiable {
    case vague = "Very Vague"
    case moderate = "Moderate Details"
    case vivid = "Vivid Details"
    
    var id: String { self.rawValue }
}

// MARK: - Animation Types
enum OnboardingAnimation {
    case float
    case pulse
    case reveal
}

// MARK: - Position Types
enum ElementPosition {
    case topLeading
    case topTrailing
    case bottomLeading
    case bottomTrailing
}

// MARK: - Background Element Model
struct BackgroundElement {
    let imageName: String
    let size: CGFloat
    let position: ElementPosition
    let offset: CGPoint
}

// MARK: - OnboardingPage Types
enum OnboardingPageType {
    case feature
    case quiz
    case nameInput
    case final
}

// MARK: - Quiz Types
enum QuizType {
    case dreamFrequency
    case dreamType
    case dreamRecall
    case none
}

// MARK: - OnboardingPage Model
struct OnboardingPage {
    let type: OnboardingPageType
    let title: String
    let description: String
    let imageName: String
    var backgroundElements: [BackgroundElement] = []
    var quizType: QuizType = .none
    var animation: OnboardingAnimation = .float
    var showNotificationPrompt: Bool = false
    var showReminderSetting: Bool = false
    var showSubscriptionButton: Bool = false
}

// MARK: - OnboardingView
struct OnboardingFlow: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @FocusState private var isNameFieldFocused: Bool
    
    var body: some View {
        ZStack {
            // Main content
            onboardingContent
                .background(backgroundGradient)
                .fullScreenCover(isPresented: $viewModel.showSubscription) {
                    // When subscription view is dismissed
                    if viewModel.onboardingDataSaved {
                        // Mark onboarding as completed
                        viewModel.hasCompletedOnboarding = true
                    }
                } content: {
                    SubscriptionView()
                }
                .sheet(isPresented: $viewModel.showReminderTimePicker) {
                    // After setting the reminder time
                    if viewModel.shouldShowNotificationPermission {
                        ReminderTimePickerView(
                            isPresented: $viewModel.showReminderTimePicker,
                            reminderDate: $viewModel.reminderDate,
                            reminderTimeString: $viewModel.reminderTimeString,
                            onSave: {
                                viewModel.saveReminderTime()
                            }
                        )
                    }
                }
                .onChange(of: isNameFieldFocused) { _, isFocused in
                    viewModel.isTextFieldFocused = isFocused
                }
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
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.easeInOut, value: viewModel.currentPage)
            
            // Bottom bar with pagination and button
            bottomBar
        }
    }
    
    private var bottomBar: some View {
            HStack {
                // Page indicator
                PageIndicator(currentPage: viewModel.currentPage, pageCount: viewModel.pages.count)
                
                Spacer()
                
                // Next/Complete button
                Button(action: viewModel.handleNextAction) {
                let buttonText = getButtonText()
                
                HStack(spacing: 8) {
                    Text(buttonText)
                        .font(.system(size: 17, weight: .semibold))
                    
                    if viewModel.currentPage != viewModel.pages.count - 1 {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14))
                    }
                }
                        .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 14)
                        .background(
                            Capsule()
                        .fill(viewModel.currentPage == viewModel.pages.count - 1 ? 
                             LinearGradient(gradient: Gradient(colors: [viewModel.primaryPurple, viewModel.darkPurple]), startPoint: .leading, endPoint: .trailing) : 
                             LinearGradient(gradient: Gradient(colors: [viewModel.primaryPurple, viewModel.primaryPurple]), startPoint: .leading, endPoint: .trailing))
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
    
    private func getButtonText() -> String {
        let page = viewModel.pages[viewModel.currentPage]
        
        if viewModel.currentPage == viewModel.pages.count - 1 {
            return "Continue"
        } else if page.type == .quiz {
            return "Continue"
        } else {
            return "Next"
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
            // Main content area
                ZStack {
                // Background elements
                ForEach(0..<page.backgroundElements.count, id: \.self) { index in
                    let element = page.backgroundElements[index]
                    
                    backgroundElementView(element: element)
                        .opacity(viewModel.showContent ? 0.8 : 0)
                        .offset(x: viewModel.showContent ? 0 : getInitialOffset(for: element.position).x,
                                y: viewModel.showContent ? 0 : getInitialOffset(for: element.position).y)
                        .animation(.easeOut(duration: 0.7).delay(0.3 + Double(index) * 0.1), value: viewModel.showContent)
                }
                
                // Content VStack
                VStack(spacing: 30) {
                    Spacer()
                    
                    // Main icon with animations
                    mainIconView
                        .padding(.bottom, 30)
                    
                    // Quiz content if applicable
                    if page.type == .quiz {
                        quizContent
                            .opacity(viewModel.showContent ? 1 : 0)
                            .offset(y: viewModel.showContent ? 0 : 20)
                            .animation(.easeOut(duration: 0.6).delay(0.2), value: viewModel.showContent)
                    } else if page.type == .nameInput {
                        nameInputField
                            .opacity(viewModel.showContent ? 1 : 0)
                            .offset(y: viewModel.showContent ? 0 : 20)
                            .animation(.easeOut(duration: 0.6).delay(0.2), value: viewModel.showContent)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
            }
            
            // Bottom text content
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 24)
                    .opacity(viewModel.showContent ? 1 : 0)
                    .offset(y: viewModel.showContent ? 0 : 20)
                    .animation(.easeOut(duration: 0.5), value: viewModel.showContent)
                
                Text(page.description)
                    .font(.system(size: 17, weight: .medium))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.9))
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 24)
                    .opacity(viewModel.showContent ? 1 : 0)
                    .offset(y: viewModel.showContent ? 0 : 15)
                    .animation(.easeOut(duration: 0.5).delay(0.1), value: viewModel.showContent)
                
                // Subscription button for final page
                if page.showSubscriptionButton {
                    Button(action: {
                        viewModel.showSubscription = true
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 14))
                            
                            Text("See Premium Features")
                                .font(.system(size: 15, weight: .semibold))
                        }
                        .foregroundColor(viewModel.primaryPurple)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20)
                        .background(
                            Capsule()
                                .fill(Color.white)
                        )
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    }
                    .buttonStyle(ScaleButtonStyle())
                    .opacity(viewModel.showContent ? 1 : 0)
                    .offset(y: viewModel.showContent ? 0 : 20)
                    .animation(.easeOut(duration: 0.5).delay(0.2), value: viewModel.showContent)
                }
            }
            .padding(.bottom, 40)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeOut(duration: 0.6)) {
                    viewModel.showContent = true
                    viewModel.iconOpacity = 1
                    viewModel.iconScale = 1
                }
                viewModel.isAnimating = true
            }
        }
    }
    
    // MARK: - Main Icon View
    private var mainIconView: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            viewModel.primaryPurple.opacity(0.7),
                            viewModel.primaryPurple.opacity(0.5),
                            viewModel.primaryPurple.opacity(0.3)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 180, height: 180)
                .opacity(viewModel.showContent ? 0.8 : 0)
                .scaleEffect(viewModel.showContent ? 1 : 0.7)
                .animation(.spring(response: 0.6, dampingFraction: 0.7), value: viewModel.showContent)
            
            Image(systemName: page.imageName)
                .font(.system(size: 80))
                    .foregroundColor(.white)
                .opacity(viewModel.iconOpacity)
                .scaleEffect(viewModel.iconScale)
                .modifier(getAnimationModifier(for: page.animation))
        }
    }
    
    // MARK: - Background Element View
    private func backgroundElementView(element: BackgroundElement) -> some View {
        Image(systemName: element.imageName)
            .font(.system(size: element.size))
            .foregroundColor(.white.opacity(0.8))
            .position(
                x: getPositionX(for: element.position) + element.offset.x,
                y: getPositionY(for: element.position) + element.offset.y
            )
    }
    
    // MARK: - Quiz Content
    @ViewBuilder
    private var quizContent: some View {
        switch page.quizType {
        case .dreamFrequency:
            VStack(spacing: 12) {
                ForEach(OnboardingDreamFrequency.allCases) { frequency in
                    QuizOptionButton(
                        title: frequency.rawValue,
                        isSelected: viewModel.dreamFrequency == frequency,
                        action: {
                            viewModel.dreamFrequency = frequency
                            HapticManager.shared.selection()
                        }
                    )
                }
            }
            .padding(.horizontal, 16)
            
        case .dreamType:
            VStack(spacing: 12) {
                ForEach(DreamType.allCases) { type in
                    QuizOptionButton(
                        title: type.rawValue,
                        isSelected: viewModel.dreamType == type,
                        action: {
                            viewModel.dreamType = type
                            HapticManager.shared.selection()
                        }
                    )
                }
            }
            .padding(.horizontal, 16)
            
        case .dreamRecall:
            VStack(spacing: 12) {
                ForEach(DreamRecall.allCases) { recall in
                    QuizOptionButton(
                        title: recall.rawValue,
                        isSelected: viewModel.dreamRecall == recall,
                        action: {
                            viewModel.dreamRecall = recall
                            HapticManager.shared.selection()
                        }
                    )
                }
            }
            .padding(.horizontal, 16)
            
        case .none:
            EmptyView()
        }
    }
    
    // MARK: - Name Input Field
    private var nameInputField: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "person.fill")
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.leading, 16)
                
            TextField("Your name", text: $viewModel.userName)
                .font(.system(size: 17))
                .foregroundColor(.white)
                    .padding(.vertical, 16)
                    .padding(.trailing, 16)
                    .autocapitalization(.words)
                    .focused($isInputFieldFocused)
                    .submitLabel(.done)
                    .onSubmit {
                        isInputFieldFocused = false
                    }
            }
                .background(
                    RoundedRectangle(cornerRadius: 16)
                    .fill(viewModel.primaryPurple.opacity(0.3))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(viewModel.lightPurple.opacity(0.5), lineWidth: 1)
                )
                .padding(.horizontal, 24)
                .padding(.top, 16)
        }
    }
    
    // MARK: - Helper Functions
    
    private func getPositionX(for position: ElementPosition) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        
        switch position {
        case .topLeading, .bottomLeading:
            return screenWidth * 0.25
        case .topTrailing, .bottomTrailing:
            return screenWidth * 0.75
        }
    }
    
    private func getPositionY(for position: ElementPosition) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        
        switch position {
        case .topLeading, .topTrailing:
            return screenHeight * 0.25
        case .bottomLeading, .bottomTrailing:
            return screenHeight * 0.65
        }
    }
    
    private func getInitialOffset(for position: ElementPosition) -> CGPoint {
        switch position {
        case .topLeading:
            return CGPoint(x: -50, y: -50)
        case .topTrailing:
            return CGPoint(x: 50, y: -50)
        case .bottomLeading:
            return CGPoint(x: -50, y: 50)
        case .bottomTrailing:
            return CGPoint(x: 50, y: 50)
        }
    }
    
    private func getAnimationModifier(for animation: OnboardingAnimation) -> some ViewModifier {
        UnifiedAnimationModifier(animation: animation)
    }
}

// MARK: - Animation Modifiers
struct UnifiedAnimationModifier: ViewModifier {
    let animation: OnboardingAnimation
    @State private var offsetY: CGFloat = 0
    @State private var scale: CGFloat = 1
    @State private var rotationAngle: Double = 0
    
    func body(content: Content) -> some View {
        content
            .offset(y: animation == .float ? offsetY : 0)
            .scaleEffect(animation == .pulse ? scale : 1)
            .rotationEffect(animation == .reveal ? Angle(degrees: rotationAngle) : .zero)
            .onAppear {
                switch animation {
                case .float:
                    withAnimation(
                        Animation.easeInOut(duration: 2.5)
                            .repeatForever(autoreverses: true)
                    ) {
                        offsetY = -15
                    }
                case .pulse:
                    withAnimation(
                        Animation.easeInOut(duration: 1.8)
                            .repeatForever(autoreverses: true)
                    ) {
                        scale = 1.1
                    }
                case .reveal:
                    withAnimation(
                        Animation.easeInOut(duration: 8)
                            .repeatForever(autoreverses: false)
                    ) {
                        rotationAngle = 360
                    }
                }
            }
    }
}

// MARK: - Quiz Option Button
struct QuizOptionButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: 17, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? .white : .white.opacity(0.9))
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                } else {
                    Circle()
                        .stroke(Color.white.opacity(0.5), lineWidth: 1.5)
                        .frame(width: 22, height: 22)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color(red: 147/255, green: 112/255, blue: 219/255).opacity(0.6) : Color.white.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.white.opacity(0.6) : Color.white.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Page Indicator
struct PageIndicator: View {
    let currentPage: Int
    let pageCount: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<pageCount, id: \.self) { page in
                Capsule()
                    .fill(page == currentPage ? Color.white : Color.white.opacity(0.4))
                    .frame(width: page == currentPage ? 20 : 8, height: 8)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
            }
        }
    }
}

// MARK: - Button Style
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
} 