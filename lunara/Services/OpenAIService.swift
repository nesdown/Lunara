import Foundation
import os.log
import SwiftUI
import Models

// Model for dream content fetched from OpenAI
public struct DreamContent: Codable, Identifiable {
    public var id: String
    public let title: String
    public let introduction: String
    public let sections: [ContentSection]
    public let conclusion: String
    public var timestamp: Date
    public let type: DreamContentType
    
    public struct ContentSection: Codable, Identifiable {
        public var id: String
        public let heading: String
        public let content: String
        
        public init(id: String = UUID().uuidString, heading: String, content: String) {
            self.id = id
            self.heading = heading
            self.content = content
        }
        
        // Custom init from decoder to handle older saved data
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            // Use UUID().uuidString as default if id is missing
            id = try container.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString
            heading = try container.decode(String.self, forKey: .heading)
            content = try container.decode(String.self, forKey: .content)
        }
        
        private enum CodingKeys: String, CodingKey {
            case id, heading, content
        }
    }
    
    public init(id: String = UUID().uuidString, title: String, introduction: String, sections: [ContentSection], conclusion: String, timestamp: Date = Date(), type: DreamContentType) {
        self.id = id
        self.title = title
        self.introduction = introduction
        self.sections = sections
        self.conclusion = conclusion
        self.timestamp = timestamp
        self.type = type
    }
    
    // Custom decoding initialization to handle missing fields
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString
        title = try container.decode(String.self, forKey: .title)
        introduction = try container.decode(String.self, forKey: .introduction)
        sections = try container.decode([ContentSection].self, forKey: .sections)
        conclusion = try container.decode(String.self, forKey: .conclusion)
        
        // Set default timestamp if not present in JSON
        timestamp = try container.decodeIfPresent(Date.self, forKey: .timestamp) ?? Date()
        
        // Set default type if not present in JSON
        type = try container.decodeIfPresent(DreamContentType.self, forKey: .type) ?? .dreamingFact
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, title, introduction, sections, conclusion, timestamp, type
    }
}

// Extend the imported DreamContentType instead of redefining it
extension DreamContentType {
    // Add the new case values
    static let dreamFact = DreamContentType.dreamingFact // Map to existing case
    static let lucidDreamingLesson = DreamContentType.lucidDreaming // Map to existing case
    
    // Add description support for backward compatibility
    public var details: String {
        switch self {
        case .dailyRitual:
            return "A ritual or habit for the day that can help enhance your dreaming process and quality"
        case .lucidDreaming:
            return "Learn how to become conscious during your dreams with these techniques and best practices"
        case .dreamingFact:
            return "Discover fascinating facts and insights about dreaming and sleep"
        default:
            return "Dream insight content"
        }
    }
    
    // Get the custom prompt for the new content types
    var customPrompt: String {
        switch self {
        case _ where self == DreamContentType.dreamFact:
            return """
            Generate a fascinating scientific fact about dreams or the science of sleep. Format as follows:
            
            Title: A concise, attention-grabbing title
            Introduction: A brief, intriguing statement about the fact (1-2 sentences)
            Sections: 2 short sections with headings and content explaining the science
            Conclusion: A thought-provoking closing statement
            
            Focus on being scientifically accurate while keeping the language accessible. Include one surprising or counter-intuitive aspect.
            """
        case _ where self == DreamContentType.lucidDreamingLesson:
            return """
            Generate a practical lesson about lucid dreaming techniques. Format as follows:
            
            Title: A descriptive title for the lesson
            Introduction: Brief explanation of what this lesson will teach (1-2 sentences)
            Sections: 2-3 sections covering specific techniques, tips or exercises
            Conclusion: A motivational closing statement
            
            Focus on practical advice that beginners can easily follow. Keep the tone encouraging and supportive.
            """
        default:
            return self.prompt
        }
    }
}

class OpenAIService {
    private let apiKey: String
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.lunara", category: "DreamService")
    private let model = "gpt-4-turbo-preview"
    
    // Helper function to get human-readable language name
    private func getLanguageName(from languageCode: String) -> String {
        let locale = Locale(identifier: languageCode)
        if let languageName = locale.localizedString(forLanguageCode: languageCode) {
            return languageName.capitalized
        }
        return languageCode
    }
    
