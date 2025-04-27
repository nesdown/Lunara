import SwiftUI

public class ThemeSettings: ObservableObject {
    @Published public var colorScheme: ColorScheme? = nil
    
    public init(colorScheme: ColorScheme? = nil) {
        self.colorScheme = colorScheme
    }
} 