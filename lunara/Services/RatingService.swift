import SwiftUI
import StoreKit

class RatingService: ObservableObject {
    static let shared = RatingService()
    
    // Keys for UserDefaults
    private let firstLaunchDateKey = "firstLaunchDate"
    private let launchCountKey = "launchCount"
    private let lastRequestedReviewKey = "lastRequestedReview"
    private let totalReviewRequestsKey = "totalReviewRequests"
    private let customReviewRequestsKey = "customReviewRequests"
    private let hasRatedAppKey = "hasRatedApp"
    
    // State tracking
    @Published var showCustomRatingModal = false
    
    private init() {
        // On first init, set first launch date if not set
        if UserDefaults.standard.object(forKey: firstLaunchDateKey) == nil {
            UserDefaults.standard.set(Date(), forKey: firstLaunchDateKey)
            UserDefaults.standard.set(1, forKey: launchCountKey)
        } else {
            // Increment launch count
            let currentCount = UserDefaults.standard.integer(forKey: launchCountKey)
            UserDefaults.standard.set(currentCount + 1, forKey: launchCountKey)
        }
    }
    
    // Call this when app launches
    func checkAndRequestReview() {
        // Don't proceed if user has already rated the app
        if UserDefaults.standard.bool(forKey: hasRatedAppKey) {
            return
        }
        
        // Conditions for system review request
        let launchCount = UserDefaults.standard.integer(forKey: launchCountKey)
        let totalRequests = UserDefaults.standard.integer(forKey: totalReviewRequestsKey)
        let lastRequested = UserDefaults.standard.object(forKey: lastRequestedReviewKey) as? Date
        let firstLaunchDate = UserDefaults.standard.object(forKey: firstLaunchDateKey) as? Date ?? Date()
        
        let daysSinceFirstLaunch = Calendar.current.dateComponents([.day], from: firstLaunchDate, to: Date()).day ?? 0
        let daysSinceLastRequest = Calendar.current.dateComponents([.day], from: lastRequested ?? Date.distantPast, to: Date()).day ?? Int.max
        
        // Only proceed if we haven't requested too many times (max 3 system modals)
        guard totalRequests < 3 else {
            // If we've used up our system modals, maybe show our custom one
            checkAndShowCustomModal()
            return
        }
        
        // Wait at least 30 days between requests
        guard daysSinceLastRequest >= 30 else { return }
        
        // Check for specific conditions:
        // 1. After onboarding (handled in OnboardingFlow.swift directly)
        // 2. Second app launch
        // 3. First launch on second day
        
        if (launchCount == 2) || (daysSinceFirstLaunch == 1 && isDifferentDay(firstLaunchDate, Date())) {
            requestSystemReview()
        }
    }
    
    private func isDifferentDay(_ date1: Date, _ date2: Date) -> Bool {
        return !Calendar.current.isDate(date1, inSameDayAs: date2)
    }
    
