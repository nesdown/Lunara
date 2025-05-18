import SwiftUI

struct TopBarButton: View, Identifiable {
    let id = UUID()
    let icon: String
    let action: () -> Void
    let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(primaryPurple.opacity(0.15))
                    .frame(width: 40, height: 40)
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(primaryPurple)
            }
        }
    }
}

struct TopBarView: View {
    let titleView: AnyView
    let primaryPurple: Color
    let colorScheme: ColorScheme
    let rightButtons: [TopBarButton]
    
    init(title: String, primaryPurple: Color, colorScheme: ColorScheme, rightButtons: [TopBarButton] = []) {
        self.titleView = AnyView(
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        )
        self.primaryPurple = primaryPurple
        self.colorScheme = colorScheme
        self.rightButtons = rightButtons
    }
    
    init<V: View>(titleView: V, primaryPurple: Color, colorScheme: ColorScheme, rightButtons: [TopBarButton] = []) {
        self.titleView = AnyView(titleView)
        self.primaryPurple = primaryPurple
        self.colorScheme = colorScheme
        self.rightButtons = rightButtons
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                titleView
                
                Spacer()
                
                HStack(spacing: 16) {
                    ForEach(rightButtons) { button in
                        button
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(
                colorScheme == .dark ? Color(white: 0.15) : .white
            )
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(primaryPurple.opacity(0.15))
                    .offset(y: 1),
                alignment: .bottom
            )
        }
        .zIndex(1)
        .background(
            (colorScheme == .dark ? Color(white: 0.15) : .white)
                .ignoresSafeArea(edges: .top)
        )
    }
} 