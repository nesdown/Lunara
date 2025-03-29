import Foundation
import SwiftUI

// Add our DreamContent model extension
extension DreamContent: @unchecked Sendable {}
extension DreamContentType: @unchecked Sendable {}

class DreamContentViewModel: ObservableObject {
    private let openAIService = OpenAIService()
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentContent: DreamContent?
    @Published var contentType: DreamContentType
    
    // Cache for each content type to avoid unnecessary API calls
    private var contentCache: [DreamContentType: DreamContent] = [:]
    
    init(contentType: DreamContentType) {
        self.contentType = contentType
        
        // Check if we have cached content that's from today
        if let cachedContent = UserDefaults.standard.data(forKey: "cached_\(contentType.rawValue)") {
            do {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode(DreamContent.self, from: cachedContent)
                
                // Only use cached content if it's from today
                let calendar = Calendar.current
                if calendar.isDateInToday(decoded.timestamp) {
                    self.currentContent = decoded
                    self.contentCache[contentType] = decoded
                }
            } catch {
                print("Error decoding cached content: \(error)")
            }
        }
    }
    
    func fetchContent() async {
        // First check if we have a cached version from today
        if let cached = contentCache[contentType], Calendar.current.isDateInToday(cached.timestamp) {
            DispatchQueue.main.async {
                self.currentContent = cached
            }
            return
        }
        
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        do {
            let content = try await openAIService.fetchDreamContent(for: contentType)
            
            DispatchQueue.main.async {
                self.currentContent = content
                self.isLoading = false
                self.contentCache[self.contentType] = content
                
                // Cache the content
                do {
                    let encoder = JSONEncoder()
                    let data = try encoder.encode(content)
                    UserDefaults.standard.set(data, forKey: "cached_\(self.contentType.rawValue)")
                } catch {
                    print("Error caching content: \(error)")
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.isLoading = false
                self.errorMessage = "Failed to load content: \(error.localizedDescription)"
            }
        }
    }
    
    func shareContent() {
        guard let content = currentContent else { return }
        
        var shareText = "\(content.title)\n\n"
        shareText += "\(content.introduction)\n\n"
        
        for section in content.sections {
            shareText += "## \(section.heading)\n"
            shareText += "\(section.content)\n\n"
        }
        
        shareText += content.conclusion
        
        shareText += "\n\nShared from the Lunara app"
        
        let av = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            // Find the presented view controller to present from
            var presentedVC = rootViewController
            while let presented = presentedVC.presentedViewController {
                presentedVC = presented
            }
            presentedVC.present(av, animated: true)
        }
    }
} 