import SwiftUI

struct StreakStatsView: View {
    @ObservedObject var streakService = StreakService.shared
    
    // Custom colors - match with main app theme
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    private let darkPurple = Color(red: 102/255, green: 51/255, blue: 153/255)
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            Text("Dream Streak Stats")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(primaryPurple)
                .padding(.top, 8)
            
            // Stats grid
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                // Current streak stat
                StatCard(
                    icon: "flame.fill",
                    iconColor: .orange,
                    title: "Current Streak",
                    value: "\(streakService.currentStreak)",
                    subtitle: getStreakSubtitle()
                )
                
                // Best streak stat
                StatCard(
                    icon: "trophy.fill",
                    iconColor: Color(red: 212/255, green: 175/255, blue: 55/255), // Gold
                    title: "Best Streak",
                    value: "\(streakService.bestStreak)",
                    subtitle: "Your record"
                )
                
                // Next milestone
                if let nextMilestone = streakService.getNextMilestone() {
                    StatCard(
                        icon: "flag.checkered.fill",
                        iconColor: primaryPurple,
                        title: "Next Milestone",
                        value: "\(nextMilestone) days",
                        subtitle: "\(nextMilestone - streakService.currentStreak) days to go"
                    )
                } else {
                    StatCard(
                        icon: "star.fill",
                        iconColor: primaryPurple,
                        title: "Achievements",
                        value: "All Complete!",
                        subtitle: "Master Dreamer"
                    )
                }
                
                // Dream insights
                StatCard(
                    icon: "lightbulb.fill",
                    iconColor: Color(red: 255/255, green: 196/255, blue: 0/255), // Amber
                    title: "Dream Insights",
                    value: getInsightStatusText(),
                    subtitle: "Available to you"
                )
            }
            
            // Milestone progress
            VStack(spacing: 8) {
                Text("Milestone Progress")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                
                // Milestone track with markers
                ZStack(alignment: .leading) {
                    // Background track
                    RoundedRectangle(cornerRadius: 10)
                        .fill(lightPurple.opacity(0.3))
                        .frame(height: 8)
                    
                    // Progress fill
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    primaryPurple,
                                    darkPurple
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: getProgressWidth(maxWidth: UIScreen.main.bounds.width - 64), height: 8)
                }
                
                // Milestone markers with labels
                HStack {
                    ForEach(streakService.streakMilestones, id: \.self) { milestone in
                        Spacer()
                        VStack(spacing: 4) {
                            Circle()
                                .fill(streakService.currentStreak >= milestone ? primaryPurple : lightPurple.opacity(0.5))
                                .frame(width: 10, height: 10)
                            
                            Text("\(milestone)")
                                .font(.system(size: 12))
                                .foregroundColor(streakService.currentStreak >= milestone ? primaryPurple : .secondary)
                        }
                        Spacer()
                    }
                }
            }
            .padding(.top, 8)
            
            // Motivational message
            Text(streakService.getMotivationalMessage())
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.top, 8)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .strokeBorder(lightPurple, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 4)
        .padding(.horizontal, 16)
    }
    
    // Get the width of the progress bar
    private func getProgressWidth(maxWidth: CGFloat) -> CGFloat {
        let progress = streakService.getCurrentStreakPercentage()
        return maxWidth * CGFloat(progress)
    }
    
    // Get a subtitle for the current streak
    private func getStreakSubtitle() -> String {
        if streakService.currentStreak == 0 {
            return "Start today!"
        } else if streakService.willStreakBreakToday() {
            return "At risk today!"
        } else {
            return "Days in a row"
        }
    }
    
    // Get the insight status based on streak milestones
    private func getInsightStatusText() -> String {
        let milestones = streakService.streakMilestones
        let unlockedMilestones = milestones.filter { streakService.currentStreak >= $0 }
        
        if unlockedMilestones.isEmpty {
            return "0/\(milestones.count)"
        } else {
            return "\(unlockedMilestones.count)/\(milestones.count)"
        }
    }
}

// A card for displaying individual stats
struct StatCard: View {
    let icon: String
    let iconColor: Color
    let title: String
    let value: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 6) {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(iconColor)
            
            // Value
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.primary)
            
            // Title
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.secondary)
                .lineLimit(1)
            
            // Subtitle
            Text(subtitle)
                .font(.system(size: 11))
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
        .frame(height: 110)
        .padding(.horizontal, 8)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

struct StreakStatsView_Previews: PreviewProvider {
    static var previews: some View {
        StreakStatsView()
            .padding()
            .previewLayout(.sizeThatFits)
    }
} 