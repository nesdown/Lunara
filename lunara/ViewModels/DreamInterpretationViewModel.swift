import Foundation
import SwiftUI
import Models

@MainActor
class DreamInterpretationViewModel: ObservableObject {
    private let openAIService = OpenAIService()
    private let storageService = DreamStorageService.shared
    
    // Dream details
    @Published var description: String = ""
    @Published var didWakeUp: Bool?
    @Published var hadNegativeEmotions: Bool?
    @Published var intensityLevel: Int = 5
    
    // Interpretation state
    @Published var isLoading = false
    @Published var error: Error?
    @Published var interpretation: DreamInterpretation?
    @Published var feelingRating: Int = 3
    @Published var starRating: Int = 0
    
    // For existing dream review
    private var existingDreamId: UUID?
    
    // Initialize for new dream interpretation
    init() {}
    
    // Initialize for viewing an existing dream
    init(existingDream: DreamEntry) {
        print("Initializing view model with existing dream: \(existingDream.id)")
        self.existingDreamId = existingDream.id
        self.description = existingDream.description
        self.didWakeUp = existingDream.didWakeUp
        self.hadNegativeEmotions = existingDream.hadNegativeEmotions
        self.intensityLevel = existingDream.intensityLevel
        self.feelingRating = existingDream.feelingRating ?? 3
        self.starRating = existingDream.starRating ?? 0
        
        // Create interpretation from the existing dream data
        self.interpretation = DreamInterpretation(
            dreamName: existingDream.dreamName,
            quickOverview: existingDream.quickOverview,
            inDepthInterpretation: existingDream.inDepthInterpretation,
            dailyLifeConnection: existingDream.dailyLifeConnection,
            recommendations: existingDream.recommendations
        )
        
        print("Dream name: \(existingDream.dreamName)")
        print("Quick overview: \(existingDream.quickOverview.prefix(30))")
    }
    
    func interpretDream(
        description: String,
        didWakeUp: Bool?,
        hadNegativeEmotions: Bool?,
        intensityLevel: Int
    ) async {
        // Store the dream details
        self.description = description
        self.didWakeUp = didWakeUp
        self.hadNegativeEmotions = hadNegativeEmotions
        self.intensityLevel = intensityLevel
        
        isLoading = true
        error = nil
        
        do {
            interpretation = try await openAIService.interpretDream(
                description: description,
                didWakeUp: didWakeUp,
                hadNegativeEmotions: hadNegativeEmotions,
                intensityLevel: intensityLevel
            )
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    func saveDreamToJournal() {
        guard let interpretation = interpretation else { return }
        
        let dreamEntry = DreamEntry(
            id: existingDreamId ?? UUID(),
            description: description,
            didWakeUp: didWakeUp,
            hadNegativeEmotions: hadNegativeEmotions,
            intensityLevel: intensityLevel,
            createdAt: Date(),
            dreamName: interpretation.dreamName,
            quickOverview: interpretation.quickOverview,
            inDepthInterpretation: interpretation.inDepthInterpretation,
            dailyLifeConnection: interpretation.dailyLifeConnection,
            recommendations: interpretation.recommendations,
            feelingRating: feelingRating,
            starRating: starRating
        )
        
        // Save to storage service
        storageService.saveDream(dreamEntry)
    }
    
    func resetState() {
        existingDreamId = nil
        description = ""
        didWakeUp = nil
        hadNegativeEmotions = nil
        intensityLevel = 5
        interpretation = nil
        error = nil
        isLoading = false
        feelingRating = 3
        starRating = 0
    }
    
    // Access the dream ID for checking storage status
    func getDreamId() -> UUID? {
        return existingDreamId
    }
} 