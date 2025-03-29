import SwiftUI
import Models
import UIKit
import StoreKit

// Coordinator view to manage loading state
struct DreamInterpretationCoordinatorView: View {
    let dream: DreamEntry
    @State private var readyToShow = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            if readyToShow {
                DreamInterpretationView(viewModel: DreamInterpretationViewModel(existingDream: dream))
            } else {
                loadingContent
            }
        }
        .background(DynamicColors.backgroundPrimary.edgesIgnoringSafeArea(.all))
        .navigationBarItems(trailing: closeButton)
        .onAppear {
            print("DreamInterpretationCoordinatorView appeared")
            print("Dream ID: \(dream.id)")
            print("Dream name: \(dream.dreamName)")
            print("Dream description: \(dream.description.prefix(30))...")
        }
    }
    
    // Extracted Views
    private var loadingContent: some View {
        LoadingView()
            .onAppear {
                print("LoadingView appeared for dream: \(dream.id), name: \(dream.dreamName)")
                
                // Shorter delay to ensure view model is properly initialized
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    print("Setting readyToShow = true for dream: \(dream.id)")
                    readyToShow = true
                }
            }
    }
    
    private var closeButton: some View {
        Button {
            HapticManager.shared.buttonPress()
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("Close")
                .fontWeight(.medium)
                .foregroundColor(Color.accentColor)
        }
    }
}

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(1.5)
            
            Text("Loading dream details...")
                .font(.headline)
                .foregroundColor(DynamicColors.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct DreamInterpretationView: View {
    @ObservedObject var viewModel: DreamInterpretationViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedTab = 0
    @State private var showingSaveConfirmation = false
    @State private var showingRemoveConfirmation = false
    @State private var viewID = UUID() // For forcing view refresh
    @State private var isAlreadySaved = false
    @State private var isShowingShareSheet = false
    @State private var shareText: String = ""
    
    // MARK: - Constants
    private let emojis = ["😊", "😌", "🤔", "😕", "😢"]
    private let stars = ["⭐️", "⭐️", "⭐️", "⭐️", "⭐️"]
    
    // MARK: - Icon Selection Logic
    private var dreamIcon: String {
        iconForDream()
    }
    
    private func iconForDream() -> String {
        guard let dreamName = viewModel.interpretation?.dreamName else {
            return "sparkles.square.filled.on.square"
        }
        
        let title = dreamName.lowercased()
        
        // Nature themes
        if title.contains("jungle") || title.contains("forest") || title.contains("nature") {
            return "leaf.fill"
        }
        
        // Sky themes
        if title.contains("flying") || title.contains("sky") || title.contains("air") {
            return "bird.fill"
        }
        
        // Water themes
        if title.contains("water") || title.contains("ocean") || title.contains("sea") {
            return "water.waves.fill"
        }
        
        // Home themes
        if title.contains("house") || title.contains("home") {
            return "house.fill"
        }
        
        // Conflict themes
        if title.contains("conflict") || title.contains("fight") || title.contains("battle") {
            return "exclamationmark.triangle.fill"
        }
        
        // Love themes
        if title.contains("love") || title.contains("heart") {
            return "heart.fill"
        }
        
        // Work themes
        if title.contains("work") || title.contains("office") {
            return "briefcase.fill"
        }
        
        // Education themes
        if title.contains("school") || title.contains("study") {
            return "book.fill"
        }
        
        // People themes
        if title.contains("family") || title.contains("friend") {
            return "person.2.fill"
        }
        
        // Travel themes
        if title.contains("journey") || title.contains("travel") {
            return "airplane.departure"
        }
        
        // Default icon
        return "sparkles.square.filled.on.square"
    }
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            if let interpretation = viewModel.interpretation {
                // Convert to Models.DreamInterpretation if needed
                let modelInterpretation = convertToModelInterpretationIfNeeded(interpretation)
                dreamContentView(interpretation: modelInterpretation)
            } else {
                LoadingView()
            }
        }
        .id(viewID) // Force view refresh when ID changes
        .background(DynamicColors.backgroundPrimary)
        .onAppear(perform: onAppearActions)
        .alert("Dream Saved", isPresented: $showingSaveConfirmation) {
            Button("OK") { }
        } message: {
            Text("Your dream interpretation has been saved to your journal.")
        }
        .alert("Remove Dream", isPresented: $showingRemoveConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Remove", role: .destructive) {
                handleDreamRemoval()
            }
        } message: {
            Text("Are you sure you want to remove this dream from your journal?")
        }
    }
    
    // Helper function to convert between different DreamInterpretation types if needed
    private func convertToModelInterpretationIfNeeded(_ interpretation: Any) -> DreamInterpretation {
        // If it's already the right type, return it
        if let modelInterpretation = interpretation as? DreamInterpretation {
            return modelInterpretation
        }
        
        // If it's a different type with the same properties, convert it
        // This assumes the other type has the same property names
        if let anyInterpretation = interpretation as? AnyObject,
           let dreamName = anyInterpretation.value(forKey: "dreamName") as? String,
           let quickOverview = anyInterpretation.value(forKey: "quickOverview") as? String,
           let inDepthInterpretation = anyInterpretation.value(forKey: "inDepthInterpretation") as? String,
           let dailyLifeConnection = anyInterpretation.value(forKey: "dailyLifeConnection") as? String,
           let recommendations = anyInterpretation.value(forKey: "recommendations") as? String {
            
            return DreamInterpretation(
                dreamName: dreamName,
                quickOverview: quickOverview,
                inDepthInterpretation: inDepthInterpretation,
                dailyLifeConnection: dailyLifeConnection,
                recommendations: recommendations
            )
        }
        
        // Fallback - create an empty interpretation
        print("WARNING: Failed to convert interpretation type")
        return DreamInterpretation(
            dreamName: "Unknown Dream",
            quickOverview: "Could not load dream overview.",
            inDepthInterpretation: "Could not load dream interpretation.",
            dailyLifeConnection: "Could not load life connection.",
            recommendations: "No recommendations available."
        )
    }
    
    // MARK: - Actions
    private func onAppearActions() {
        print("DreamInterpretationView appeared")
        print("Dream name: \(viewModel.interpretation?.dreamName ?? "nil")")
        print("Quick overview: \(String(describing: viewModel.interpretation?.quickOverview.prefix(30)))")
        
        // Check if this dream is already saved
        if let dreamId = viewModel.getDreamId() {
            isAlreadySaved = DreamStorageService.shared.dreamExists(id: dreamId)
        }
        
        // Force refresh after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            viewID = UUID()
        }
    }
    
    private func handleDreamRemoval() {
        if let dreamId = viewModel.getDreamId() {
            DreamStorageService.shared.removeDream(id: dreamId)
            isAlreadySaved = false
            // Notify that dream was removed
            NotificationCenter.default.post(name: .dreamsSaved, object: nil)
        }
    }
    
    // MARK: - View Components
    private func dreamContentView(interpretation: DreamInterpretation) -> some View {
        VStack(spacing: 32) {
            // Dream Title with Icon
            dreamTitleSection(interpretation: interpretation)
            
            // Tab Selection
            tabSelectionView
            
            // Content based on selected tab
            tabContentView
                .padding(.horizontal, 12)
                .frame(minHeight: 450)
            
            // Ratings Section
            ratingsSection
            
            // Action Buttons
            actionButtonsSection
        }
    }
    
    private func dreamTitleSection(interpretation: DreamInterpretation) -> some View {
        VStack(spacing: 16) {
            dreamIconCircle
            
            Text(interpretation.dreamName)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(DynamicColors.textPrimary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)
        }
        .padding(.top, 8)
    }
    
    private var dreamIconCircle: some View {
        ZStack {
            Circle()
                .fill(DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.3 : 1.0))
                .frame(width: 100, height: 100)
            
            Image(systemName: dreamIcon)
                .font(.system(size: 50))
                .foregroundColor(DynamicColors.primaryPurple)
        }
    }
    
    private var tabSelectionView: some View {
        Picker("View Selection", selection: $selectedTab) {
            Text("Overview").tag(0)
            Text("Details").tag(1)
            Text("Insights").tag(2)
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, 12)
    }
    
    @ViewBuilder
    private var tabContentView: some View {
        if selectedTab == 0 {
            overviewTab
        } else if selectedTab == 1 {
            detailsTab
        } else {
            insightsTab
        }
    }
    
    private var ratingsSection: some View {
        VStack(spacing: 32) {
            emojiRatingView
            starRatingView
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(DynamicColors.backgroundSecondary)
        )
        .padding(.horizontal, 12)
    }
    
    private var emojiRatingView: some View {
        VStack(spacing: 16) {
            Text("What were your feelings about the dream?")
                .font(.headline)
                .foregroundColor(DynamicColors.textPrimary)
            
            HStack(spacing: 32) {
                ForEach(0..<5) { index in
                    emojiButton(index: index)
                }
            }
        }
    }
    
    private func emojiButton(index: Int) -> some View {
        Button {
            HapticManager.shared.selection()
            viewModel.feelingRating = index + 1
        } label: {
            Text(emojis[index])
                .font(.system(size: 32))
                .opacity(index + 1 == viewModel.feelingRating ? 1.0 : 0.5)
                .scaleEffect(index + 1 == viewModel.feelingRating ? 1.2 : 1.0)
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.3), value: viewModel.feelingRating)
    }
    
    private var starRatingView: some View {
        VStack(spacing: 16) {
            Text("Rate your dream")
                .font(.headline)
                .foregroundColor(DynamicColors.textPrimary)
            
            HStack(spacing: 32) {
                ForEach(0..<5) { index in
                    starButton(index: index)
                }
            }
        }
    }
    
    private func starButton(index: Int) -> some View {
        Button {
            viewModel.starRating = index + 1
            
            // If the user gives a high rating (4 or 5 stars), offer to rate the app
            // We use this as a signal that the user is enjoying the app
            if index >= 3 { // 4th or 5th star (index is 0-based)
                // Use UserDefaults to limit how often we ask for app reviews
                let lastRatingRequest = UserDefaults.standard.double(forKey: "lastDreamRatingReviewRequest")
                let currentTime = Date().timeIntervalSince1970
                
                // Only show the rating prompt once every 30 days (2,592,000 seconds)
                if currentTime - lastRatingRequest > 2592000 {
                    // Add a small delay so the star animation completes first
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                            // Store the current time as the last time we requested a review
                            UserDefaults.standard.set(currentTime, forKey: "lastDreamRatingReviewRequest")
                            
                            // Request the app review
                            if #available(iOS 18.0, *) {
                                StoreKit.AppStore.requestReview(in: scene)
                            } else {
                                SKStoreReviewController.requestReview(in: scene)
                            }
                        }
                    }
                }
            }
        } label: {
            Text(stars[index])
                .font(.system(size: 32))
                .opacity(index < viewModel.starRating ? 1.0 : 0.5)
                .scaleEffect(index < viewModel.starRating ? 1.2 : 1.0)
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.3), value: viewModel.starRating)
    }
    
    private var actionButtonsSection: some View {
        VStack(spacing: 16) {
            saveOrRemoveButton
            shareButton
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 16)
    }
    
    private var saveOrRemoveButton: some View {
        Button {
            handleSaveOrRemoveAction()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: isAlreadySaved ? "trash.fill" : "square.and.arrow.down.fill")
                    .font(.system(size: 16, weight: .semibold))
                
                Text(isAlreadySaved ? "REMOVE FROM JOURNAL" : "SAVE TO JOURNAL")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(isAlreadySaved ? Color.red : DynamicColors.primaryPurple)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(isAlreadySaved ? Color.red : DynamicColors.primaryPurple, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
    
    private func handleSaveOrRemoveAction() {
        if isAlreadySaved {
            // Show removal confirmation
            showingRemoveConfirmation = true
        } else {
            // Save to journal
            viewModel.saveDreamToJournal()
            showingSaveConfirmation = true
            isAlreadySaved = true
        }
    }
    
    private func shareInterpretation() {
        guard let interpretation = viewModel.interpretation else { return }
        
        // Create the text to share
        shareText = """
        Dream: \(interpretation.dreamName)
        
        OVERVIEW:
        \(interpretation.quickOverview)
        
        Interpreted with Lunara Dream Journal
        """
        
        // Show the share sheet
        isShowingShareSheet = true
    }
    
    private var shareButton: some View {
        Button {
            shareInterpretation()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 16, weight: .semibold))
                
                Text("SHARE")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(Color.accentColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(Color.accentColor, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $isShowingShareSheet) {
            ShareSheet(activityItems: [shareText])
        }
    }
    
    // MARK: - Tab Content Views
    private var overviewTab: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Quick Overview Section
            infoSection(
                icon: "lightbulb.fill",
                title: "Quick Overview",
                content: viewModel.interpretation?.quickOverview ?? ""
            )
            
            // Daily Life Connection Section
            infoSection(
                icon: "figure.mind.and.body",
                title: "Daily Life Connection",
                content: viewModel.interpretation?.dailyLifeConnection ?? ""
            )
        }
    }
    
    private var detailsTab: some View {
        infoSection(
            icon: "doc.text.magnifyingglass",
            title: "In-Depth Analysis",
            content: viewModel.interpretation?.inDepthInterpretation ?? ""
        )
    }
    
    private var insightsTab: some View {
        infoSection(
            icon: "list.bullet.clipboard.fill",
            title: "Recommendations",
            content: formatRecommendations(viewModel.interpretation?.recommendations ?? "")
        )
    }
    
    private func infoSection(icon: String, title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(DynamicColors.primaryPurple)
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(DynamicColors.textPrimary)
            }
            
            Text(content)
                .font(.body)
                .foregroundColor(DynamicColors.textPrimary)
                .lineSpacing(4)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(24)
        .modifier(CardStyle())
    }
    
    // MARK: - Helper Methods
    private func formatRecommendations(_ recommendations: String) -> String {
        let cleanedText = recommendations
            .replacingOccurrences(of: "- ", with: "")
            .replacingOccurrences(of: "\n", with: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        return "Based on your dream, here are some recommendations: " + cleanedText
    }
}

// MARK: - Share Sheet UIViewControllerRepresentable
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // Nothing to update
    }
} 