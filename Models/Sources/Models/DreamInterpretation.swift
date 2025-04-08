import Foundation

public struct DreamInterpretation: Codable {
    public let dreamName: String
    public let quickOverview: String
    public let inDepthInterpretation: String
    public let dailyLifeConnection: String
    public let recommendations: String
    
    public init(dreamName: String, quickOverview: String, inDepthInterpretation: String, dailyLifeConnection: String, recommendations: String) {
        self.dreamName = dreamName
        self.quickOverview = quickOverview
        self.inDepthInterpretation = inDepthInterpretation
        self.dailyLifeConnection = dailyLifeConnection
        self.recommendations = recommendations
    }
} 