    // More robust language detection with fallback
    private func detectLanguage(from text: String) -> String {
        // For very short texts, default to English to avoid inaccurate detection
        if text.count < 10 {
            return "en"
        }
        
        // Use NSLinguisticTagger for language detection
        if let detectedLanguage = NSLinguisticTagger.dominantLanguage(for: text) {
            log("Successfully detected language: \(detectedLanguage)")
            return detectedLanguage
        }
        
        // If detection fails, attempt with a larger chunk if possible
        if text.count > 100 {
            let shorterText = String(text.prefix(100))
            if let detectedLanguage = NSLinguisticTagger.dominantLanguage(for: shorterText) {
                log("Detected language using shorter sample: \(detectedLanguage)")
                return detectedLanguage
            }
        }
        
        // Fallback to English if detection fails
        log("Language detection failed, defaulting to English")
        return "en"
    }
    
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
        
        // Use the enhanced language detection
        let inputLanguage = detectLanguage(from: description)
        let languageName = getLanguageName(from: inputLanguage)
        log("Detected language: \(languageName) (\(inputLanguage))")
        
        let prompt = """
        Analyze this dream and respond with ONLY a JSON object. No other text or formatting:
        
        Dream Description: \(description)
        Did it wake them up: \(didWakeUp == true ? "Yes" : didWakeUp == false ? "No" : "Unknown")
        Had negative emotions: \(hadNegativeEmotions == true ? "Yes" : hadNegativeEmotions == false ? "No" : "Unknown")
        Intensity Level (1-10): \(intensityLevel)
        
        IMPORTANT: The dream is written in \(languageName) language. Your response MUST be in the SAME LANGUAGE as the dream description.
        
        Required JSON format:
        {
            "dreamName": "A short, catchy title for the dream (max 50 characters)",
            "quickOverview": "2-3 sentences summarizing the dream's meaning",
            "inDepthInterpretation": "A detailed analysis split into two paragraphs",
            "dailyLifeConnection": "One paragraph explaining how this dream connects to daily life",
            "recommendations": "3-4 bullet points of advice based on the dream, each on a new line",
            "refinedDescription": "The original dream description lightly refined with proper grammar, punctuation, and organization, while preserving the original meaning and experience"
        }
        """
        
