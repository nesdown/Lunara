import SwiftUI

public class ThemeSettings: ObservableObject {
    @Published public var colorScheme: ColorScheme? {
        didSet {
            // Save to UserDefaults whenever the value changes
            if let colorScheme = colorScheme {
                UserDefaults.standard.set(colorScheme == .dark ? "dark" : "light", forKey: "appColorScheme")
            } else {
                UserDefaults.standard.removeObject(forKey: "appColorScheme")
            }
        }
    }
    
    public init(colorScheme: ColorScheme? = nil) {
        // Load from UserDefaults or use default (light mode)
        if let savedTheme = UserDefaults.standard.string(forKey: "appColorScheme") {
            self.colorScheme = savedTheme == "dark" ? .dark : .light
        } else {
            // If no saved preference, default to light mode
            self.colorScheme = .light
        }
    }
} 