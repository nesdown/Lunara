import SwiftUI
import Models

struct MainView: View {
    @StateObject private var themeSettings = ThemeSettings()
    @State private var selectedTab: Tab = .dreams
    @State private var refreshLanguage: Bool = false // State to trigger view refresh
    
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
        .id(refreshLanguage) // Force view refresh when language changes
        .ignoresSafeArea(.keyboard)
        .environmentObject(themeSettings)
        .preferredColorScheme(themeSettings.colorScheme)
        .onAppear {
            // Initialize language
            setupLanguage()
            
            // Listen for language change notifications
            NotificationCenter.default.addObserver(
                forName: .languageChanged,
                object: nil,
                queue: .main
            ) { _ in
                // Toggle refresh to force view update
                print("MainView: Received language change notification, refreshing UI")
                DispatchQueue.main.async {
                    refreshLanguage.toggle()
                }
            }
        }
    }
    
    // Break out the language setup into a separate method
    private func setupLanguage() {
        // Get the language code from UserDefaults directly
        let savedLanguage = UserDefaults.standard.string(forKey: "languageCode")
        print("MainView: Setting up language with code: \(savedLanguage ?? "system default")")
        StringsProvider.shared.updateLanguage(savedLanguage)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
} 