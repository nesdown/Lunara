import SwiftUI
import Foundation

public class ThemeSettings: ObservableObject {
    @Published public var colorScheme: ColorScheme? = nil
    @Published public var languageCode: String? = nil
    
    public init(colorScheme: ColorScheme? = nil, languageCode: String? = nil) {
        self.colorScheme = colorScheme
        self.languageCode = UserDefaults.standard.string(forKey: "languageCode") ?? languageCode
    }
    
    // Get the current effective language (user selected or system default)
    public var currentLanguage: String {
        if let userLanguage = languageCode, !userLanguage.isEmpty {
            return userLanguage
        } else {
            // Return system language code or default to English
            return Locale.current.language.languageCode?.identifier ?? "en"
        }
    }
    
    // Reset to use system language
    public func useSystemLanguage() {
        self.languageCode = nil
        UserDefaults.standard.removeObject(forKey: "languageCode")
    }
    
    // Save language code to UserDefaults
    public func setLanguage(_ code: String?) {
        self.languageCode = code
        if let code = code {
            UserDefaults.standard.set(code, forKey: "languageCode")
        } else {
            UserDefaults.standard.removeObject(forKey: "languageCode")
        }
    }
} 