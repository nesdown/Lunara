import SwiftUI
import Models

// Database model for dream articles
struct DreamArticle: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
    let link: String
    let category: ArticleCategory
    
    enum ArticleCategory: String, CaseIterable {
        case science = "Science"
        case techniques = "Techniques"
        case psychology = "Psychology"
        case symbols = "Symbols"
        case research = "Research"
    }
    
    static let allArticles: [DreamArticle] = [
        DreamArticle(
            icon: "moon.stars.fill",
            title: "Understanding REM Sleep",
            description: "Learn how REM sleep affects dreaming and memory consolidation",
            link: "https://example.com/rem-sleep",
            category: .science
        ),
        DreamArticle(
            icon: "brain.head.profile",
            title: "The Science of Nightmares",
            description: "Explore the psychological and neurological causes of nightmares",
            link: "https://example.com/nightmares",
            category: .psychology
        ),
        DreamArticle(
            icon: "bed.double.fill",
            title: "Dream Journaling Methods",
            description: "Effective techniques to record and remember your dreams",
            link: "https://example.com/dream-journaling",
            category: .techniques
        ),
        DreamArticle(
            icon: "sparkles",
            title: "Lucid Dreaming for Beginners",
            description: "Simple steps to start controlling your dreams consciously",
            link: "https://example.com/lucid-dreaming-basics",
            category: .techniques
        ),
        DreamArticle(
            icon: "figure.mind.and.body",
            title: "Dreams and Emotional Healing",
            description: "How dreams can help process emotions and support mental health",
            link: "https://example.com/emotional-healing",
            category: .psychology
        ),
        DreamArticle(
            icon: "eye.fill",
            title: "Dream Symbols Across Cultures",
            description: "Comparative study of dream interpretation in different societies",
            link: "https://example.com/cultural-symbols",
            category: .symbols
        ),
        DreamArticle(
            icon: "clock.fill",
            title: "Circadian Rhythms and Dreams",
            description: "The relationship between your body clock and dream patterns",
            link: "https://example.com/circadian-rhythms",
            category: .science
        ),
        DreamArticle(
            icon: "book.closed.fill",
            title: "Famous Dream Theories",
            description: "Exploring theories from Freud, Jung, and modern neuroscience",
            link: "https://example.com/dream-theories",
            category: .psychology
        ),
        DreamArticle(
            icon: "waveform.path.ecg",
            title: "Sleep Disorders and Dreaming",
            description: "How various sleep disorders affect dream experiences",
            link: "https://example.com/sleep-disorders",
            category: .science
        ),
        DreamArticle(
            icon: "gear.badge",
            title: "Technology and Dream Research",
            description: "Modern tools and apps that help study and enhance dreams",
            link: "https://example.com/dream-technology",
            category: .research
        )
    ]
}

struct LearnCard: View {
    let icon: String
    let title: String
    let description: String
    let buttonTitle: String
    let isPrimary: Bool
    let isAlternate: Bool
    let action: () -> Void
    
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 16) {
                // Left part - Icon
                ZStack {
                    Circle()
                        .fill(lightPurple)
                        .frame(width: 70, height: 70)
                    Image(systemName: icon)
                        .font(.system(size: 28))
                        .foregroundColor(primaryPurple)
                }
                
                // Right part - Text
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineSpacing(2)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            
            Divider()
                .background(lightPurple)
                .padding(.horizontal, 16)
            
            // Action Button
            Button(action: action) {
                HStack(spacing: 8) {
                    Image(systemName: isPrimary ? "play.circle.fill" : "sparkles")
                        .font(.system(size: 16, weight: .semibold))
                    Text(buttonTitle)
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
                .fill(isAlternate ? lightPurple : .white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .strokeBorder(lightPurple, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 4)
    }
}

struct SymbolOfTheDay: View {
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    
    var body: some View {
        VStack(spacing: 16) {
            Text("SYMBOL OF THE DAY")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            ZStack {
                Circle()
                    .fill(lightPurple)
                    .frame(width: 120, height: 120)
                
                Image(systemName: "questionmark")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(primaryPurple)
            }
            .padding(.vertical, 8)
            
            Text("Question Mark")
                .font(.title3)
                .fontWeight(.semibold)
            
            Text("A symbol of mystery and the unknown in dreams")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
            
            Button(action: {
                // Show more details
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 16, weight: .semibold))
                    Text("SHOW MORE")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(primaryPurple)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .strokeBorder(primaryPurple, lineWidth: 1)
                )
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .strokeBorder(lightPurple, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 4)
    }
}

struct ArticleOfTheDay: View {
    let article: DreamArticle
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 16) {
            Text("ARTICLE OF THE DAY")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(DynamicColors.textSecondary)
            
            ZStack {
                Circle()
                    .fill(DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.3 : 1.0))
                    .frame(width: 120, height: 120)
                
                Image(systemName: article.icon)
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(DynamicColors.primaryPurple)
            }
            .padding(.vertical, 8)
            
            Text(article.title)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(DynamicColors.textPrimary)
                .multilineTextAlignment(.center)
            
            Text(article.description)
                .font(.subheadline)
                .foregroundColor(DynamicColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
            
            Button(action: {
                if let url = URL(string: article.link) {
                    UIApplication.shared.open(url)
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "book.fill")
                        .font(.system(size: 16, weight: .semibold))
                    Text("READ MORE")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(DynamicColors.primaryPurple)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .strokeBorder(DynamicColors.primaryPurple, lineWidth: 1)
                )
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .padding(.vertical, 16)
        .modifier(CardStyle())
    }
}

// MARK: - LucidDreamingLessonTile
struct LucidDreamingLessonTile: View {
    @Environment(\.colorScheme) var colorScheme
    var onButtonTap: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text("LUCID DREAMING LESSON")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(DynamicColors.textSecondary)
            
            ZStack {
                Circle()
                    .fill(DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.3 : 1.0))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "graduationcap.fill")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(DynamicColors.primaryPurple)
            }
            .padding(.vertical, 8)
            
            Text("Master Lucid Dreaming")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(DynamicColors.textPrimary)
                .multilineTextAlignment(.center)
            
            Text("Generate a unique lesson to improve your lucid dreaming skills")
                .font(.subheadline)
                .foregroundColor(DynamicColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
            
            Button(action: {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                onButtonTap()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 16, weight: .semibold))
                    Text("GET LESSON")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(DynamicColors.primaryPurple)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .strokeBorder(DynamicColors.primaryPurple, lineWidth: 1)
                )
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .padding(.vertical, 16)
        .modifier(CardStyle())
    }
}

