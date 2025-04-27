import SwiftUI

// Add a notification name for language changes
extension Notification.Name {
    static let languageChanged = Notification.Name("com.lunara.languageChanged")
}

// A utility for providing localized strings with support for custom language selection
class StringsProvider: ObservableObject {
    static let shared = StringsProvider()
    
    @Published var currentBundle: Bundle = Bundle.main
    
    private init() {
        // Initialize with the saved language code if any
        let savedCode = UserDefaults.standard.string(forKey: "languageCode")
        updateLanguage(savedCode)
    }
    
    // Update the bundle based on language code
    func updateLanguage(_ languageCode: String?) {
        if let code = languageCode, !code.isEmpty {
            // Find the path for the specified language
            if let path = Bundle.main.path(forResource: code, ofType: "lproj"),
               let bundle = Bundle(path: path) {
                self.currentBundle = bundle
                
                // Log for debugging
                print("StringsProvider: Updated to language \(code) with bundle: \(bundle)")
                
                // Post notification that language has changed
                NotificationCenter.default.post(name: .languageChanged, object: nil)
                return
            } else {
                // Log failure for debugging
                print("StringsProvider: Failed to find bundle for language \(code)")
            }
        }
        
        // Fallback to main bundle (system language)
        self.currentBundle = Bundle.main
        
        // Log for debugging
        print("StringsProvider: Using system language with main bundle")
        
        // Post notification that language has changed
        NotificationCenter.default.post(name: .languageChanged, object: nil)
    }
    
    // Get localized string
    func localizedString(_ key: String) -> String {
        // First try to get the localized string from the current bundle
        let localizedString = NSLocalizedString(key, tableName: "Localizable", bundle: currentBundle, value: "", comment: "")
        
        // If we got a valid localized string (not empty and not the key itself), return it
        if !localizedString.isEmpty && localizedString != key {
            return localizedString
        }
        
        // Otherwise try the main bundle as fallback
        return NSLocalizedString(key, tableName: "Localizable", bundle: Bundle.main, value: key, comment: "")
    }
    
    // Get localized string with format
    func localizedString(_ key: String, with arguments: CVarArg...) -> String {
        let format = localizedString(key)
        return String(format: format, arguments: arguments)
    }
} 