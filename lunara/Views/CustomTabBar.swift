import SwiftUI

enum Tab: String, CaseIterable {
    case dreams = "Dreams"
    case journal = "Journal"
    case learn = "Learn"
    case profile = "Profile"
    
    var icon: String {
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

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    @State private var showDreamEntry = false
    let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(Tab.allCases.enumerated()), id: \.element) { index, tab in
                if index == Tab.allCases.count / 2 {
                    // Center Plus Button
                    Button(action: {
                        // Show the dream entry flow
                        showDreamEntry = true
                    }) {
                        ZStack {
                            Circle()
                                .fill(primaryPurple)
                                .frame(width: 48, height: 48)
                                .shadow(color: primaryPurple.opacity(0.3), radius: 10, x: 0, y: 4)
                            
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.white)
                        }
                    }
                    .frame(width: 80) // Fixed width for center item
                    .sheet(isPresented: $showDreamEntry) {
                        DreamEntryFlow()
                    }
                }
                
                TabButton(
                    tab: tab,
                    isSelected: selectedTab == tab,
                    primaryPurple: primaryPurple,
                    action: { selectedTab = tab }
                )
                .frame(maxWidth: .infinity) // Distribute remaining space evenly
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 24) // Reduced from 34 to 24
        .background(
            Rectangle()
                .fill(Color(UIColor.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 20, x: 0, y: -5)
                .ignoresSafeArea()
        )
    }
}

struct TabButton: View {
    let tab: Tab
    let isSelected: Bool
    let primaryPurple: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: 20, weight: .medium))
                    .frame(height: 24)
                
                Text(tab.rawValue)
                    .font(.system(size: 10, weight: .medium))
            }
            .foregroundColor(isSelected ? primaryPurple : .gray.opacity(0.7))
        }
    }
} 