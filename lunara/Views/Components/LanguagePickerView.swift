import SwiftUI

struct LanguagePickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    var selectedLanguage: String?
    var onSelect: (String) -> Void
    
    // Expanded language options
    private let languages = [
        "system": "System Default",
        "en": "English",
        "es": "Español",
        "uk": "Українська",   // Ukrainian
        "fr": "Français",     // French
        "de": "Deutsch",      // German
        "it": "Italiano",     // Italian
        "pt": "Português",    // Portuguese
        "pl": "Polski",       // Polish
        "nl": "Nederlands",   // Dutch
        "zh": "中文",         // Chinese
        "ja": "日本語",       // Japanese
        "ko": "한국어"        // Korean
    ]
    
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    // Break up the complex ForEach into a simpler structure
                    ForEach(Array(languages.keys.sorted()), id: \.self) { code in
                        LanguageRow(
                            code: code, 
                            name: languages[code] ?? code,
                            isSelected: selectedLanguage == code || (selectedLanguage == nil && code == "system"),
                            primaryPurple: primaryPurple,
                            onSelect: {
                                // Save the selected language and trigger UI update
                                selectLanguage(code)
                                dismiss()
                            }
                        )
                    }
                }
                
                // Add informational footer about language support
                Section(footer: Text("All languages are now fully supported. Your app interface will display in the selected language.")
                    .font(.footnote)
                    .foregroundColor(.secondary)) {
                    EmptyView()
                }
            }
            .navigationTitle(StringsProvider.shared.localizedString("select_language"))
            .navigationBarItems(trailing: Button(StringsProvider.shared.localizedString("cancel")) {
                dismiss()
            })
        }
    }
    
    // Method to handle language selection and ensure UI updates
    private func selectLanguage(_ code: String) {
        if code == "system" {
            // Clear the language setting
            UserDefaults.standard.removeObject(forKey: "languageCode")
        } else {
            // Save the selected language
            UserDefaults.standard.set(code, forKey: "languageCode")
        }
        
        // Notify the StringsProvider of the language change which will broadcast the change notification
        StringsProvider.shared.updateLanguage(code == "system" ? nil : code)
        
        // Trigger the callback
        onSelect(code)
    }
}

// Extract language row into a separate view component
struct LanguageRow: View {
    let code: String
    let name: String
    let isSelected: Bool
    let primaryPurple: Color
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack {
                // Language icon
                if code == "system" {
                    Image(systemName: "gear")
                        .foregroundColor(primaryPurple)
                } else {
                    Text(code.uppercased())
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(primaryPurple)
                }
                
                // Language name
                if code == "system" {
                    Text(StringsProvider.shared.localizedString("system_default"))
                        .foregroundColor(.primary)
                } else {
                    Text(name)
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                // Checkmark for selected language
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(primaryPurple)
                }
            }
        }
    }
} 