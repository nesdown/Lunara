import Foundation

public struct DreamContent: Codable, Identifiable {
    public let id = UUID()
    public let title: String
    public let introduction: String
    public let sections: [ContentSection]
    public let conclusion: String
    public var timestamp: Date
    
    public struct ContentSection: Codable, Identifiable {
        public let id = UUID()
        public let heading: String
        public let content: String
    }
    
    public init(title: String, introduction: String, sections: [ContentSection], conclusion: String, timestamp: Date = Date()) {
        self.title = title
        self.introduction = introduction
        self.sections = sections
        self.conclusion = conclusion
        self.timestamp = timestamp
    }
    
    // Custom decoding initialization to handle missing timestamp
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decode(String.self, forKey: .title)
        introduction = try container.decode(String.self, forKey: .introduction)
        sections = try container.decode([ContentSection].self, forKey: .sections)
        conclusion = try container.decode(String.self, forKey: .conclusion)
        
        // Set default timestamp if not present in JSON
        timestamp = try container.decodeIfPresent(Date.self, forKey: .timestamp) ?? Date()
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, title, introduction, sections, conclusion, timestamp
    }
} 