import SwiftUI

public class ThemeSettings: ObservableObject {
    @AppStorage("isDarkMode") public var isDarkMode: Bool = false {
        didSet {
            colorScheme = isDarkMode ? .dark : .light
        }
    }
    
    @Published public var colorScheme: ColorScheme = .light
    
    public init() {
        colorScheme = isDarkMode ? .dark : .light
    }
} 