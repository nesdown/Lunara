import Foundation
import UIKit

// MARK: - HapticManager
/// A service class that provides haptic feedback throughout the app
class HapticManager {
    static let shared = HapticManager()
    
    // Feedback generators
    private let lightGenerator = UIImpactFeedbackGenerator(style: .light)
    private let mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
    private let heavyGenerator = UIImpactFeedbackGenerator(style: .heavy)
    private let selectionGenerator = UISelectionFeedbackGenerator()
    private let notificationGenerator = UINotificationFeedbackGenerator()
    
    // UserDefaults Key
    private let hapticEnabledKey = "isHapticsEnabled"
    
    private init() {
        // Pre-prepare generators for better responsiveness
        lightGenerator.prepare()
        mediumGenerator.prepare()
        selectionGenerator.prepare()
        notificationGenerator.prepare()
    }
    
    /// Checks if haptic feedback is enabled in settings
    private var isEnabled: Bool {
        return UserDefaults.standard.bool(forKey: hapticEnabledKey)
    }
    
    // MARK: - Public Methods
    
    /// Provides a light impact feedback for subtle interactions
    /// - Parameter prepare: Whether to prepare the generator for the next use
    func light(prepare: Bool = true) {
        guard isEnabled else { return }
        lightGenerator.impactOccurred()
        if prepare { lightGenerator.prepare() }
    }
    
    /// Provides a medium impact feedback for standard interactions
    /// - Parameter prepare: Whether to prepare the generator for the next use
    func medium(prepare: Bool = true) {
        guard isEnabled else { return }
        mediumGenerator.impactOccurred()
        if prepare { mediumGenerator.prepare() }
    }
    
    /// Provides a heavy impact feedback for significant interactions
    /// - Parameter prepare: Whether to prepare the generator for the next use
    func heavy(prepare: Bool = true) {
        guard isEnabled else { return }
        heavyGenerator.impactOccurred()
        if prepare { heavyGenerator.prepare() }
    }
    
    /// Provides a selection feedback for selection changes
    /// - Parameter prepare: Whether to prepare the generator for the next use
    func selection(prepare: Bool = true) {
        guard isEnabled else { return }
        selectionGenerator.selectionChanged()
        if prepare { selectionGenerator.prepare() }
    }
    
    /// Provides a success notification feedback
    /// - Parameter prepare: Whether to prepare the generator for the next use
    func success(prepare: Bool = true) {
        guard isEnabled else { return }
        notificationGenerator.notificationOccurred(.success)
        if prepare { notificationGenerator.prepare() }
    }
    
    /// Provides a warning notification feedback
    /// - Parameter prepare: Whether to prepare the generator for the next use
    func warning(prepare: Bool = true) {
        guard isEnabled else { return }
        notificationGenerator.notificationOccurred(.warning)
        if prepare { notificationGenerator.prepare() }
    }
    
    /// Provides an error notification feedback
    /// - Parameter prepare: Whether to prepare the generator for the next use
    func error(prepare: Bool = true) {
        guard isEnabled else { return }
        notificationGenerator.notificationOccurred(.error)
        if prepare { notificationGenerator.prepare() }
    }
    
    // MARK: - Context-Specific Haptics
    
    /// Haptic feedback for navigating between pages/screens
    func pageTransition() {
        medium()
    }
    
    /// Haptic feedback for successful completion of a process
    func processCompleted() {
        success()
    }
    
    /// Haptic feedback for button presses
    func buttonPress() {
        light()
    }
    
    /// Haptic feedback for selecting an item in a list
    func itemSelected() {
        selection()
    }
    
    /// Haptic feedback for revealing important content or insight
    func revealInsight() {
        medium()
    }
    
    /// Haptic feedback for important milestones in onboarding
    func onboardingMilestone() {
        success()
    }
    
    /// Haptic feedback for dream journal entry completed
    func dreamEntrySaved() {
        success()
    }
    
    /// Haptic feedback for analysis result revealed
    func analysisRevealed() {
        heavy()
    }
} 