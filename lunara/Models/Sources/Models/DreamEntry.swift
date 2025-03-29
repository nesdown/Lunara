import Foundation

public struct DreamEntry: Identifiable, Codable, Equatable {
    public let id: UUID
    public let description: String
    public let didWakeUp: Bool?
    public let hadNegativeEmotions: Bool?
    public let intensityLevel: Int
    public let createdAt: Date
    
    // Interpretation data
    public var dreamName: String
    public var quickOverview: String
    public var inDepthInterpretation: String
    public var dailyLifeConnection: String
    public var recommendations: String
    public var feelingRating: Int?
    public var starRating: Int?
    
    public init(
        id: UUID = UUID(),
        description: String,
        didWakeUp: Bool?,
        hadNegativeEmotions: Bool?,
        intensityLevel: Int,
        createdAt: Date = Date(),
        dreamName: String = "",
        quickOverview: String = "",
        inDepthInterpretation: String = "",
        dailyLifeConnection: String = "",
        recommendations: String = "",
        feelingRating: Int? = nil,
        starRating: Int? = nil
    ) {
        self.id = id
        self.description = description
        self.didWakeUp = didWakeUp
        self.hadNegativeEmotions = hadNegativeEmotions
        self.intensityLevel = intensityLevel
        self.createdAt = createdAt
        self.dreamName = dreamName
        self.quickOverview = quickOverview
        self.inDepthInterpretation = inDepthInterpretation
        self.dailyLifeConnection = dailyLifeConnection
        self.recommendations = recommendations
        self.feelingRating = feelingRating
        self.starRating = starRating
    }
    
    public static func == (lhs: DreamEntry, rhs: DreamEntry) -> Bool {
        lhs.id == rhs.id &&
        lhs.description == rhs.description &&
        lhs.didWakeUp == rhs.didWakeUp &&
        lhs.hadNegativeEmotions == rhs.hadNegativeEmotions &&
        lhs.intensityLevel == rhs.intensityLevel &&
        lhs.createdAt == rhs.createdAt &&
        lhs.dreamName == rhs.dreamName &&
        lhs.quickOverview == rhs.quickOverview &&
        lhs.inDepthInterpretation == rhs.inDepthInterpretation &&
        lhs.dailyLifeConnection == rhs.dailyLifeConnection &&
        lhs.recommendations == rhs.recommendations &&
        lhs.feelingRating == rhs.feelingRating &&
        lhs.starRating == rhs.starRating
    }
} 