        let messages: [[String: Any]] = [
            ["role": "system", "content": "You are a dream interpreter who can interpret dreams and respond in multiple languages. Respond only with the exact JSON format requested, in the SAME LANGUAGE as the user's dream description. No other text or formatting."],
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
        
        // Default language is English for generic content
        let contentLanguage = "en"
        let languageName = getLanguageName(from: contentLanguage)
        
        let messages: [[String: Any]] = [
            ["role": "system", "content": "You are a dream expertise assistant specializing in helping users improve their dreaming experience. Respond with a JSON object according to the specified format in English."],
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

    private func fetchDreamContent(prompt: String, type: DreamContentType) async throws -> DreamContent {
        // Create a message array with the system prompt and user message
        let messages: [[String: Any]] = [
            ["role": "system", "content": "You are an expert on dreams, sleep science, and lucid dreaming techniques."],
            ["role": "user", "content": prompt]
        ]
        
        // Create the request body
        let requestBody: [String: Any] = [
            "model": self.model,
            "messages": messages,
            "temperature": 0.7
        ]
        
        // Create the request
        guard let url = URL(string: baseURL) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        // Set the request body
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        // Log that we're making a request
        print("🔵 Fetching \(type.rawValue) from OpenAI...")
        
        // Perform the request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check for HTTP errors
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ Error: Invalid HTTP response")
            throw URLError(.badServerResponse)
        }
        
        guard httpResponse.statusCode == 200 else {
            let responseString = String(data: data, encoding: .utf8) ?? "No response body"
            print("❌ HTTP Error \(httpResponse.statusCode): \(responseString)")
            throw URLError(.badServerResponse)
        }
        
        // Parse the JSON response
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let choices = json["choices"] as? [[String: Any]],
              let firstChoice = choices.first,
              let message = firstChoice["message"] as? [String: Any],
              let content = message["content"] as? String else {
            print("❌ Error: Could not parse JSON response")
            throw URLError(.cannotParseResponse)
        }
        
        // Process the content into our model
        let processedContent = try processContentForDreamContent(content, type: type)
        print("✅ Successfully fetched \(type.rawValue)")
        
        return processedContent
    }

    private func processContentForDreamContent(_ content: String, type: DreamContentType) throws -> DreamContent {
        // Initialize empty values
        var title = "Dream Insight"
        var introduction = ""
        var sections: [DreamContent.ContentSection] = []
        var conclusion = ""
        
        // Split the content by newlines
        let lines = content.components(separatedBy: .newlines)
        
        // Variables to track current section
        var currentHeading: String = ""
        var currentContent: String = ""
        var parsingSection = false
        
        // Process each line
        for line in lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Skip empty lines
            if trimmedLine.isEmpty {
                continue
            }
            
            // Check if this is a title line
            if trimmedLine.lowercased().hasPrefix("title:") {
                title = trimmedLine.replacingOccurrences(of: "Title:", with: "", options: .caseInsensitive).trimmingCharacters(in: .whitespaces)
                // Clean up markdown formatting
                title = cleanMarkdown(title)
                continue
            }
            
            // Check if this is an introduction line
            if trimmedLine.lowercased().hasPrefix("introduction:") {
                introduction = trimmedLine.replacingOccurrences(of: "Introduction:", with: "", options: .caseInsensitive).trimmingCharacters(in: .whitespaces)
                introduction = cleanMarkdown(introduction)
                continue
            } else if introduction.isEmpty && !parsingSection && !trimmedLine.lowercased().hasPrefix("section") && !trimmedLine.contains(":") {
                // Assume this is the introduction if we haven't found it yet and it's not a section
                introduction = cleanMarkdown(trimmedLine)
                continue
            }
            
            // Check if this is a conclusion line
            if trimmedLine.lowercased().hasPrefix("conclusion:") {
                conclusion = trimmedLine.replacingOccurrences(of: "Conclusion:", with: "", options: .caseInsensitive).trimmingCharacters(in: .whitespaces)
                conclusion = cleanMarkdown(conclusion)
                continue
            }
            
            // Check for section headings
            // Look for patterns like "1.", "Section 1:", "Technique 1:", "Key Point 1:", "#", "##" etc.
            let sectionHeadingPattern = trimmedLine.lowercased().hasPrefix("section") || 
                                       trimmedLine.lowercased().hasPrefix("technique") || 
                                       trimmedLine.lowercased().hasPrefix("key point") || 
                                       trimmedLine.hasPrefix("#") ||
                                       (trimmedLine.count < 60 && trimmedLine.hasSuffix(":")) ||
                                       (trimmedLine.range(of: "^\\d+\\.", options: .regularExpression) != nil)
            
            if sectionHeadingPattern {
                // If we were already parsing a section, save it
                if !currentHeading.isEmpty && !currentContent.isEmpty {
                    let newSection = DreamContent.ContentSection(
                        heading: cleanMarkdown(currentHeading),
                        content: cleanMarkdown(currentContent)
                    )
                    sections.append(newSection)
                    currentContent = ""
                }
                
                // Start a new section
                parsingSection = true
                // Clean up section heading by removing numbers, colons, hashtags, etc.
                currentHeading = trimmedLine
                    .replacingOccurrences(of: "Section [0-9]+:", with: "", options: .regularExpression)
                    .replacingOccurrences(of: "Technique [0-9]+:", with: "", options: .regularExpression)
                    .replacingOccurrences(of: "Key Point [0-9]+:", with: "", options: .regularExpression)
                    .replacingOccurrences(of: "^\\d+\\.", with: "", options: .regularExpression)
                    .replacingOccurrences(of: "^#+\\s*", with: "", options: .regularExpression)
                    .replacingOccurrences(of: ":$", with: "", options: .regularExpression)
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                
                currentHeading = cleanMarkdown(currentHeading)
                continue
            }
            
            // If we're parsing a section, add to the current content
            if parsingSection {
                if currentContent.isEmpty {
                    currentContent = trimmedLine
                } else {
                    currentContent += "\n" + trimmedLine
                }
                continue
            }
            
            // Check if this could be the conclusion (if we haven't found it yet)
            if conclusion.isEmpty && !parsingSection && sections.count > 0 {
                if conclusion.isEmpty {
                    conclusion = cleanMarkdown(trimmedLine)
                } else {
                    conclusion += "\n" + cleanMarkdown(trimmedLine)
                }
            }
        }
        
        // Add the last section if we have one
        if !currentHeading.isEmpty && !currentContent.isEmpty {
            let lastSection = DreamContent.ContentSection(
                heading: cleanMarkdown(currentHeading),
                content: cleanMarkdown(currentContent)
            )
            sections.append(lastSection)
        }
        
        // If no sections were found but we have text content, try to create sections
        if sections.isEmpty && !introduction.isEmpty {
            // Process free-form text by looking for patterns like paragraphs
            let paragraphs = introduction.components(separatedBy: "\n\n")
            if paragraphs.count >= 2 {
                // Use the first paragraph as introduction
                introduction = paragraphs[0]
                
                // Create sections from remaining paragraphs
                for (index, paragraph) in paragraphs.dropFirst().enumerated() {
                    if !paragraph.isEmpty {
                        let sectionTitle: String
                        if type == DreamContentType.dreamFact {
                            sectionTitle = index == 0 ? "The Science" : "Research Context"
                        } else {
                            sectionTitle = index == 0 ? "Lucid Dreaming Technique" : "Practice Method"
                        }
                        
                        sections.append(DreamContent.ContentSection(
                            heading: sectionTitle,
                            content: cleanMarkdown(paragraph)
                        ))
                    }
                }
            }
        }
        
        // Still no sections? Create default ones
        if sections.isEmpty {
            if type == DreamContentType.lucidDreamingLesson {
                // Create multiple default sections for lucid dreaming lessons
                sections.append(DreamContent.ContentSection(
                    heading: "Reality Checks",
                    content: "Perform regular reality checks throughout the day by asking yourself if you're dreaming. Try pushing your finger through your palm or looking at a clock, then looking away and back again. In dreams, these tests often yield surprising results."
                ))
                
                sections.append(DreamContent.ContentSection(
                    heading: "Dream Journaling",
                    content: "Keep a dream journal by your bed and write down your dreams immediately upon waking. This practice improves dream recall and helps you recognize dream patterns and recurring dream signs."
                ))
            } else {
                // Create a default section
                let defaultSection = DreamContent.ContentSection(
                    heading: type == DreamContentType.dreamFact ? "Dream Science" : "Lucid Dreaming Technique",
                    content: "Dreams occur primarily during REM sleep, when brain activity increases to levels similar to wakefulness. During this state, the prefrontal cortex (responsible for logical thinking) is less active, which explains the often illogical nature of dreams."
                )
                sections.append(defaultSection)
            }
        }
        
        // If conclusion is empty, create a default one
        if conclusion.isEmpty {
            if type == DreamContentType.lucidDreamingLesson {
                conclusion = "With regular practice and patience, you can develop the ability to become lucid in your dreams. Start with these simple techniques and gradually expand your practice as you gain experience."
            } else {
                conclusion = "Understanding the science behind our dreams gives us fascinating insights into how our minds work during sleep and the potential benefits of paying attention to our dream experiences."
            }
        }
        
        // Create our model
        let dreamContent = DreamContent(
            id: UUID().uuidString,
            title: title,
            introduction: introduction,
            sections: sections,
            conclusion: conclusion,
            timestamp: Date(),
            type: type
        )
        
        return dreamContent
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
    let refinedDescription: String?
}

// Add these new methods to the OpenAIService class
extension OpenAIService {
    
