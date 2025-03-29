import Foundation

public struct DreamInterpretation: Codable, Equatable {
    public let dreamName: String
    public let quickOverview: String
    public let inDepthInterpretation: String
    public let dailyLifeConnection: String
    public let recommendations: String
    
    public init(
        dreamName: String,
        quickOverview: String,
        inDepthInterpretation: String,
        dailyLifeConnection: String,
        recommendations: String
    ) {
        self.dreamName = dreamName
        self.quickOverview = quickOverview
        self.inDepthInterpretation = inDepthInterpretation
        self.dailyLifeConnection = dailyLifeConnection
        self.recommendations = recommendations
    }
    
    public static func == (lhs: DreamInterpretation, rhs: DreamInterpretation) -> Bool {
        lhs.dreamName == rhs.dreamName &&
        lhs.quickOverview == rhs.quickOverview &&
        lhs.inDepthInterpretation == rhs.inDepthInterpretation &&
        lhs.dailyLifeConnection == rhs.dailyLifeConnection &&
        lhs.recommendations == rhs.recommendations
    }
} 