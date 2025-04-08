import SwiftUI

public enum Tab: String, CaseIterable {
    case dreams = "Dreams"
    case journal = "Journal"
    case learn = "Learn"
    case profile = "Profile"
    
    public var icon: String {
        switch self {
        case .dreams:
            return "moon.stars.fill"
        case .journal:
            return "book.closed.fill"
        case .learn:
            return "lightbulb.fill"
        case .profile:
            return "person.crop.circle.fill"
        }
    }
} 