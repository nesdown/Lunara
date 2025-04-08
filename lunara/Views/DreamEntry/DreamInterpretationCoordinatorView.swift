import SwiftUI
import Models

struct DreamInterpretationCoordinatorView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: DreamInterpretationViewModel
    private let dream: DreamEntry
    
    init(dream: DreamEntry) {
        self.dream = dream
        _viewModel = StateObject(wrappedValue: DreamInterpretationViewModel(existingDream: dream))
    }
    
    var body: some View {
        VStack {
            // Navigation bar with close button
            HStack {
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.secondary)
                        .padding()
                }
            }
            
            // Main content
            DreamInterpretationView(viewModel: viewModel)
        }
        .navigationBarHidden(true)
        .onAppear {
            print("DreamInterpretationCoordinatorView appeared with dream: \(dream.id), \(dream.dreamName)")
        }
    }
}

struct DreamInterpretationCoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a sample dream for preview
        let sampleDream = DreamEntry(
            id: UUID(),
            description: "I was flying over a beautiful landscape",
            didWakeUp: true,
            hadNegativeEmotions: false,
            intensityLevel: 7,
            createdAt: Date(),
            dreamName: "Flying Dream",
            quickOverview: "This dream represents freedom and a desire to escape limitations.",
            inDepthInterpretation: "Flying in dreams often symbolizes a desire for freedom, transcendence, and the ability to rise above obstacles or limitations in your waking life.",
            dailyLifeConnection: "You may be feeling constrained in some aspect of your life and longing for more freedom or independence.",
            recommendations: "Consider areas in your life where you feel restricted and explore ways to gain more autonomy.",
            feelingRating: 4,
            starRating: 5
        )
        
        return DreamInterpretationCoordinatorView(dream: sampleDream)
    }
} 