// MARK: - DailyDreamFactTile
struct DailyDreamFactTile: View {
    @Environment(\.colorScheme) var colorScheme
    var onButtonTap: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text("DAILY DREAM FACT")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(DynamicColors.textSecondary)
            
            ZStack {
                Circle()
                    .fill(DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.3 : 1.0))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(DynamicColors.primaryPurple)
            }
            .padding(.vertical, 8)
            
            Text("Did You Know?")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(DynamicColors.textPrimary)
                .multilineTextAlignment(.center)
            
            Text("Discover a fascinating fact about dreams and sleep science")
                .font(.subheadline)
                .foregroundColor(DynamicColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
            
            Button(action: {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                onButtonTap()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 16, weight: .semibold))
                    Text("LEARN FACT")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(DynamicColors.primaryPurple)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .strokeBorder(DynamicColors.primaryPurple, lineWidth: 1)
                )
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .padding(.vertical, 16)
        .modifier(CardStyle())
    }
}

// MARK: - LucidDreamingLessonDetailView
struct LucidDreamingLessonDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var lesson: DreamContent?
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var loadingTips = [
        "Reality checks help you recognize when you're dreaming",
        "Writing down dreams improves your dream recall",
        "Lucid dreamers can solve problems during sleep",
        "Sleep paralysis is a common entry point to lucid dreaming",
        "Most lucid dreams occur during REM sleep",
        "Visualization before sleep can trigger lucid dreams"
    ]
    @State private var currentTipIndex = 0
    @State private var loadingProgress = 0.0
    @State private var rotationDegrees = 0.0
    @State private var pulseEffect = false
    @State private var tipOpacity = 1.0
    @State private var contentOpacity = 0.0
    @State private var appearAnimation = false
    let timer = Timer.publish(every: 2.5, on: .main, in: .common).autoconnect()
    let progressTimer = Timer.publish(every: 0.15, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // Enhanced background with gradient overlay
            DynamicColors.backgroundPrimary.edgesIgnoringSafeArea(.all)
            
            // Decorative elements for visual interest
            VStack {
                if !isLoading && lesson != nil {
                    Circle()
                        .fill(DynamicColors.primaryPurple.opacity(0.05))
                        .frame(width: 300, height: 300)
                        .offset(x: 150, y: -50)
                        .blur(radius: 70)
                    
                    Circle()
                        .fill(DynamicColors.lightPurple.opacity(0.08))
                        .frame(width: 250, height: 250)
                        .offset(x: -150, y: 300)
                        .blur(radius: 60)
                }
                
                Spacer()
            }
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Top navigation bar with enhanced styling
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(DynamicColors.primaryPurple)
                            .padding(10)
                            .background(
                                Circle()
                                    .fill(DynamicColors.primaryPurple.opacity(0.1))
                            )
                    }
                    
                    Spacer()
                    
                    Text("Lucid Dreaming Lesson")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(DynamicColors.textPrimary)
                    
                    Spacer()
                    
                    Button(action: {
                        // Regenerate lesson with haptic feedback
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        generateNewLesson()
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(DynamicColors.primaryPurple)
                            .padding(10)
                            .background(
                                Circle()
                                    .fill(DynamicColors.primaryPurple.opacity(0.1))
                            )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                
                Divider()
                    .background(DynamicColors.primaryPurple.opacity(0.1))
                
                // Lesson content with improved layout
                ScrollView {
                    VStack(spacing: 24) {
                        if isLoading {
                            VStack(spacing: 32) {
                                // Animated loading icon
                                ZStack {
                                    // Outer pulsing circle
                                    Circle()
                                        .fill(DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.3 : 0.7))
                                        .frame(width: 120, height: 120)
                                        .scaleEffect(pulseEffect ? 1.1 : 0.95)
                                        .animation(
                                            Animation.easeInOut(duration: 1.5)
                                                .repeatForever(autoreverses: true),
                                            value: pulseEffect
                                        )
                                    
                                    // Inner rotating circle
                                    Circle()
                                        .fill(DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.2 : 0.4))
                                        .frame(width: 100, height: 100)
                                        .rotationEffect(.degrees(rotationDegrees))
                                    
                                    VStack(spacing: 8) {
                                        Image(systemName: "graduationcap.fill")
                                            .font(.system(size: 40))
                                            .foregroundColor(DynamicColors.primaryPurple)
                                            .rotationEffect(.degrees(isLoading ? 10 : -10))
                                            .animation(
                                                Animation.easeInOut(duration: 1.0)
                                                    .repeatForever(autoreverses: true),
                                                value: isLoading
                                            )
                                            .shadow(color: DynamicColors.primaryPurple.opacity(0.5), radius: 10, x: 0, y: 0)
                                        
                                        // Animated progress dots
                                        HStack(spacing: 4) {
                                            ForEach(0..<3) { index in
                                                Circle()
                                                    .fill(DynamicColors.primaryPurple)
                                                    .frame(width: 6, height: 6)
                                                    .opacity(currentTipIndex % 3 == index ? 1 : 0.3)
                                                    .animation(.easeInOut, value: currentTipIndex)
                                            }
                                        }
                                    }
                                }
                                .padding(.top, 40)
                                
                                Text("Creating your lesson...")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(DynamicColors.textPrimary)
                                    .multilineTextAlignment(.center)
                                
                                // Progress bar
                                ProgressView(value: loadingProgress)
                                    .progressViewStyle(LinearProgressViewStyle(tint: DynamicColors.primaryPurple))
                                    .frame(width: 200)
                                
                                // Rotating tips with smooth transition
                                VStack(spacing: 12) {
                                    Text("Did you know?")
                                        .font(.headline)
                                        .foregroundColor(DynamicColors.primaryPurple)
                                    
                                    Text(loadingTips[currentTipIndex])
                                        .font(.body)
                                        .foregroundColor(DynamicColors.textSecondary)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 32)
                                        .opacity(tipOpacity)
                                        .id(currentTipIndex) // Forces view refresh on change
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(DynamicColors.backgroundSecondary)
                                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                                )
                                .padding(.horizontal, 24)
                                
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 20)
                            .padding(.bottom, 100) // Added extra padding at bottom
                            .onAppear {
                                // Start animations
                                pulseEffect = true
                                withAnimation(Animation.linear(duration: 20).repeatForever(autoreverses: false)) {
                                    rotationDegrees = 360
                                }
                                
                                // Random starting tip
                                currentTipIndex = Int.random(in: 0..<loadingTips.count)
                            }
                            .onReceive(timer) { _ in
                                // Fade out current tip
                                withAnimation(.easeOut(duration: 0.5)) {
                                    tipOpacity = 0
                                }
                                
                                // Wait for fade out, then change tip and fade in
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    currentTipIndex = (currentTipIndex + 1) % loadingTips.count
                                    withAnimation(.easeIn(duration: 0.5)) {
                                        tipOpacity = 1
                                    }
                                }
                            }
                            .onReceive(progressTimer) { _ in
                                if loadingProgress < 0.95 {
                                    // Random increments to make it look more natural
                                    loadingProgress += Double.random(in: 0.003...0.01)
                                }
                            }
                        } else if let errorMessage = errorMessage {
                            VStack(spacing: 24) {
                                ZStack {
                                    Circle()
                                        .fill(DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.3 : 1.0))
                                        .frame(width: 120, height: 120)
                                    
                                    Image(systemName: "exclamationmark.triangle")
                                        .font(.system(size: 60))
                                        .foregroundColor(DynamicColors.primaryPurple)
                                }
                                .padding(.top, 60)
                                
                                Text("Unable to Generate Lesson")
                                    .font(.title3)
                                    .foregroundColor(DynamicColors.textPrimary)
                                    .multilineTextAlignment(.center)
                                
                                Text(errorMessage)
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 32)
                                
                                Button(action: {
                                    generateNewLesson()
                                }) {
                                    Text("Try Again")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 32)
                                        .padding(.vertical, 12)
                                        .background(DynamicColors.primaryPurple)
                                        .cornerRadius(24)
                                }
                                .padding(.top, 16)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 60)
                            .padding(.bottom, 100) // Added extra padding at bottom
                            .transition(.opacity.combined(with: .scale(scale: 0.95)))
                        } else if let lesson = lesson {
                            // Improved content layout with animations and better styling
                            VStack(alignment: .leading, spacing: 28) {
                                // Banner header section with enhanced visual styling
                                VStack(alignment: .center, spacing: 20) {
                                    ZStack {
                                        Circle()
                                            .fill(DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.3 : 1.0))
                                            .frame(width: 100, height: 100)
                                            .shadow(color: DynamicColors.primaryPurple.opacity(0.2), radius: 10, x: 0, y: 0)
                                        
                                        Image(systemName: "graduationcap.fill")
                                            .font(.system(size: 50))
                                            .foregroundColor(DynamicColors.primaryPurple)
                                            .offset(y: appearAnimation ? 0 : 5)
                                            .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.1), value: appearAnimation)
                                    }
                                    .offset(y: appearAnimation ? 0 : -10)
                                    .animation(.spring(response: 0.6, dampingFraction: 0.6), value: appearAnimation)
                                    
                                    VStack(spacing: 8) {
                                        Text(lesson.title)
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(DynamicColors.textPrimary)
                                            .multilineTextAlignment(.center)
                                            .fixedSize(horizontal: false, vertical: true)
                                            .padding(.horizontal)
                                            .offset(y: appearAnimation ? 0 : 10)
                                            .opacity(appearAnimation ? 1 : 0)
                                            .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.2), value: appearAnimation)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.top, 16)
                                .padding(.bottom, 10)
                                
                                // Introduction card with enhanced styling
                                VStack(alignment: .leading, spacing: 0) {
                                    ZStack(alignment: .leading) {
                                        Rectangle()
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [
                                                        DynamicColors.primaryPurple.opacity(0.9),
                                                        DynamicColors.primaryPurple.opacity(0.7)
                                                    ]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                        
                                        HStack {
                                            VStack(alignment: .leading, spacing: 8) {
                                                Text("INTRODUCTION")
                                                    .font(.caption)
                                                    .fontWeight(.bold)
                                                    .foregroundColor(.white.opacity(0.9))
                                                
                                                if let intro = lesson.introduction as String?, !intro.isEmpty {
                                                    Text(intro)
                                                        .font(.subheadline)
                                                        .foregroundColor(.white)
                                                        .fixedSize(horizontal: false, vertical: true)
                                                        .multilineTextAlignment(.leading)
                                                        .lineSpacing(4)
                                                } else {
                                                    Text("Learn essential techniques to recognize when you're dreaming and take control of your dream experience.")
                                                        .font(.subheadline)
                                                        .foregroundColor(.white)
                                                        .fixedSize(horizontal: false, vertical: true)
                                                        .multilineTextAlignment(.leading)
                                                        .lineSpacing(4)
                                                }
                                            }
                                            .padding(.vertical, 16)
                                            .padding(.horizontal, 20)
                                            
                                            Spacer()
                                        }
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                                    
                                    // Remove the full introduction content section and proceed to the lesson sections
                                }
                                .offset(y: appearAnimation ? 0 : 20)
                                .opacity(appearAnimation ? 1 : 0)
                                .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.3), value: appearAnimation)
                                
                                // Lesson sections with improved styling and animations
                                if !lesson.sections.isEmpty {
                                    Text("KEY TECHNIQUES")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundColor(DynamicColors.primaryPurple)
                                        .padding(.top, 16)
                                        .padding(.bottom, 8)
                                        .offset(y: appearAnimation ? 0 : 20)
                                        .opacity(appearAnimation ? 1 : 0)
                                        .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.4), value: appearAnimation)
                                    
                                    ForEach(Array(lesson.sections.enumerated()), id: \.element.id) { index, section in
                                        HStack(alignment: .top, spacing: 16) {
                                            // Circle with number
                                            ZStack {
                                                Circle()
                                                    .fill(DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.3 : 1.0))
                                                    .frame(width: 40, height: 40)
                                                
                                                Text("\(index + 1)")
                                                    .font(.headline)
                                                    .foregroundColor(DynamicColors.primaryPurple)
                                            }
                                            
                                            VStack(alignment: .leading, spacing: 8) {
                                                // Section title
                                                Text(section.heading.replacingOccurrences(of: #"^\d+\.\s*"#, with: "", options: .regularExpression))
                                                    .font(.headline)
                                                    .foregroundColor(DynamicColors.textPrimary)
                                                
                                                // Section content
                                                Text(section.content)
                                                    .font(.body)
                                                    .foregroundColor(DynamicColors.textSecondary)
                                                    .fixedSize(horizontal: false, vertical: true)
                                            }
                                        }
                                        .padding(16)
                                        .background(DynamicColors.backgroundSecondary)
                                        .cornerRadius(16)
                                        .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 4)
                                        .offset(y: appearAnimation ? 0 : 30)
                                        .opacity(appearAnimation ? 1 : 0)
                                        .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.4 + Double(index) * 0.1), value: appearAnimation)
                                    }
                                } else {
                                    Text("KEY TECHNIQUES")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundColor(DynamicColors.primaryPurple)
                                        .padding(.top, 16)
                                        .padding(.bottom, 8)
                                    
                                    // Default section if none provided
                                    HStack(alignment: .top, spacing: 16) {
                                        ZStack {
                                            Circle()
                                                .fill(DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.3 : 1.0))
                                                .frame(width: 40, height: 40)
                                            
                                            Text("1")
                                                .font(.headline)
                                                .foregroundColor(DynamicColors.primaryPurple)
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("Reality Checks")
                                                .font(.headline)
                                                .foregroundColor(DynamicColors.textPrimary)
                                            
                                            Text("Perform reality checks throughout the day, such as looking at your hands, checking text, or pushing your finger against your palm. These habits will carry into your dreams, helping you realize when you're dreaming.")
                                                .font(.body)
                                                .foregroundColor(DynamicColors.textSecondary)
                                                .fixedSize(horizontal: false, vertical: true)
                                        }
                                    }
                                    .padding(16)
                                    .background(DynamicColors.backgroundSecondary)
                                    .cornerRadius(16)
                                    .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 4)
                                }
                                
                                // Conclusion with more appealing visual styling
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("TAKEAWAY")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(DynamicColors.primaryPurple)
                                        .padding(.bottom, 4)
                                    
                                    Text(lesson.conclusion)
                                        .font(.body)
                                        .italic()
                                        .foregroundColor(DynamicColors.textPrimary)
                                        .lineSpacing(6)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .padding(20)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.3 : 0.5),
                                                    DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.1 : 0.2)
                                                ]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
                                )
                                .opacity(appearAnimation ? 1 : 0)
                                .offset(y: appearAnimation ? 0 : 20)
                                .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.8), value: appearAnimation)
                                
                                // Practice suggestion card
                                VStack(alignment: .leading, spacing: 16) {
                                    HStack {
                                        Image(systemName: "moon.stars.fill")
                                            .foregroundColor(DynamicColors.primaryPurple)
                                        
                                        Text("Practice Tonight")
                                            .font(.headline)
                                            .foregroundColor(DynamicColors.primaryPurple)
                                    }
                                    
                                    Text("Set an intention to remember your dreams tonight and try the techniques you've learned. Keep a dream journal by your bed to record your experiences when you wake up.")
                                        .font(.subheadline)
                                        .foregroundColor(DynamicColors.textSecondary)
                                        .lineSpacing(4)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .padding(20)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(DynamicColors.primaryPurple.opacity(0.3), lineWidth: 1)
                                        .background(
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(colorScheme == .dark ? Color(UIColor.systemGray6) : .white)
                                        )
                                        .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 3)
                                )
                                .opacity(appearAnimation ? 1 : 0)
                                .offset(y: appearAnimation ? 0 : 20)
                                .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.9), value: appearAnimation)
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 120) // Increased bottom padding to avoid cropping
                            .opacity(contentOpacity)
                            .onAppear {
                                withAnimation(.easeIn(duration: 0.5)) {
                                    contentOpacity = 1.0
                                }
                                
                                // Trigger staged animations
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    appearAnimation = true
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            generateNewLesson()
        }
    }
    
    private func generateNewLesson() {
        withAnimation(.easeOut(duration: 0.3)) {
            isLoading = true
            contentOpacity = 0
            appearAnimation = false
        }
        errorMessage = nil
        loadingProgress = 0.0
        tipOpacity = 1.0
        
        print("🧠 Starting to generate lucid dreaming lesson...")
        
        Task {
            do {
                let service = OpenAIService()
                print("🧠 Calling generateLucidDreamingLesson()...")
                let newLesson = try await service.generateLucidDreamingLesson()
                print("✅ Successfully generated lesson: \(newLesson.title)")
                
                DispatchQueue.main.async {
                    self.loadingProgress = 1.0
                    
                    // Add a slight delay before showing content for smooth transition
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.lesson = newLesson
                        
                        withAnimation(.easeOut(duration: 0.5)) {
                            self.isLoading = false
                        }
                        
                        // Add haptic feedback for success
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    }
                }
            } catch {
                print("❌ Error generating lesson: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    withAnimation(.easeOut(duration: 0.5)) {
                        self.errorMessage = error.localizedDescription
                        self.isLoading = false
                    }
                    
                    // Add haptic feedback for error
                    UINotificationFeedbackGenerator().notificationOccurred(.error)
                }
            }
        }
    }
}

