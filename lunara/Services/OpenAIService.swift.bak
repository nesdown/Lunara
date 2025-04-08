import Foundation
import os
import SwiftUI
import Models

// Model for dream content fetched from OpenAI
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

// Content type enum to differentiate between the three features
public enum DreamContentType: String, CaseIterable {
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

class OpenAIService {
    private let apiKey: String
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.lunara", category: "DreamService")
    
    init() {
        // Get the API key from environment configuration
        self.apiKey = EnvironmentConfig.openAIApiKey
    }
    
    private func log(_ message: String) {
        // Use both NSLog and os.Logger for maximum visibility
        NSLog("🔍 [DreamService] %@", message)
        logger.debug("🔍 [DreamService] \(message)")
        // Keep the print for good measure
        print("🔍 [DreamService] \(message)")
    }
    
    func interpretDream(
        description: String,
        didWakeUp: Bool?,
        hadNegativeEmotions: Bool?,
        intensityLevel: Int
    ) async throws -> DreamInterpretation {
        log("Starting dream interpretation...")
        log("Input - Description: \(description)")
        log("Input - Did Wake Up: \(String(describing: didWakeUp))")
        log("Input - Had Negative Emotions: \(String(describing: hadNegativeEmotions))")
        log("Input - Intensity Level: \(intensityLevel)")
        
        let prompt = """
        Analyze this dream and respond with ONLY a JSON object. No other text or formatting:

        Dream Description: \(description)
        Did it wake them up: \(didWakeUp == true ? "Yes" : didWakeUp == false ? "No" : "Unknown")
        Had negative emotions: \(hadNegativeEmotions == true ? "Yes" : hadNegativeEmotions == false ? "No" : "Unknown")
        Intensity Level (1-10): \(intensityLevel)

        Required JSON format:
        {
            "dreamName": "A short, catchy title for the dream (max 50 characters)",
            "quickOverview": "2-3 sentences summarizing the dream's meaning",
            "inDepthInterpretation": "A detailed analysis split into two paragraphs",
            "dailyLifeConnection": "One paragraph explaining how this dream connects to daily life",
            "recommendations": "3-4 bullet points of advice based on the dream, each on a new line"
        }
        """
        
        let messages: [[String: Any]] = [
            ["role": "system", "content": "You are a dream interpreter. Respond only with the exact JSON format requested. No other text or formatting."],
            ["role": "user", "content": prompt]
        ]
        
        let requestBody: [String: Any] = [
            "model": "gpt-4-turbo-preview",
            "messages": messages,
            "temperature": 0.7,
            "response_format": ["type": "json_object"]
        ]
        
        log("Preparing API request...")
        
        guard let url = URL(string: baseURL) else {
            log("❌ Error: Invalid URL")
            throw NSError(domain: "OpenAIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        log("Sending request to OpenAI API...")
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            log("❌ Error: Invalid response type")
            throw NSError(domain: "OpenAIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response type"])
        }
        
        log("Received response with status code: \(httpResponse.statusCode)")
        
        // Print raw response for debugging
        if let rawResponse = String(data: data, encoding: .utf8) {
            log("📥 Raw API Response:")
            log(rawResponse)
        }
        
        if httpResponse.statusCode != 200 {
            if let errorResponse = try? JSONDecoder().decode(OpenAIErrorResponse.self, from: data) {
                log("❌ API Error: \(errorResponse.error.message)")
                throw NSError(
                    domain: "OpenAIService",
                    code: httpResponse.statusCode,
                    userInfo: [NSLocalizedDescriptionKey: errorResponse.error.message]
                )
            } else {
                log("❌ API Error: Unknown error with status code \(httpResponse.statusCode)")
                throw NSError(
                    domain: "OpenAIService",
                    code: httpResponse.statusCode,
                    userInfo: [NSLocalizedDescriptionKey: "Unknown API error"]
                )
            }
        }
        
        log("Decoding OpenAI response...")
        let openAIResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)
        
