import SwiftUI

struct StreakProgressBar: View {
    @ObservedObject var streakService = StreakService.shared
    
    // Custom colors
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    private let darkPurple = Color(red: 102/255, green: 51/255, blue: 153/255)
    
    @State private var animate = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 12) {
                // Streak header
                HStack {
                    // Streak flame icon with count
                    HStack(spacing: 6) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 20))
                            .foregroundColor(streakService.currentStreak > 0 ? .orange : .gray)
                            .symbolEffect(.bounce, options: .repeating, value: animate)
                            .onAppear {
                                // Animate only if there's an active streak
                                if streakService.currentStreak > 0 {
                                    animate = true
                                }
                            }
                        
                        Text("\(streakService.currentStreak)")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(streakService.currentStreak > 0 ? primaryPurple : .gray)
                    }
                    
                    Spacer()
                    
                    // Next milestone or achievement text
                    if let nextMilestone = streakService.getNextMilestone() {
                        if let daysLeft = streakService.daysUntilNextMilestone() {
                            Text("\(daysLeft) days to \(nextMilestone)-day milestone")
                                .font(.system(size: 15))
                                .foregroundColor(.secondary)
                        }
                    } else {
                        Text("All milestones achieved!")
                            .font(.system(size: 15))
                            .foregroundColor(primaryPurple)
                    }
                }
                
                // Progress bar
                ZStack(alignment: .leading) {
                    // Background track
                    RoundedRectangle(cornerRadius: 10)
                        .fill(lightPurple.opacity(0.3))
                        .frame(height: 12)
                    
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
                        .frame(width: getProgressWidth(in: geometry.size.width), height: 12)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7), value: streakService.currentStreak)
                    
                    // Milestone markers
                    ForEach(streakService.streakMilestones, id: \.self) { milestone in
                        milestoneMarker(for: milestone, in: geometry.size.width)
                    }
                }
                
                // Motivational message
                Text(streakService.getMotivationalMessage())
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 4)
                    .animation(.easeInOut, value: streakService.currentStreak)
            }
            .padding(16)
        }
        .frame(height: 140) // Set a fixed height to maintain consistency
    }
    
    // Get the width of the progress bar based on current progress
    private func getProgressWidth(in totalWidth: CGFloat) -> CGFloat {
        let containerPadding: CGFloat = 32 // 16pt padding on both sides
        let progressBarWidth = totalWidth - containerPadding
        let progress = streakService.getCurrentStreakPercentage()
        return progressBarWidth * CGFloat(progress)
    }
    
    // Create a milestone marker at the appropriate position
    private func milestoneMarker(for milestone: Int, in totalWidth: CGFloat) -> some View {
        // Get the fraction position for this milestone
        let position = getMilestonePosition(milestone, in: totalWidth)
        
        return ZStack {
            // Marker background (different color if reached)
            Circle()
                .fill(streakService.currentStreak >= milestone ? primaryPurple : lightPurple)
                .frame(width: 18, height: 18)
            
            // Checkmark if reached
            if streakService.currentStreak >= milestone {
                Image(systemName: "checkmark")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white)
            } else {
                // Number if not reached
                Text("\(milestone)")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .offset(x: position - 9) // Center the circle on the position
    }
    
    private func getMilestonePosition(_ milestone: Int, in totalWidth: CGFloat) -> CGFloat {
        let containerPadding: CGFloat = 32 // 16pt padding on both sides
        let progressBarWidth = totalWidth - containerPadding
        
        // Calculate position based on the last milestone
        let maxMilestone = streakService.streakMilestones.last ?? 90
        let fraction = CGFloat(milestone) / CGFloat(maxMilestone)
        
        return progressBarWidth * fraction
    }
}

struct StreakProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        StreakProgressBar()
            .padding()
            .previewLayout(.sizeThatFits)
    }
} 