    // Generate a daily lucid dreaming lesson
    func generateLucidDreamingLesson() async throws -> DreamContent {
        return try await fetchDreamContent(prompt: DreamContentType.lucidDreamingLesson.customPrompt, type: DreamContentType.lucidDreamingLesson)
    }
    
    // Generate a daily dream fact
    func generateDailyDreamFact() async throws -> DreamContent {
        return try await fetchDreamContent(prompt: DreamContentType.dreamFact.customPrompt, type: DreamContentType.dreamFact)
    }
    
    // Helper method to fetch dream content with custom messages
    private func fetchCustomDreamContent(messages: [[String: Any]]) async throws -> DreamContent {
        log("Starting custom dream content fetch...")
        
        let requestBody: [String: Any] = [
            "model": "gpt-4-turbo-preview",
            "messages": messages,
            "temperature": 0.7,
            "response_format": ["type": "json_object"]
        ]
        
        log("Preparing API request for custom dream content...")
        
        guard let url = URL(string: baseURL) else {
            log("❌ Error: Invalid URL")
            throw NSError(domain: "OpenAIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        log("Sending request to OpenAI API for custom dream content...")
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

// Helper function to clean markdown from text
private func cleanMarkdown(_ text: String) -> String {
    var cleanText = text
    
    // Remove markdown bold/italic indicators
    cleanText = cleanText.replacingOccurrences(of: "\\*\\*(.+?)\\*\\*", with: "$1", options: .regularExpression)
    cleanText = cleanText.replacingOccurrences(of: "\\*(.+?)\\*", with: "$1", options: .regularExpression)
    cleanText = cleanText.replacingOccurrences(of: "_(.+?)_", with: "$1", options: .regularExpression)
    cleanText = cleanText.replacingOccurrences(of: "__(.+?)__", with: "$1", options: .regularExpression)
    
    // Remove markdown headings
    cleanText = cleanText.replacingOccurrences(of: "^#+\\s*", with: "", options: .regularExpression)
    
    // Remove markdown links but keep the text
    cleanText = cleanText.replacingOccurrences(of: "\\[(.+?)\\]\\(.+?\\)", with: "$1", options: .regularExpression)
    
    // Remove backslash escapes
    cleanText = cleanText.replacingOccurrences(of: "\\\\", with: "")
    
    return cleanText
}