// MARK: - DailyDreamFactDetailView
struct DailyDreamFactDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var dreamFact: DreamContent?
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var loadingFacts = [
        "The average person has 3-5 dreams per night",
        "Dreams typically last between 5-20 minutes",
        "Everyone dreams, even those who don't remember them",
        "We forget 95% of our dreams shortly after waking",
        "Blind people dream with other senses besides vision",
        "You can't read or tell time accurately in dreams"
    ]
    @State private var currentFactIndex = 0
    @State private var loadingProgress = 0.0
    @State private var glowIntensity = 0.0
    @State private var pulseScale = 1.0
    @State private var factOpacity = 1.0
    @State private var contentOpacity = 0.0
    @State private var rotateBulb = false
    @State private var appearAnimation = false
    let timer = Timer.publish(every: 2.5, on: .main, in: .common).autoconnect()
    let progressTimer = Timer.publish(every: 0.15, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // Enhanced background with gradient overlay
            DynamicColors.backgroundPrimary.edgesIgnoringSafeArea(.all)
            
            // Decorative elements for visual interest
            VStack {
                if !isLoading && dreamFact != nil {
                    Circle()
                        .fill(DynamicColors.primaryPurple.opacity(0.05))
                        .frame(width: 300, height: 300)
                        .offset(x: -150, y: -50)
                        .blur(radius: 70)
                    
                    Circle()
                        .fill(DynamicColors.lightPurple.opacity(0.08))
                        .frame(width: 250, height: 250)
                        .offset(x: 150, y: 300)
                        .blur(radius: 60)
                }
                
                Spacer()
            }
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Top navigation bar with enhanced styling
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(DynamicColors.primaryPurple)
                            .padding(10)
                            .background(
                                Circle()
                                    .fill(DynamicColors.primaryPurple.opacity(0.1))
                            )
                    }
                    
                    Spacer()
                    
                    Text("Daily Dream Fact")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(DynamicColors.textPrimary)
                    
                    Spacer()
                    
                    Button(action: {
                        // Regenerate fact with haptic feedback
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        generateNewFact()
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(DynamicColors.primaryPurple)
                            .padding(10)
                            .background(
                                Circle()
                                    .fill(DynamicColors.primaryPurple.opacity(0.1))
                            )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                
                Divider()
                    .background(DynamicColors.primaryPurple.opacity(0.1))
                
                // Fact content with improved layout
                ScrollView {
                    VStack(spacing: 24) {
                        if isLoading {
                            VStack(spacing: 32) {
                                // Animated loading icon with pulsing effect
                                ZStack {
                                    // Outer pulsing glow
                                    Circle()
                                        .fill(DynamicColors.primaryPurple.opacity(glowIntensity))
                                        .frame(width: 140, height: 140)
                                        .blur(radius: 20)
                                    
                                    // Pulsing background
                                    Circle()
                                        .fill(DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.4 : 0.8))
                                        .frame(width: 120, height: 120)
                                        .scaleEffect(pulseScale)
                                    
                                    // Main circle
                                    Circle()
                                        .fill(DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.3 : 1.0))
                                        .frame(width: 110, height: 110)
                                    
                                    // Light bulb icon
                                    Image(systemName: "lightbulb.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(DynamicColors.primaryPurple)
                                        .rotationEffect(.degrees(rotateBulb ? 10 : -10))
                                        .shadow(color: DynamicColors.primaryPurple.opacity(glowIntensity), radius: 10, x: 0, y: 0)
                                        .overlay(
                                            // Shining lines animation
                                            ZStack {
                                                ForEach(0..<8) { i in
                                                    Rectangle()
                                                        .fill(DynamicColors.primaryPurple)
                                                        .frame(width: 2, height: 12)
                                                        .offset(y: -30)
                                                        .rotationEffect(.degrees(Double(i) * 45))
                                                        .opacity(glowIntensity)
                                                }
                                            }
                                        )
                                }
                                .padding(.top, 40)
                                
                                Text("Discovering an interesting fact...")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(DynamicColors.textPrimary)
                                    .multilineTextAlignment(.center)
                                
                                // Progress bar with pulse animation
                                ZStack(alignment: .leading) {
                                    Rectangle()
                                        .fill(DynamicColors.primaryPurple.opacity(0.2))
                                        .frame(width: 200, height: 6)
                                        .cornerRadius(3)
                                    
                                    Rectangle()
                                        .fill(DynamicColors.primaryPurple)
                                        .frame(width: 200 * loadingProgress, height: 6)
                                        .cornerRadius(3)
                                }
                                
                                // Animated dots
                                HStack(spacing: 6) {
                                    ForEach(0..<3) { index in
                                        Circle()
                                            .fill(DynamicColors.primaryPurple)
                                            .frame(width: 8, height: 8)
                                            .scaleEffect(currentFactIndex % 3 == index ? 1.2 : 0.8)
                                            .opacity(currentFactIndex % 3 == index ? 1 : 0.5)
                                            .animation(.spring(), value: currentFactIndex)
                                    }
                                }
                                
                                // Rotating facts with fade transition
                                VStack(spacing: 12) {
                                    Text("While you wait...")
                                        .font(.headline)
                                        .foregroundColor(DynamicColors.primaryPurple)
                                    
                                    Text(loadingFacts[currentFactIndex])
                                        .font(.body)
                                        .foregroundColor(DynamicColors.textSecondary)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 32)
                                        .opacity(factOpacity)
                                        .id(currentFactIndex) // Forces view refresh on change
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(DynamicColors.backgroundSecondary)
                                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                                )
                                .padding(.horizontal, 24)
                                
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 20)
                            .padding(.bottom, 100) // Added extra padding at bottom
                            .onAppear {
                                // Start animations
                                withAnimation(Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                                    glowIntensity = 0.6
                                    pulseScale = 1.1
                                    rotateBulb = true
                                }
                                
                                // Random starting fact
                                currentFactIndex = Int.random(in: 0..<loadingFacts.count)
                            }
                            .onReceive(timer) { _ in
                                // Fade out current fact
                                withAnimation(.easeOut(duration: 0.5)) {
                                    factOpacity = 0
                                }
                                
                                // Wait for fade out, then change fact and fade in
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    currentFactIndex = (currentFactIndex + 1) % loadingFacts.count
                                    withAnimation(.easeIn(duration: 0.5)) {
                                        factOpacity = 1
                                    }
                                }
                            }
                            .onReceive(progressTimer) { _ in
                                if loadingProgress < 0.95 {
                                    // Random increments to make it look more natural
                                    loadingProgress += Double.random(in: 0.003...0.01)
                                }
                            }
                        } else if let errorMessage = errorMessage {
                            VStack(spacing: 24) {
                                ZStack {
                                    Circle()
                                        .fill(DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.3 : 1.0))
                                        .frame(width: 120, height: 120)
                                    
                                    Image(systemName: "exclamationmark.triangle")
                                        .font(.system(size: 60))
                                        .foregroundColor(DynamicColors.primaryPurple)
                                }
                                .padding(.top, 60)
                                
                                Text("Unable to Generate Fact")
                                    .font(.title3)
                                    .foregroundColor(DynamicColors.textPrimary)
                                    .multilineTextAlignment(.center)
                                
                                Text(errorMessage)
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 32)
                                
                                Button(action: {
                                    generateNewFact()
                                }) {
                                    Text("Try Again")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 32)
                                        .padding(.vertical, 12)
                                        .background(DynamicColors.primaryPurple)
                                        .cornerRadius(24)
                                }
                                .padding(.top, 16)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 60)
                            .padding(.bottom, 100) // Added extra padding at bottom
                            .transition(.opacity.combined(with: .scale(scale: 0.95)))
                        } else if let fact = dreamFact {
                            // Improved content layout with animations and better styling
                            VStack(alignment: .leading, spacing: 28) {
                                // Banner header section with enhanced styling
                                VStack(alignment: .center, spacing: 20) {
                                    ZStack {
                                        Circle()
                                            .fill(DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.3 : 1.0))
                                            .frame(width: 100, height: 100)
                                            .shadow(color: DynamicColors.primaryPurple.opacity(0.2), radius: 10, x: 0, y: 0)
                                        
                                        Image(systemName: "lightbulb.fill")
                                            .font(.system(size: 50))
                                            .foregroundColor(DynamicColors.primaryPurple)
                                            .offset(y: appearAnimation ? 0 : 5)
                                            .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.1), value: appearAnimation)
                                    }
                                    .offset(y: appearAnimation ? 0 : -10)
                                    .animation(.spring(response: 0.6, dampingFraction: 0.6), value: appearAnimation)
                                    
                                    VStack(spacing: 8) {
                                        Text(fact.title)
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(DynamicColors.textPrimary)
                                            .multilineTextAlignment(.center)
                                            .fixedSize(horizontal: false, vertical: true)
                                            .padding(.horizontal)
                                            .offset(y: appearAnimation ? 0 : 10)
                                            .opacity(appearAnimation ? 1 : 0)
                                            .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.2), value: appearAnimation)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.top, 16)
                                .padding(.bottom, 10)
                                
                                // Introduction banner with enhanced styling
                                VStack(alignment: .leading, spacing: 0) {
                                    ZStack(alignment: .leading) {
                                        Rectangle()
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [
                                                        DynamicColors.primaryPurple.opacity(0.9),
                                                        DynamicColors.primaryPurple.opacity(0.7)
                                                    ]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                        
                                        HStack {
                                            VStack(alignment: .leading, spacing: 8) {
                                                Text("DID YOU KNOW?")
                                                    .font(.caption)
                                                    .fontWeight(.bold)
                                                    .foregroundColor(.white.opacity(0.9))
                                                
                                                if let intro = fact.introduction as String?, !intro.isEmpty {
                                                    Text(intro)
                                                        .font(.subheadline)
                                                        .foregroundColor(.white)
                                                        .fixedSize(horizontal: false, vertical: true)
                                                        .multilineTextAlignment(.leading)
                                                        .lineSpacing(4)
                                                } else {
                                                    Text("Dreams are a fascinating window into our subconscious mind, revealing hidden thoughts, emotions, and creativity while we sleep.")
                                                        .font(.subheadline)
                                                        .foregroundColor(.white)
                                                        .fixedSize(horizontal: false, vertical: true)
                                                        .multilineTextAlignment(.leading)
                                                        .lineSpacing(4)
                                                }
                                            }
                                            .padding(.vertical, 16)
                                            .padding(.horizontal, 20)
                                            
                                            Spacer()
                                        }
                                    }
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .shadow(color: DynamicColors.primaryPurple.opacity(0.3), radius: 15, x: 0, y: 5)
                                
                                // Remove the full introduction content section
                                
                                // Section divider
                                HStack {
                                    Text("THE SCIENCE")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(DynamicColors.primaryPurple)
                                    
                                    Spacer()
                                    
                                    Rectangle()
                                        .fill(DynamicColors.primaryPurple.opacity(0.2))
                                        .frame(height: 1)
                                        .frame(maxWidth: .infinity)
                                }
                                .opacity(appearAnimation ? 1 : 0)
                                .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.4), value: appearAnimation)
                                
                                // Sections with enhanced styling and animations
                                ForEach(Array(fact.sections.enumerated()), id: \.element.id) { index, section in
                                    HStack(alignment: .top, spacing: 16) {
                                        // Circle with number
                                        ZStack {
                                            Circle()
                                                .fill(DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.3 : 1.0))
                                                .frame(width: 40, height: 40)
                                            
                                            Text("\(index + 1)")
                                                .font(.headline)
                                                .foregroundColor(DynamicColors.primaryPurple)
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 8) {
                                            // Section title (remove any numeric prefixes)
                                            Text(section.heading.replacingOccurrences(of: #"^\d+\.\s*"#, with: "", options: .regularExpression))
                                                .font(.headline)
                                                .foregroundColor(DynamicColors.textPrimary)
                                            
                                            // Section content
                                            Text(section.content)
                                                .font(.body)
                                                .foregroundColor(DynamicColors.textSecondary)
                                                .fixedSize(horizontal: false, vertical: true)
                                        }
                                    }
                                    .padding(16)
                                    .background(DynamicColors.backgroundSecondary)
                                    .cornerRadius(16)
                                    .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 4)
                                    .opacity(appearAnimation ? 1 : 0)
                                    .offset(y: appearAnimation ? 0 : 20)
                                    .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.5 + Double(index) * 0.1), value: appearAnimation)
                                }
                                
                                // Conclusion with enhanced styling
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("THINK ABOUT IT")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(DynamicColors.primaryPurple)
                                        .padding(.bottom, 4)
                                    
                                    Text(fact.conclusion)
                                        .font(.body)
                                        .italic()
                                        .foregroundColor(DynamicColors.textPrimary)
                                        .lineSpacing(6)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .padding(20)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.3 : 0.5),
                                                    DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.1 : 0.2)
                                                ]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
                                )
                                .opacity(appearAnimation ? 1 : 0)
                                .offset(y: appearAnimation ? 0 : 20)
                                .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.7), value: appearAnimation)
                                
                                // Share button
                                Button(action: {
                                    // Share functionality
                                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                    
                                    // Create share content
                                    let shareText = "Did you know? \(fact.introduction)\n\nLearn more about dreams with Lunara app!"
                                    let shareContent = [shareText]
                                    
                                    // Create activity view controller
                                    let activityViewController = UIActivityViewController(
                                        activityItems: shareContent,
                                        applicationActivities: nil
                                    )
                                    
                                    // Present the activity view controller
                                    UIApplication.shared.windows.first?.rootViewController?.present(
                                        activityViewController,
                                        animated: true,
                                        completion: nil
                                    )
                                }) {
                                    HStack {
                                        Image(systemName: "square.and.arrow.up")
                                            .font(.headline)
                                        Text("Share This Fact")
                                            .font(.headline)
                                    }
                                    .foregroundColor(DynamicColors.primaryPurple)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(DynamicColors.primaryPurple, lineWidth: 1.5)
                                            .background(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .fill(colorScheme == .dark ? Color(UIColor.systemGray6) : .white)
                                            )
                                    )
                                }
                                .padding(.top, 8)
                                .opacity(appearAnimation ? 1 : 0)
                                .offset(y: appearAnimation ? 0 : 20)
                                .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.8), value: appearAnimation)
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 120) // Increased bottom padding to avoid cropping
                            .opacity(contentOpacity)
                            .onAppear {
                                withAnimation(.easeIn(duration: 0.5)) {
                                    contentOpacity = 1.0
                                }
                                
                                // Trigger staged animations
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    appearAnimation = true
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            generateNewFact()
        }
    }
    
    private func generateNewFact() {
        withAnimation(.easeOut(duration: 0.3)) {
            isLoading = true
            contentOpacity = 0
            appearAnimation = false
        }
        errorMessage = nil
        loadingProgress = 0.0
        factOpacity = 1.0
        
        print("💡 Starting to generate daily dream fact...")
        
        Task {
            do {
                let service = OpenAIService()
                print("💡 Calling generateDailyDreamFact()...")
                let newFact = try await service.generateDailyDreamFact()
                print("✅ Successfully generated fact: \(newFact.title)")
                
                DispatchQueue.main.async {
                    self.loadingProgress = 1.0
                    
                    // Add a slight delay before showing content for smooth transition
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.dreamFact = newFact
                        
                        withAnimation(.easeOut(duration: 0.5)) {
                            self.isLoading = false
                        }
                        
                        // Add haptic feedback for success
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    }
                }
            } catch {
                print("❌ Error generating fact: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    withAnimation(.easeOut(duration: 0.5)) {
                        self.errorMessage = error.localizedDescription
                        self.isLoading = false
                    }
                    
                    // Add haptic feedback for error
                    UINotificationFeedbackGenerator().notificationOccurred(.error)
                }
            }
        }
    }
}

