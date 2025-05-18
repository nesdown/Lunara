import SwiftUI

struct StreakCalendarView: View {
    @ObservedObject var streakService = StreakService.shared
    @State private var selectedWeek: [Date] = []
    @State private var currentWeekOffset = 0
    
    // Custom colors
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    private let darkPurple = Color(red: 102/255, green: 51/255, blue: 153/255)
    
    var body: some View {
        VStack(spacing: 16) {
            // Calendar header
            HStack {
                Button(action: {
                    withAnimation {
                        currentWeekOffset -= 1
                        updateSelectedWeek()
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(primaryPurple)
                }
                
                Spacer()
                
                Text(getDateRangeText())
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        if currentWeekOffset < 0 {
                            currentWeekOffset += 1
                            updateSelectedWeek()
                        }
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(currentWeekOffset < 0 ? primaryPurple : Color.gray.opacity(0.5))
                        .opacity(currentWeekOffset < 0 ? 1.0 : 0.5)
                }
                .disabled(currentWeekOffset >= 0)
            }
            .padding(.horizontal, 4)
            
            // Weekly calendar
            HStack(spacing: 8) {
                ForEach(0..<7, id: \.self) { index in
                    if index < selectedWeek.count {
                        let date = selectedWeek[index]
                        DayCircleView(
                            date: date,
                            isToday: isToday(date),
                            hasCompletedDream: hasDreamLog(for: date)
                        )
                    }
                }
            }
            
            // Current streak status
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Current Streak")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    Text("\(streakService.currentStreak) Days")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(primaryPurple)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Best Streak")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    Text("\(streakService.bestStreak) Days")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(darkPurple)
                }
            }
            .padding(.horizontal, 4)
            .padding(.top, 8)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .onAppear {
            updateSelectedWeek()
        }
    }
    
    // Get the current week dates
    private func updateSelectedWeek() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        // Find the start of the current week (using Sunday as start of week)
        var selectedWeekStartComponents = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)
        selectedWeekStartComponents.weekday = 1 // Sunday
        
        guard let startOfWeek = calendar.date(from: selectedWeekStartComponents) else { return }
        
        // Apply week offset
        guard let offsetStartDate = calendar.date(byAdding: .day, value: 7 * currentWeekOffset, to: startOfWeek) else { return }
        
        // Create array of 7 days from start of week
        var weekDays: [Date] = []
        for day in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: day, to: offsetStartDate) {
                weekDays.append(date)
            }
        }
        
        self.selectedWeek = weekDays
    }
    
    // Format the date range text (e.g., "Jun 5 - Jun 11")
    private func getDateRangeText() -> String {
        guard selectedWeek.count >= 2 else { return "" }
        
        let formatter = DateFormatter()
        
        if currentWeekOffset == 0 {
            return "This Week"
        }
        
        if currentWeekOffset == -1 {
            return "Last Week"
        }
        
        formatter.dateFormat = "MMM d"
        let startText = formatter.string(from: selectedWeek.first!)
        let endText = formatter.string(from: selectedWeek.last!)
        
        return "\(startText) - \(endText)"
    }
    
    // Check if a date is today
    private func isToday(_ date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDateInToday(date)
    }
    
    // Check if the user has logged a dream for a given date
    private func hasDreamLog(for date: Date) -> Bool {
        guard let lastLogDate = streakService.lastLogDate else { return false }
        let calendar = Calendar.current
        
        // If last log date is today and checking for today
        if calendar.isDateInToday(lastLogDate) && calendar.isDateInToday(date) {
            return true
        }
        
        // For past dates, we need to check streak continuity
        // This is simplified and would need a proper implementation to track historical dream logs
        let lastLogStartOfDay = calendar.startOfDay(for: lastLogDate)
        let dateStartOfDay = calendar.startOfDay(for: date)
        
        // Simple solution: If date is before or equal to lastLogDate and within current streak range
        if dateStartOfDay <= lastLogStartOfDay {
            // Calculate days between the date and lastLogDate
            if let daysBetween = calendar.dateComponents([.day], from: dateStartOfDay, to: lastLogStartOfDay).day {
                return daysBetween < streakService.currentStreak
            }
        }
        
        return false
    }
}

// Individual day circle view
struct DayCircleView: View {
    let date: Date
    let isToday: Bool
    let hasCompletedDream: Bool
    
    // Custom colors
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    
    var body: some View {
        VStack(spacing: 4) {
            // Day name (e.g., "Mon")
            Text(dayNameText())
                .font(.system(size: 12))
                .foregroundColor(.secondary)
            
            // Day circle
            ZStack {
                Circle()
                    .fill(backgroundFill())
                    .frame(width: 36, height: 36)
                    .overlay(
                        Circle()
                            .strokeBorder(isToday ? primaryPurple : Color.clear, lineWidth: isToday ? 1.5 : 0)
                    )
                
                // Check mark if completed
                if hasCompletedDream {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                }
                
                // Day number (e.g., "15")
                if !hasCompletedDream {
                    Text(dayNumberText())
                        .font(.system(size: 14, weight: isToday ? .semibold : .regular))
                        .foregroundColor(textColor())
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    // Get day name (e.g., "Mon")
    private func dayNameText() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }
    
    // Get day number (e.g., "15")
    private func dayNumberText() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    // Background fill color based on state
    private func backgroundFill() -> Color {
        if hasCompletedDream {
            return primaryPurple
        } else if isToday {
            return lightPurple.opacity(0.3)
        } else {
            return Color(.secondarySystemBackground)
        }
    }
    
    // Text color based on state
    private func textColor() -> Color {
        if hasCompletedDream {
            return .white
        } else {
            return isToday ? primaryPurple : .primary
        }
    }
}

struct StreakCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        StreakCalendarView()
            .padding()
            .previewLayout(.sizeThatFits)
    }
} 