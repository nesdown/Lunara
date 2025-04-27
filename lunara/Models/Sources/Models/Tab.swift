import SwiftUI

public enum Tab: String, CaseIterable {
    case dreams = "tab_dreams"
    case journal = "tab_journal"
    case learn = "tab_learn"
    case profile = "tab_profile"
    
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