struct EncyclopediaItem: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    
    var body: some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: 16) {
                // Left part - Icon
                ZStack {
                    Circle()
                        .fill(lightPurple)
                        .frame(width: 50, height: 50)
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(primaryPurple)
                }
                
                // Right part - Text
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                    Text(subtitle.trimmingCharacters(in: .whitespacesAndNewlines))
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing, 8)
                
                Spacer(minLength: 0)
            }
            .frame(width: 250)
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(lightPurple, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 4)
        }
    }
}

struct ArticleCatalogView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @State private var searchText = ""
    @State private var selectedCategories: Set<DreamArticle.ArticleCategory> = []
    
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    
    let articles: [DreamArticle]
    
    private var filteredArticles: [DreamArticle] {
        articles.filter { article in
            // Filter by search text
            let matchesSearch = searchText.isEmpty || 
                article.title.localizedCaseInsensitiveContains(searchText) ||
                article.description.localizedCaseInsensitiveContains(searchText)
            
            // Filter by selected categories
            let matchesCategory = selectedCategories.isEmpty || selectedCategories.contains(article.category)
            
            return matchesSearch && matchesCategory
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField("Search articles...", text: $searchText)
                        .foregroundColor(DynamicColors.textPrimary)
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.bottom, 12)
                
                // Category filters
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(DreamArticle.ArticleCategory.allCases, id: \.self) { category in
                            CategoryFilterButton(
                                category: category,
                                isSelected: selectedCategories.contains(category),
                                action: {
                                    toggleCategory(category)
                                }
                            )
                        }
                        
                        if !selectedCategories.isEmpty {
                            Button(action: {
                                selectedCategories.removeAll()
                            }) {
                                Text("Clear")
                                    .foregroundColor(primaryPurple)
                                    .font(.system(size: 14, weight: .medium))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(primaryPurple, lineWidth: 1)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                }
                
                Divider()
                
                // Results count
                HStack {
                    if filteredArticles.isEmpty {
                        Text("No articles found")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    } else {
                        Text("\(filteredArticles.count) article\(filteredArticles.count == 1 ? "" : "s")")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                if filteredArticles.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                        Text("No matching articles found")
                            .font(.title3)
                            .fontWeight(.medium)
                        Text("Try adjusting your search or filters")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // Articles grid
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(filteredArticles) { article in
                                ArticleGridItem(article: article)
                            }
                        }
                        .padding(16)
                    }
                }
            }
            .navigationTitle("Dream Encyclopedia")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(primaryPurple)
                    }
                }
            }
        }
    }
    
    private func toggleCategory(_ category: DreamArticle.ArticleCategory) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
    }
}

