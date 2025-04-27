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
    @Published var interpretation: Models.DreamInterpretation?
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
        self.interpretation = Models.DreamInterpretation(
            dreamName: existingDream.dreamName,
            quickOverview: existingDream.quickOverview,
            inDepthInterpretation: existingDream.inDepthInterpretation,
            dailyLifeConnection: existingDream.dailyLifeConnection,
            recommendations: existingDream.recommendations,
            refinedDescription: existingDream.refinedDescription
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
            let serviceInterpretation = try await openAIService.interpretDream(
                description: description,
                didWakeUp: didWakeUp,
                hadNegativeEmotions: hadNegativeEmotions,
                intensityLevel: intensityLevel
            )
            
            // Convert to Models.DreamInterpretation
            interpretation = Models.DreamInterpretation(
                dreamName: serviceInterpretation.dreamName,
                quickOverview: serviceInterpretation.quickOverview,
                inDepthInterpretation: serviceInterpretation.inDepthInterpretation,
                dailyLifeConnection: serviceInterpretation.dailyLifeConnection,
                recommendations: serviceInterpretation.recommendations,
                refinedDescription: serviceInterpretation.refinedDescription
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
            starRating: starRating,
            refinedDescription: interpretation.refinedDescription
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
    
    // Check if the current dream is saved in the journal
    func isDreamSavedInJournal() -> Bool {
        guard let id = existingDreamId else {
            // For new dreams, we need to check if any dream with the same content exists
            guard let interpretation = interpretation else { return false }
            
            // Get all dreams and check if any has matching dreamName and description
            let allDreams = storageService.getAllDreams()
            return allDreams.contains { dream in
                return dream.dreamName == interpretation.dreamName && 
                       dream.description == description
            }
        }
        
        // For existing dreams, simply check if the ID exists
        return storageService.dreamExists(id: id)
    }
    
    // Remove the current dream from the journal
    func removeDreamFromJournal() -> Bool {
        guard let id = existingDreamId else {
            // For new dreams, try to find a matching dream to remove
            guard let interpretation = interpretation else { return false }
            
            let allDreams = storageService.getAllDreams()
            if let matchingDream = allDreams.first(where: { 
                $0.dreamName == interpretation.dreamName && 
                $0.description == description 
            }) {
                storageService.deleteDream(with: matchingDream.id)
                return true
            }
            return false
        }
        
        // For existing dreams, remove by ID
        storageService.deleteDream(with: id)
        return true
    }
} 