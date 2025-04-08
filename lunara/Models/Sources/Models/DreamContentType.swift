import Foundation

// Content type enum to differentiate between the three features
public enum DreamContentType: String, CaseIterable, Codable {
    case dailyRitual = "Daily Ritual"
    case lucidDreaming = "Learn Lucid Dreaming"
    case dreamingFact = "Daily Dreaming Fact"
    
    public var description: String {
        switch self {
        case .dailyRitual:
            return "A ritual or habit for the day that can help enhance your dreaming process and quality"
        case .lucidDreaming:
            return "Learn how to become conscious during your dreams with these techniques and best practices"
        case .dreamingFact:
            return "Discover fascinating facts and insights about dreaming and sleep"
        }
    }
    
    public var icon: String {
        switch self {
        case .dailyRitual:
            return "moon.stars.circle.fill"
        case .lucidDreaming:
            return "graduationcap.fill"
        case .dreamingFact:
            return "lightbulb.fill"
        }
    }
    
    public var prompt: String {
        switch self {
        case .dailyRitual:
            return """
            Create a daily ritual or practice to enhance dreaming quality. Format as JSON with these fields:
            - title: A catchy title for today's ritual (max 60 chars)
            - introduction: A brief paragraph explaining the purpose of today's ritual (max 200 chars)
            - sections: Array of 3-4 sections, each with a heading and content about implementation steps
            - conclusion: Final encouraging message (max 100 chars)
            
            Focus on practical, science-based techniques for dream enhancement that people can implement today. Make it actionable and specific.
            """
        case .lucidDreaming:
            return """
            Create a lesson on lucid dreaming techniques. Format as JSON with these fields:
            - title: An engaging title for this lucid dreaming lesson (max 60 chars)
            - introduction: A brief paragraph explaining what lucid dreaming is and its benefits (max 200 chars)
            - sections: Array of 3-4 sections, each with a heading and content describing specific techniques
            - conclusion: Final motivational message (max 100 chars)
            
            Include evidence-based techniques like reality testing, MILD, WBTB, dream journaling, etc. Make it approachable for beginners.
            """
        case .dreamingFact:
            return """
            Share an interesting fact about dreaming or sleep science. Format as JSON with these fields:
            - title: An intriguing title highlighting today's dream fact (max 60 chars)
            - introduction: A brief paragraph introducing the fact (max 200 chars)
            - sections: Array of 3-4 sections, each with a heading and content exploring different aspects of this fact
            - conclusion: A thought-provoking closing note (max 100 chars)
            
            Focus on scientifically-accurate information. Include context, research, and why it matters. Be engaging and educational.
            """
        }
    }
}