    // Request system review (the iOS rating prompt)
    func requestSystemReview() {
        // Don't proceed if user has already rated the app
        if UserDefaults.standard.bool(forKey: hasRatedAppKey) {
            return
        }
        
        // Make sure we're on the main thread
        Task { @MainActor in
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if #available(iOS 18.0, *) {
                    StoreKit.AppStore.requestReview(in: scene)
                } else {
                    SKStoreReviewController.requestReview(in: scene)
                }
                
                // Update tracking
                UserDefaults.standard.set(Date(), forKey: lastRequestedReviewKey)
                let totalRequests = UserDefaults.standard.integer(forKey: totalReviewRequestsKey)
                UserDefaults.standard.set(totalRequests + 1, forKey: totalReviewRequestsKey)
            }
        }
    }
    
    // Check if we should show our custom modal
    private func checkAndShowCustomModal() {
        // Don't proceed if user has already rated the app
        if UserDefaults.standard.bool(forKey: hasRatedAppKey) {
            return
        }
        
        let customRequests = UserDefaults.standard.integer(forKey: customReviewRequestsKey)
        let lastRequested = UserDefaults.standard.object(forKey: lastRequestedReviewKey) as? Date
        let daysSinceLastRequest = Calendar.current.dateComponents([.day], from: lastRequested ?? Date.distantPast, to: Date()).day ?? Int.max
        
        // Don't show too frequently (max once per 60 days)
        guard customRequests < 5 && daysSinceLastRequest >= 60 else { return }
        
        // Only show after significant app usage
        let launchCount = UserDefaults.standard.integer(forKey: launchCountKey)
        if launchCount >= 5 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.showCustomRatingModal = true
            }
        }
    }
    
    // Log that custom rating was displayed
    func logCustomRatingDisplayed() {
        UserDefaults.standard.set(Date(), forKey: lastRequestedReviewKey)
        let customRequests = UserDefaults.standard.integer(forKey: customReviewRequestsKey)
        UserDefaults.standard.set(customRequests + 1, forKey: customReviewRequestsKey)
    }
    
    // Mark that the user has rated the app
    func markAppAsRated() {
        UserDefaults.standard.set(true, forKey: hasRatedAppKey)
    }
    
    // Check if the user has rated the app
    func hasUserRatedApp() -> Bool {
        return UserDefaults.standard.bool(forKey: hasRatedAppKey)
    }
    
    // Open App Store for review
    func openAppStoreRating() {
        let appID = "6463151340" // Lunara's App Store ID
        let urlString = "https://itunes.apple.com/app/id\(appID)?action=write-review"
        
        guard let url = URL(string: urlString) else { return }
        
        // Mark that the user has rated the app when they go to the App Store
        markAppAsRated()
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

// Custom rating modal with app-consistent design
struct CustomRatingView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var ratingService = RatingService.shared
    @Binding var isPresented: Bool
    @State private var starRating: Int = 0
    @State private var feedbackText: String = ""
    @State private var showThankYou: Bool = false
    @State private var buttonScale: CGFloat = 1.0
    
    // Custom colors - match with main app theme
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    private let darkPurple = Color(red: 102/255, green: 51/255, blue: 153/255)
    
    var body: some View {
        ZStack {
            // Background
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation {
                        isPresented = false
                    }
                }
            
            // Modal content
            VStack(spacing: 20) {
                // Top image
                Image(systemName: "star.sparkle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(primaryPurple)
                    .padding(.top, 30)
                
                if showThankYou {
                    // Thank you view
                    VStack(spacing: 12) {
                        Text("Thank you for your feedback!")
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Text("Your opinion helps us improve Lunara for everyone.")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                    
                    // Dismiss button
                    Button {
                        withAnimation {
                            isPresented = false
                        }
                    } label: {
                        Text("Close")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(primaryPurple)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 30)
                    
                } else {
                    // Rating view
                    VStack(spacing: 12) {
                        Text("Enjoying Lunara?")
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Text("We'd love to hear your thoughts. Your feedback helps us improve!")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .foregroundColor(.secondary)
                        
                        // Star rating
                        HStack(spacing: 12) {
                            ForEach(1...5, id: \.self) { star in
                                Image(systemName: star <= starRating ? "star.fill" : "star")
                                    .font(.system(size: 30))
                                    .foregroundColor(star <= starRating ? primaryPurple : .gray)
                                    .onTapGesture {
                                        starRating = star
                                        HapticManager.shared.selection()
                                    }
                            }
                        }
                        .padding(.top, 10)
                    }
                    .padding(.horizontal, 20)
                    
                    // Buttons
                    VStack(spacing: 12) {
                        Button {
                            HapticManager.shared.buttonPress()
                            
                            // Animate button
                            withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                                buttonScale = 0.95
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                                    buttonScale = 1.02
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    withAnimation {
                                        buttonScale = 1.0
                                    }
                                    
                                    // Log that we showed the custom rating
                                    ratingService.logCustomRatingDisplayed()
                                    
                                    // Open App Store if they gave 4-5 stars
                                    if starRating >= 4 {
                                        // Mark as rated and open the App Store
                                        ratingService.markAppAsRated()
                                        ratingService.openAppStoreRating()
                                        isPresented = false
                                    } else if starRating > 0 {
                                        // Show thank you for lower ratings
                                        withAnimation {
                                            showThankYou = true
                                        }
                                    } else {
                                        // Close if they didn't select a rating
                                        isPresented = false
                                    }
                                }
                            }
                        } label: {
                            Text(starRating >= 4 ? "Rate on App Store" : (starRating > 0 ? "Submit Feedback" : "Maybe Later"))
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 15)
                                .background(starRating > 0 ? primaryPurple : lightPurple)
                                .cornerRadius(12)
                        }
                        .scaleEffect(buttonScale)
                        
                        Button {
                            withAnimation {
                                isPresented = false
                            }
                        } label: {
                            Text("Not Now")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.vertical, 10)
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 20)
                }
            }
            .frame(width: min(UIScreen.main.bounds.width - 40, 360))
            .background(colorScheme == .dark ? Color(UIColor.systemGray6) : Color.white)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
        }
        .onAppear {
            ratingService.logCustomRatingDisplayed()
        }
    }
}

// Helper extension to add to main app
extension View {
    func withCustomRating() -> some View {
        self.modifier(CustomRatingViewModifier())
    }
}

struct CustomRatingViewModifier: ViewModifier {
    @ObservedObject private var ratingService = RatingService.shared
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $ratingService.showCustomRatingModal) {
                CustomRatingView(isPresented: $ratingService.showCustomRatingModal)
                    .backgroundColor(Color.black.opacity(0.3))
            }
    }
}

extension View {
    func backgroundColor(_ color: Color) -> some View {
        ZStack {
            color.edgesIgnoringSafeArea(.all)
            self
        }
    }
} 