struct CategoryFilterButton: View {
    let category: DreamArticle.ArticleCategory
    let isSelected: Bool
    let action: () -> Void
    
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    
    var body: some View {
        Button(action: action) {
            Text(category.rawValue)
                .font(.system(size: 14, weight: isSelected ? .semibold : .medium))
                .foregroundColor(isSelected ? .white : primaryPurple)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isSelected ? primaryPurple : Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(isSelected ? Color.clear : primaryPurple, lineWidth: 1)
                        )
                )
        }
    }
}

struct ArticleGridItem: View {
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    
    let article: DreamArticle
    
    var body: some View {
        Link(destination: URL(string: article.link)!) {
            VStack(alignment: .leading, spacing: 12) {
                // Header with icon and category
                HStack(alignment: .center) {
                    // Icon
                    ZStack {
                        Circle()
                            .fill(lightPurple)
                            .frame(width: 50, height: 50)
                        Image(systemName: article.icon)
                            .font(.system(size: 24))
                            .foregroundColor(DynamicColors.primaryPurple)
                    }
                    
                    Spacer()
                    
                    // Category tag
                    Text(article.category.rawValue)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(primaryPurple)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(lightPurple.opacity(0.7))
                        )
                }
                .padding(.top, 8)
                
                // Title
                Text(article.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
                    .padding(.top, 4)
                
                // Description
                Text(article.description.trimmingCharacters(in: .whitespacesAndNewlines))
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .padding(16)
            .frame(height: 180)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(UIColor.systemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(lightPurple, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 4)
        }
    }
}

struct LearnView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var showArticleCatalog = false
    @State private var showDailyRitual = false
    @State private var showLucidDreamingLesson = false
    @State private var showDreamFact = false
    @State private var searchText: String = ""
    @State private var selectedCategory: DreamArticle.ArticleCategory? = nil
    @State private var expandedArticle: UUID? = nil
    
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    private var filteredArticles: [DreamArticle] {
        var articles = DreamArticle.allArticles
        
        // Apply category filter if selected
        if let category = selectedCategory {
            articles = articles.filter { $0.category == category }
        }
        
        // Apply search text filter if not empty
        if !searchText.isEmpty {
            articles = articles.filter {
                $0.title.lowercased().contains(searchText.lowercased()) ||
                $0.description.lowercased().contains(searchText.lowercased())
            }
        }
        
        return articles
    }
    
    // Random article for the "Article of the Day" section
    private var articleOfTheDay: DreamArticle {
        DreamArticle.allArticles.randomElement() ?? DreamArticle.allArticles[0]
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                DynamicColors.backgroundPrimary.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Header section with title - fixed at top
                    TopBarView(
                        title: "Learn",
                        primaryPurple: DynamicColors.primaryPurple,
                        colorScheme: colorScheme,
                        rightButtons: [
                            TopBarButton(icon: "questionmark.circle", action: {
                                if let url = URL(string: "https://multumgrp.tech/lunara-help") {
                                    UIApplication.shared.open(url)
                                }
                            })
                        ]
                    )
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            // Search Bar
                            searchBar
                                .padding(.horizontal, 16)
                                .padding(.top, 16)
                            
                            // Category Filters
                            categoryFilters
                                .padding(.horizontal, 16)
                            
                            // Lucid Dreaming Lesson Tile
                            NavigationLink(
                                destination: LucidDreamingLessonDetailView(),
                                isActive: $showLucidDreamingLesson
                            ) {
                                Button(action: {
                                    showLucidDreamingLesson = true
                                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                }) {
                                    LucidDreamingLessonTile(onButtonTap: {
                                        showLucidDreamingLesson = true
                                    })
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding(.horizontal, 16)
                            
                            // Daily Dream Fact Tile
                            NavigationLink(
                                destination: DailyDreamFactDetailView(),
                                isActive: $showDreamFact
                            ) {
                                Button(action: {
                                    showDreamFact = true
                                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                }) {
                                    DailyDreamFactTile(onButtonTap: {
                                        showDreamFact = true
                                    })
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding(.horizontal, 16)
                            
                            // Article of the Day
                            ArticleOfTheDay(article: articleOfTheDay)
                                .padding(.horizontal, 16)
                            
                            // Article Grid
                            articleGrid
                                .padding(.horizontal, 16)
                            
                            Spacer(minLength: 80)
                        }
                        .padding(.bottom, 24)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(DynamicColors.gray3)
            
            TextField("Search articles...", text: $searchText)
                .foregroundColor(DynamicColors.textPrimary)
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(DynamicColors.gray3)
                }
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(DynamicColors.backgroundSecondary)
        )
    }
    
    private var categoryFilters: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // All categories option
                CategoryPill(
                    name: "All",
                    isSelected: selectedCategory == nil,
                    action: { selectedCategory = nil }
                )
                
                // Individual category pills
                ForEach(DreamArticle.ArticleCategory.allCases, id: \.self) { category in
                    CategoryPill(
                        name: category.rawValue,
                        isSelected: selectedCategory == category,
                        action: {
                            selectedCategory = category
                        }
                    )
                }
            }
            .padding(.vertical, 8)
        }
    }
    
    private var articleGrid: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(filteredArticles) { article in
                ArticleCard(article: article)
            }
        }
    }
}

