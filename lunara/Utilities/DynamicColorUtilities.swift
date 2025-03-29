import SwiftUI

// MARK: - Dynamic Color Utilities
struct DynamicColors {
    // Main app colors
    static let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    static let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    static let darkPurple = Color(red: 102/255, green: 51/255, blue: 153/255)
    static let deepPurple = Color(red: 76/255, green: 40/255, blue: 130/255)
    
    // Dynamic colors for backgrounds
    static var backgroundPrimary: Color {
        Color(.systemBackground)
    }
    
    static var backgroundSecondary: Color {
        Color(.secondarySystemBackground)
    }
    
    static var backgroundTertiary: Color {
        Color(.tertiarySystemBackground)
    }
    
    static var groupedBackground: Color {
        Color(.systemGroupedBackground)
    }
    
    static var cardBackground: Color {
        @Environment(\.colorScheme) var colorScheme
        return colorScheme == .dark ? Color(white: 0.15) : .white
    }
    
    // Dynamic colors for text
    static var textPrimary: Color {
        Color(.label)
    }
    
    static var textSecondary: Color {
        Color(.secondaryLabel)
    }
    
    static var textTertiary: Color {
        Color(.tertiaryLabel)
    }
    
    // Dynamic colors for UI elements
    static var separator: Color {
        Color(.separator)
    }
    
    static var fill: Color {
        Color(.systemFill)
    }
    
    // Dynamic gray colors
    static var gray1: Color {
        Color(.systemGray)
    }
    
    static var gray2: Color {
        Color(.systemGray2)
    }
    
    static var gray3: Color {
        Color(.systemGray3)
    }
    
    static var gray4: Color {
        Color(.systemGray4)
    }
    
    static var gray5: Color {
        Color(.systemGray5)
    }
    
    static var gray6: Color {
        Color(.systemGray6)
    }
}

// Extension to get dynamic card background based on color scheme
extension View {
    func cardBackgroundColor() -> Color {
        @Environment(\.colorScheme) var colorScheme
        return colorScheme == .dark ? Color(white: 0.15) : .white
    }
    
    func cardStyle(cornerRadius: CGFloat = 16) -> some View {
        self.background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(cardBackgroundColor())
        )
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(DynamicColors.primaryPurple.opacity(0.15), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 4)
    }
}

// View modifier for standard card style
struct CardStyle: ViewModifier {
    var cornerRadius: CGFloat = 16
    var includeShadow: Bool = true
    
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(colorScheme == .dark ? Color(white: 0.15) : .white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(DynamicColors.primaryPurple.opacity(0.15), lineWidth: 1)
            )
            .shadow(color: includeShadow ? Color.black.opacity(0.05) : .clear, radius: includeShadow ? 15 : 0, x: 0, y: includeShadow ? 4 : 0)
    }
} 