        guard let content = openAIResponse.choices.first?.message.content else {
            log("❌ Error: No content in response")
            throw NSError(domain: "OpenAIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No content in response"])
        }
        
        log("📝 Raw content from GPT:")
        log(content)
        
        // Clean and validate the content
        let cleanedContent = content
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "\\n", with: " ")
        
        log("🧹 Cleaned content:")
        log(cleanedContent)
        
        guard var interpretationData = cleanedContent.data(using: .utf8) else {
            log("❌ Error: Failed to convert content to data")
            throw NSError(domain: "OpenAIService", code: -1, userInfo: [
                NSLocalizedDescriptionKey: "Failed to convert content to data",
                "content": cleanedContent
            ])
        }
        
        do {
            // First try to validate if it's a valid JSON
            if let jsonObject = try? JSONSerialization.jsonObject(with: interpretationData) as? [String: Any] {
                log("✅ Valid JSON object detected with keys:")
                log(jsonObject.keys.joined(separator: ", "))
                
                // Handle recommendations array if present
                if let recommendations = jsonObject["recommendations"] as? [String] {
                    let recommendationsString = recommendations.joined(separator: "\n")
                    var mutableObject = jsonObject
                    mutableObject["recommendations"] = recommendationsString
                    
                    // Re-encode the modified object
                    let modifiedData = try JSONSerialization.data(withJSONObject: mutableObject)
                    interpretationData = modifiedData
                    
                    log("🔄 Converted recommendations array to string")
                }
                
                // Print each field's value length for debugging
                for (key, value) in jsonObject {
                    if let strValue = value as? String {
                        log("📏 \(key) length: \(strValue.count) characters")
                    }
                }
            } else {
                log("⚠️ Warning: Content is not a valid JSON object")
            }
            
            log("Attempting to decode into DreamInterpretation...")
            let decoder = JSONDecoder()
            let interpretation = try decoder.decode(DreamInterpretation.self, from: interpretationData)
            log("✅ Successfully decoded dream interpretation")
            return interpretation
        } catch {
            log("❌ JSON Parsing Error:")
            log(error.localizedDescription)
            
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case .keyNotFound(let key, let context):
                    log("Missing key: \(key.stringValue)")
                    log("Context: \(context.debugDescription)")
                case .typeMismatch(let type, let context):
                    log("Type mismatch: expected \(type)")
                    log("Context: \(context.debugDescription)")
                case .valueNotFound(let type, let context):
                    log("Value not found: expected \(type)")
                    log("Context: \(context.debugDescription)")
                case .dataCorrupted(let context):
                    log("Data corrupted: \(context.debugDescription)")
                @unknown default:
                    log("Unknown decoding error")
                }
            }
            
            throw NSError(
                domain: "OpenAIService",
                code: -1,
                userInfo: [
                    NSLocalizedDescriptionKey: "Failed to parse interpretation: \(error.localizedDescription)",
                    "content": cleanedContent,
                    "error": error.localizedDescription
                ]
            )
        }
    }
    
    // Function to extract the JSON from OpenAI response
    private func extractDreamInterpretation(from jsonString: String) throws -> DreamInterpretation {
        log("Parsing JSON response: \(jsonString)")
        
        do {
            let decoder = JSONDecoder()
            let interpretation = try decoder.decode(DreamInterpretation.self, from: Data(jsonString.utf8))
            return interpretation
        } catch {
            log("Error parsing JSON: \(error)")
            throw error
        }
    }

    // New function to fetch dream content
    func fetchDreamContent(for contentType: DreamContentType) async throws -> DreamContent {
        log("Starting dream content fetch for type: \(contentType.rawValue)...")
        
        let prompt = contentType.prompt
        
        let messages: [[String: Any]] = [
            ["role": "system", "content": "You are a dream expertise assistant specializing in helping users improve their dreaming experience. Respond with a JSON object according to the specified format."],
            ["role": "user", "content": prompt]
        ]
        
        let requestBody: [String: Any] = [
            "model": "gpt-4-turbo-preview",
            "messages": messages,
            "temperature": 0.7,
            "response_format": ["type": "json_object"]
        ]
        
        log("Preparing API request for dream content...")
        
        guard let url = URL(string: baseURL) else {
            log("❌ Error: Invalid URL")
            throw NSError(domain: "OpenAIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        log("Sending request to OpenAI API for dream content...")
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            log("❌ Error: Invalid response type")
            throw NSError(domain: "OpenAIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response type"])
        }
        
        log("Received response with status code: \(httpResponse.statusCode)")
        
        // Print raw response for debugging
        if let rawResponse = String(data: data, encoding: .utf8) {
            log("📥 Raw API Response:")
            log(rawResponse)
        }
        
        if httpResponse.statusCode != 200 {
            if let errorResponse = try? JSONDecoder().decode(OpenAIErrorResponse.self, from: data) {
                log("❌ API Error: \(errorResponse.error.message)")
                throw NSError(
                    domain: "OpenAIService",
                    code: httpResponse.statusCode,
                    userInfo: [NSLocalizedDescriptionKey: errorResponse.error.message]
                )
            } else {
                log("❌ API Error: Unknown error with status code \(httpResponse.statusCode)")
                throw NSError(
                    domain: "OpenAIService",
                    code: httpResponse.statusCode,
                    userInfo: [NSLocalizedDescriptionKey: "Unknown API error"]
                )
            }
        }
        
        log("Decoding OpenAI response...")
        let openAIResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)
        
        guard let content = openAIResponse.choices.first?.message.content else {
            log("❌ Error: No content in response")
            throw NSError(domain: "OpenAIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No content in response"])
        }
        
        log("📝 Raw content from GPT:")
        log(content)
        
        // Clean and validate the content
        let cleanedContent = content
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
        
        log("🧹 Cleaned content:")
        log(cleanedContent)
        
        guard let contentData = cleanedContent.data(using: .utf8) else {
            log("❌ Error: Failed to convert content to data")
            throw NSError(domain: "OpenAIService", code: -1, userInfo: [
                NSLocalizedDescriptionKey: "Failed to convert content to data",
                "content": cleanedContent
            ])
        }
        
        do {
            let decoder = JSONDecoder()
            var dreamContent = try decoder.decode(DreamContent.self, from: contentData)
            
            // Ensure timestamp is set to current date
            dreamContent.timestamp = Date()
            
            log("✅ Successfully decoded dream content")
            return dreamContent
        } catch {
            log("❌ JSON Parsing Error:")
            log(error.localizedDescription)
            
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case .keyNotFound(let key, let context):
                    log("Missing key: \(key.stringValue)")
                    log("Context: \(context.debugDescription)")
                case .typeMismatch(let type, let context):
                    log("Type mismatch: expected \(type)")
                    log("Context: \(context.debugDescription)")
                case .valueNotFound(let type, let context):
                    log("Value not found: expected \(type)")
                    log("Context: \(context.debugDescription)")
                case .dataCorrupted(let context):
                    log("Data corrupted: \(context.debugDescription)")
                @unknown default:
                    log("Unknown decoding error")
                }
            }
            
            throw NSError(
                domain: "OpenAIService",
                code: -1,
                userInfo: [
                    NSLocalizedDescriptionKey: "Failed to parse dream content: \(error.localizedDescription)",
                    "content": cleanedContent,
                    "error": error.localizedDescription
                ]
            )
        }
    }
}

struct OpenAIResponse: Codable {
    let choices: [Choice]
    
    struct Choice: Codable {
        let message: Message
    }
    
    struct Message: Codable {
        let content: String
    }
}

struct OpenAIErrorResponse: Codable {
    let error: OpenAIError
    
    struct OpenAIError: Codable {
        let message: String
        let type: String?
        let code: String?
    }
}

struct DreamInterpretation: Codable {
    let dreamName: String
    let quickOverview: String
    let inDepthInterpretation: String
    let dailyLifeConnection: String
    let recommendations: String
} 