struct CategoryPill: View {
    let name: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(name)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : DynamicColors.primaryPurple)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? DynamicColors.primaryPurple : DynamicColors.primaryPurple.opacity(0.1))
                )
        }
    }
}

struct ArticleCard: View {
    let article: DreamArticle
    @State private var isPressed = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: {
            if let url = URL(string: article.link) {
                UIApplication.shared.open(url)
            }
        }) {
            VStack(alignment: .leading, spacing: 12) {
                // Icon
                ZStack {
                    Circle()
                        .fill(DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.3 : 1.0))
                        .frame(width: 50, height: 50)
                    Image(systemName: article.icon)
                        .font(.system(size: 24))
                        .foregroundColor(DynamicColors.primaryPurple)
                }
                
                // Title
                Text(article.title)
                    .font(.headline)
                    .foregroundColor(DynamicColors.textPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                // Category
                Text(article.category.rawValue)
                    .font(.caption)
                    .foregroundColor(DynamicColors.primaryPurple)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(DynamicColors.primaryPurple.opacity(0.1))
                    )
                
                Spacer()
            }
            .padding(16)
            .frame(height: 160)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(colorScheme == .dark ? Color(UIColor.systemGray6) : .white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(DynamicColors.primaryPurple.opacity(0.15), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
            .onLongPressGesture(minimumDuration: .infinity, maximumDistance: 50) {
                // Never triggered
            } onPressingChanged: { pressing in
                isPressed = pressing
            }
        }
    }
}

struct ArticleListItem: View {
    let article: DreamArticle
    
    var body: some View {
        VStack(spacing: 16) {
            // Header with icon and title
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.3 : 1.0))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: article.icon)
                        .font(.system(size: 24))
                        .foregroundColor(DynamicColors.primaryPurple)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(article.title)
                        .font(.headline)
                        .foregroundColor(DynamicColors.textPrimary)
                    
                    Text(article.category.rawValue)
                        .font(.subheadline)
                        .foregroundColor(DynamicColors.primaryPurple)
                }
                
                Spacer()
            }
            
            // Description
            Text(article.description)
                .font(.body)
                .foregroundColor(DynamicColors.textSecondary)
                .multilineTextAlignment(.leading)
            
            // Read More button
            Button(action: {
                if let url = URL(string: article.link) {
                    UIApplication.shared.open(url)
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 16, weight: .semibold))
                    Text("SHOW MORE")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(DynamicColors.primaryPurple)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .strokeBorder(DynamicColors.primaryPurple, lineWidth: 1)
                )
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .padding(.vertical, 16)
        .modifier(CardStyle())
    }
    
    @Environment(\.colorScheme) var colorScheme
}

#Preview {
    LearnView()
} 