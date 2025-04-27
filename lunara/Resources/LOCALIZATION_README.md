# Lunara App Localization Guide

This document provides instructions for adding new language translations to the Lunara app.

## Currently Supported Languages

The app is currently localized in:
- English (en)
- Spanish (es)
- Ukrainian (uk)
- French (fr)
- German (de)
- Italian (it)
- Portuguese (pt)
- Polish (pl)
- Dutch (nl)
- Chinese (zh)
- Japanese (ja)
- Korean (ko)

## Adding a New Language

To add support for a new language, follow these steps:

1. **Create a language directory**
   ```bash
   mkdir -p lunara/Resources/<language_code>.lproj
   ```
   Where `<language_code>` is the ISO 639-1 two-letter language code (e.g., "fr" for French).

2. **Create a Localizable.strings file**
   Create a new file named `Localizable.strings` in the language directory with translations for all keys.
   
   You can copy the existing English file as a template:
   ```bash
   cp lunara/Resources/en.lproj/Localizable.strings lunara/Resources/<language_code>.lproj/
   ```
   
   Then edit the copied file to provide translations for each string.

3. **Update the language selection UI (optional)**
   The app's language picker already includes several languages. If you want to add a language that isn't listed yet, update the `languages` dictionary in `lunara/Views/Components/LanguagePickerView.swift`.

## Translation File Format

The `Localizable.strings` file uses the following format:
```
"key" = "translated_text";
```

For example:
```
"home_title" = "Home";  // English
"home_title" = "Inicio";  // Spanish
```

Make sure to maintain all the keys from the English file, only changing the translated values.

## String Formatting

Some strings contain format specifiers (e.g., `%@`, `%d`) which are placeholders for dynamic values. Make sure these placeholders remain in the same order in your translations.

Example:
```
"daily_reminder_at" = "Daily reminder at %@";  // English
"daily_reminder_at" = "Recordatorio diario a las %@";  // Spanish
```

## Testing Translations

To test your translations:
1. Build and run the app
2. Go to Settings > Language
3. Select your newly added language
4. Verify that text throughout the app is correctly translated

## Reporting Issues

If you find any missing translations or errors, please report them to the development team. 