import SwiftUI
import Models

struct MainView: View {
    @StateObject private var themeSettings = ThemeSettings()
    @State private var selectedTab: Tab = .dreams
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .dreams:
                    HomeView()
                case .journal:
                    JournalView()
                case .learn:
                    LearnView()
                case .profile:
                    ProfileView()
                }
            }
            
            CustomTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(.keyboard)
        .environmentObject(themeSettings)
        .preferredColorScheme(themeSettings.colorScheme)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
} 