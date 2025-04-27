import SwiftUI
import Models

struct DreamInterpretationView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: DreamInterpretationViewModel
    @State private var selectedTab = 0
    @State private var showRemoveConfirmation = false
    @State private var dreamRemoved = false
    
    // Custom colors
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    
    // Emoji for feeling ratings
    private let emojis = ["😞", "😐", "🙂", "😊", "😁"]
    
    // Dream icon based on interpretation
    private var dreamIcon: String {
        guard let dreamName = viewModel.interpretation?.dreamName else { return "moon.stars.fill" }
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
    
    private var overviewContent: some View {
        VStack(alignment: .leading, spacing: 32) {
            // Original Dream Description (Refined) Section
            if let refinedDescription = viewModel.interpretation?.refinedDescription {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "doc.text.fill")
                            .foregroundColor(primaryPurple)
                        Text("Here's what you logged:")
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                    
                    Text(refinedDescription)
                        .font(.body)
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(24)
                .frame(maxWidth: .infinity)
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
            
            // Quick Overview Section
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(primaryPurple)
                    Text("Quick Overview")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                
                Text(viewModel.interpretation?.quickOverview ?? "")
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(24)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(lightPurple, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 4)
            
            // Feelings Section
            VStack(spacing: 16) {
                Text("What were your feelings about the dream?")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack(spacing: 32) {
                    ForEach(0..<5) { index in
                        Button {
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
                }
            }
            .padding(.vertical, 24)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(.secondarySystemBackground))
            )
            
            // Daily Life Connection Section
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "figure.mind.and.body")
                        .foregroundColor(primaryPurple)
                    Text("Daily Life Connection")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                
                Text(viewModel.interpretation?.dailyLifeConnection ?? "")
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(24)
            .frame(maxWidth: .infinity)
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
        .padding(.horizontal, 12)
    }

    var body: some View {
        ScrollView {
        VStack(spacing: 32) {
            // Dream Title with Icon
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(lightPurple)
                            .frame(width: 100, height: 100)
                        Image(systemName: dreamIcon)
                            .font(.system(size: 50))
                            .foregroundColor(primaryPurple)
                    }
                    
                    Text(viewModel.interpretation?.dreamName ?? "")
                .font(.system(size: 28, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)
        }
        .padding(.top, 8)
                
                // Tab Selection
        Picker("View Selection", selection: $selectedTab) {
            Text("Overview").tag(0)
            Text("Details").tag(1)
            Text("Insights").tag(2)
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, 12)
    
                // Content based on selected tab
                Group {
        if selectedTab == 0 {
                        overviewContent
        } else if selectedTab == 1 {
            detailsTab
        } else {
            insightsTab
        }
    }
                .frame(minHeight: 450)
                
                // Action Buttons
                VStack(spacing: 12) {
                    if dreamRemoved {
                        HStack(spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(primaryPurple)
                                .font(.system(size: 20))
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Dream removed successfully")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.primary)
                                
                                Text("Use the X icon in the top corner to close this window")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(.systemGray))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
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
                        .padding(.horizontal, 12)
                    }
                    
                    Button {
                        // Show confirmation dialog instead of immediate deletion
                        showRemoveConfirmation = true
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "trash.fill")
                            Text("Remove from Journal")
                                .font(.system(size: 16, weight: .medium))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(dreamRemoved ? Color.gray.opacity(0.8) : Color.red.opacity(0.8))
                        )
                    }
                    .buttonStyle(.plain)
                    .disabled(dreamRemoved)
                    .alert("Remove Dream", isPresented: $showRemoveConfirmation) {
                        Button("Cancel", role: .cancel) {}
                        Button("Remove", role: .destructive) {
                            let wasRemoved = viewModel.removeDreamFromJournal()
                            if wasRemoved {
                                // Show a brief message that the dream was removed
                                let generator = UINotificationFeedbackGenerator()
                                generator.notificationOccurred(.success)
                                
                                // Set flag to indicate dream was removed
                                dreamRemoved = true
                            }
                        }
                    } message: {
                        Text("Are you sure you want to remove this dream from your journal? This action cannot be undone.")
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 16)
            }
        }
    }

    private var overviewTab: some View {
        VStack(alignment: .leading, spacing: 32) {
            // Original Dream Description (Refined) Section
            if let refinedDescription = viewModel.interpretation?.refinedDescription {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "doc.text.fill")
                            .foregroundColor(primaryPurple)
                        Text("Here's what you logged:")
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                    
                    Text(refinedDescription)
                        .font(.body)
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(24)
                .frame(maxWidth: .infinity)
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
            
            // Quick Overview Section
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(primaryPurple)
                    Text("Quick Overview")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                
                Text(viewModel.interpretation?.quickOverview ?? "")
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(24)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(lightPurple, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 4)
            
            // Feelings Section
            VStack(spacing: 16) {
                Text("What were your feelings about the dream?")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack(spacing: 32) {
                    ForEach(0..<5) { index in
                        Button {
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
                }
            }
            .padding(.vertical, 24)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(.secondarySystemBackground))
            )
            
            // Daily Life Connection Section
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "figure.mind.and.body")
                        .foregroundColor(primaryPurple)
                    Text("Daily Life Connection")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                
                Text(viewModel.interpretation?.dailyLifeConnection ?? "")
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(24)
            .frame(maxWidth: .infinity)
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
        .padding(.horizontal, 12)
    }

    private var detailsTab: some View {
        VStack(alignment: .leading, spacing: 32) {
            // In-Depth Interpretation Section
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(primaryPurple)
                    Text("In-Depth Interpretation")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                
                Text(viewModel.interpretation?.inDepthInterpretation ?? "")
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(24)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(lightPurple, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 4)
            
            // Rate Interpretation Section
            VStack(spacing: 16) {
                Text("Rate this interpretation")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack(spacing: 8) {
                    ForEach(1...5, id: \.self) { star in
                        Button {
                            viewModel.starRating = star
                        } label: {
                            Image(systemName: viewModel.starRating >= star ? "star.fill" : "star")
                                .font(.system(size: 28))
                                .foregroundColor(viewModel.starRating >= star ? primaryPurple : Color(.systemGray3))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.vertical, 24)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(.secondarySystemBackground))
            )
        }
        .padding(.horizontal, 12)
    }
    
    private var insightsTab: some View {
        VStack(alignment: .leading, spacing: 32) {
            // Personal Recommendations Section
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(primaryPurple)
                    Text("Personal Recommendations")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                
                Text(viewModel.interpretation?.recommendations ?? "")
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(24)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(lightPurple, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 4)
            
            // Tips for Better Dream Recall
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "brain.fill")
                        .foregroundColor(primaryPurple)
                    Text("Tips for Better Dream Recall")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    TipRow(icon: "bed.double.fill", text: "Keep a dream journal by your bed")
                    TipRow(icon: "alarm.fill", text: "Set an intention to remember your dreams before sleep")
                    TipRow(icon: "iphone.slash", text: "Avoid screens right before bedtime")
                    TipRow(icon: "moon.fill", text: "Establish a regular sleep schedule")
                    TipRow(icon: "pencil.and.outline", text: "Write down dreams immediately upon waking")
                }
            }
            .padding(24)
            .frame(maxWidth: .infinity)
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
        .padding(.horizontal, 12)
    }
}

// Helper View for Tips
struct TipRow: View {
    let icon: String
    let text: String
    
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    
    var body: some View {
        HStack(spacing: 12) {
                Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(primaryPurple)
            
            Text(text)
                .font(.system(size: 16))
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
} 