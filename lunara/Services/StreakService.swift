import Foundation

class StreakService: ObservableObject {
    static let shared = StreakService()
    
    // Keys for UserDefaults
    private let currentStreakKey = "currentStreak"
    private let bestStreakKey = "bestStreak"
    private let lastLogDateKey = "lastLogDate"
    private let streakInsightsShownKey = "streakInsightsShown"
    private let streakMilestonesKey = "streakMilestones"
    
    // Published properties for UI updates
    @Published var currentStreak: Int = 0
    @Published var bestStreak: Int = 0
    @Published var lastLogDate: Date?
    @Published var streakComplete: Bool = false
    @Published var unlockedMilestone: Int = 0
    
    // Constants
    let streakMilestones = [10, 21, 60, 90]
    
    private init() {
        loadStreakData()
    }
    
    private func loadStreakData() {
        currentStreak = UserDefaults.standard.integer(forKey: currentStreakKey)
        bestStreak = UserDefaults.standard.integer(forKey: bestStreakKey)
        lastLogDate = UserDefaults.standard.object(forKey: lastLogDateKey) as? Date
        
        // Check if the streak is broken
        checkAndUpdateStreak()
    }
    
    // Check if the streak is still valid or if it's been broken
    private func checkAndUpdateStreak() {
        guard let lastLog = lastLogDate else { return }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let lastLogDay = calendar.startOfDay(for: lastLog)
        
        // If last log was before yesterday, the streak is broken
        if lastLogDay < yesterday {
            resetStreak()
        }
    }
    
    // Reset the streak to 0
    private func resetStreak() {
        currentStreak = 0
        UserDefaults.standard.set(currentStreak, forKey: currentStreakKey)
        
        // Also reset the streakComplete flag
        streakComplete = false
    }
    
    // Log a dream and update the streak
    func logDreamForToday() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        // If already logged today, don't increment
        if let lastLog = lastLogDate, calendar.isDate(today, inSameDayAs: lastLog) {
            // Already logged today
            return
        }
        
        // Update the last log date to today
        lastLogDate = today
        UserDefaults.standard.set(today, forKey: lastLogDateKey)
        
        // Increment the streak
        currentStreak += 1
        UserDefaults.standard.set(currentStreak, forKey: currentStreakKey)
        
        // Update best streak if needed
        if currentStreak > bestStreak {
            bestStreak = currentStreak
            UserDefaults.standard.set(bestStreak, forKey: bestStreakKey)
        }
        
        // Check if a milestone is reached
        checkMilestone()
    }
    
    // Check if the current streak has reached a milestone
    private func checkMilestone() {
        if let milestone = getNextMilestone() {
            if currentStreak == milestone {
                unlockedMilestone = milestone
                markMilestoneShown(milestone: milestone, shown: false)
                streakComplete = true
            }
        }
    }
    
    // Get the next milestone based on current streak
    func getNextMilestone() -> Int? {
        // Filter milestones that are greater than current streak
        let upcomingMilestones = streakMilestones.filter { $0 > currentStreak }
        return upcomingMilestones.first
    }
    
    // Get the current streak progress percentage toward the next milestone
    func getCurrentStreakPercentage() -> Double {
        guard let nextMilestone = getNextMilestone() else {
            return 1.0 // If we've completed all milestones
        }
        
        let previousMilestone = getPreviousMilestone() ?? 0
        let progress = Double(currentStreak - previousMilestone) / Double(nextMilestone - previousMilestone)
        return min(max(progress, 0.0), 1.0) // Clamp between 0 and 1
    }
    
    // Get the previous milestone based on current streak
    private func getPreviousMilestone() -> Int? {
        // Filter milestones that are less than or equal to current streak
        let completedMilestones = streakMilestones.filter { $0 <= currentStreak }
        return completedMilestones.last
    }
    
    // Check if the streak will be broken if not logging today
    func willStreakBreakToday() -> Bool {
        guard let lastLog = lastLogDate else { return false }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let lastLogDay = calendar.startOfDay(for: lastLog)
        
        // If last log was yesterday and we haven't logged today, streak will break
        return lastLogDay <= yesterday && lastLogDay >= yesterday && currentStreak > 0
    }
    
    // Get days until next milestone
    func daysUntilNextMilestone() -> Int? {
        guard let nextMilestone = getNextMilestone() else { return nil }
        return nextMilestone - currentStreak
    }
    
    // Mark a milestone as having been shown to the user
    func markMilestoneShown(milestone: Int, shown: Bool) {
        var shownMilestones = UserDefaults.standard.dictionary(forKey: streakInsightsShownKey) as? [String: Bool] ?? [:]
        shownMilestones[String(milestone)] = shown
        UserDefaults.standard.set(shownMilestones, forKey: streakInsightsShownKey)
    }
    
    // Check if milestone insight has been shown
    func hasMilestoneBeenShown(milestone: Int) -> Bool {
        let shownMilestones = UserDefaults.standard.dictionary(forKey: streakInsightsShownKey) as? [String: Bool] ?? [:]
        return shownMilestones[String(milestone)] ?? false
    }
    
    // Get a motivational message based on the current streak
    func getMotivationalMessage() -> String {
        if currentStreak == 0 {
            return "Start your dream journey today!"
        } else if currentStreak < 3 {
            return "Great start! Keep the momentum going!"
        } else if currentStreak < 7 {
            return "You're building a solid streak! Keep it up!"
        } else if currentStreak < 10 {
            return "Almost at your first milestone! Just \(10 - currentStreak) more days!"
        } else if currentStreak < 21 {
            return "Fantastic work! You're developing a healthy habit!"
        } else if currentStreak < 60 {
            return "You're a dream logging master! Keep exploring your subconscious!"
        } else {
            return "Your dedication is extraordinary! You're unlocking the deepest insights!"
        }
    }
    
    // Get the insight text for a completed milestone
    func getInsightForMilestone(milestone: Int) -> String {
        switch milestone {
        case 10:
            return "10-Day Milestone: You've established a solid foundation for dream recall. Our analysis shows that consistent dream journaling for 10 days dramatically increases your ability to remember dreams in detail."
        case 21:
            return "21-Day Milestone: Congratulations! You've formed a habit. Research shows it takes about 21 days to form a new habit. Your dream recall and pattern recognition abilities have significantly improved."
        case 60:
            return "60-Day Milestone: Amazing dedication! After 60 days of consistent dream journaling, our analysis shows you're experiencing more vivid dreams and likely noticing recurring themes and symbols."
        case 90:
            return "90-Day Milestone: Master Dreamer Status! With 90 days of journaling, you've achieved what few dreamers accomplish. Your dream recall is likely at its peak, and you're developing an intuitive understanding of your dream symbolism."
        default:
            return "Congratulations on your dedication to dream journaling!"
        }
    }
} 