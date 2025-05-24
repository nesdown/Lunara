import SwiftUI

struct StreakProgressBar: View {
    @ObservedObject var streakService = StreakService.shared
    
    // Custom colors
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    private let darkPurple = Color(red: 102/255, green: 51/255, blue: 153/255)
    private let orangeAccent = Color.orange
    
    @State private var animate = false
    @State private var showMilestoneInfo = false
    @State private var selectedMilestone: Int? = nil
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 12) {
                // Enhanced Streak header with explanation
                HStack(alignment: .top) {
                    // Streak flame icon with count and label
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 6) {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 20))
                                .foregroundColor(streakService.currentStreak > 0 ? orangeAccent : .gray)
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
                        
                        Text("Daily Dream Streak")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    // Next milestone with enhanced info
                    if let nextMilestone = streakService.getNextMilestone() {
                        if let daysLeft = streakService.daysUntilNextMilestone() {
                            VStack(alignment: .trailing, spacing: 4) {
                                HStack(spacing: 4) {
                                    Image(systemName: "gift.fill")
                                        .font(.system(size: 12))
                                        .foregroundColor(primaryPurple)
                                    
                                    Text("Unlock a gift")
                                        .font(.system(size: 15))
                                        .foregroundColor(.secondary)
                                    
                                    Image(systemName: "info.circle")
                                        .font(.system(size: 12))
                                        .foregroundColor(primaryPurple)
                                        .onTapGesture {
                                            selectedMilestone = nextMilestone
                                            showMilestoneInfo.toggle()
                                        }
                                }
                                
                                Text("Day \(nextMilestone) milestone")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(primaryPurple)
                            }
                        }
                    } else {
                        Text("All milestones achieved!")
                            .font(.system(size: 15))
                            .foregroundColor(primaryPurple)
                    }
                }
                
                // Progress bar section
                VStack(spacing: 4) {
                    // Progress bar
                    ZStack(alignment: .leading) {
                        // Background track
                        RoundedRectangle(cornerRadius: 10)
                            .fill(lightPurple.opacity(0.3))
                            .frame(height: 14)
                        
                        // Progress fill
                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        orangeAccent,
                                        primaryPurple,
                                        darkPurple
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: getProgressWidth(in: geometry.size.width), height: 14)
                            .animation(.spring(response: 0.6, dampingFraction: 0.7), value: streakService.currentStreak)
                        
                        // Milestone markers
                        ForEach(streakService.streakMilestones, id: \.self) { milestone in
                            milestoneMarker(for: milestone, in: geometry.size.width)
                                .onTapGesture {
                                    selectedMilestone = milestone
                                    showMilestoneInfo.toggle()
                                }
                        }
                    }
                    
                    // Milestone labels below progress bar
                    HStack {
                        ForEach(streakService.streakMilestones, id: \.self) { milestone in
                            Text("\(milestone)")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(streakService.currentStreak >= milestone ? primaryPurple : .secondary)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal, 8)
                }
                
                // Milestone info section (collapsible)
                if showMilestoneInfo, let milestone = selectedMilestone {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "gift.fill")
                                .font(.system(size: 14))
                                .foregroundColor(primaryPurple)
                                
                            Text("Day \(milestone) Milestone")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(primaryPurple)
                            
                            Spacer()
                            
                            Button(action: {
                                showMilestoneInfo = false
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Text(getMilestoneDescription(for: milestone))
                            .font(.system(size: 13))
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(UIColor.secondarySystemBackground))
                    )
                    .transition(.opacity.combined(with: .move(edge: .top)))
                    .animation(.spring(response: 0.3), value: showMilestoneInfo)
                } else {
                    // Motivational message when milestone info isn't showing
                    Text(streakService.getMotivationalMessage())
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.top, 4)
                        .animation(.easeInOut, value: streakService.currentStreak)
                }
            }
            .padding(16)
        }
        .frame(height: showMilestoneInfo ? 200 : 160) // Adjust height based on content
        .animation(.spring(response: 0.3), value: showMilestoneInfo)
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
        let isSelected = selectedMilestone == milestone && showMilestoneInfo
        
        return ZStack {
            // Marker background (different color if reached)
            Circle()
                .fill(streakService.currentStreak >= milestone ? primaryPurple : lightPurple)
                .frame(width: 24, height: 24)
                .overlay(
                    Circle()
                        .stroke(isSelected ? primaryPurple : Color.clear, lineWidth: 2)
                        .scaleEffect(1.2)
                )
            
            // Checkmark if reached
            if streakService.currentStreak >= milestone {
                Image(systemName: "checkmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
            } else {
                // Gift icon if not reached
                Image(systemName: "gift.fill")
                    .font(.system(size: 12))
                    .foregroundColor(.white)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .offset(x: position - 12) // Center the circle on the position
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .animation(.spring(response: 0.3), value: isSelected)
    }
    
    private func getMilestonePosition(_ milestone: Int, in totalWidth: CGFloat) -> CGFloat {
        let containerPadding: CGFloat = 32 // 16pt padding on both sides
        let progressBarWidth = totalWidth - containerPadding
        
        // Calculate position based on the last milestone
        let maxMilestone = streakService.streakMilestones.last ?? 90
        let fraction = CGFloat(milestone) / CGFloat(maxMilestone)
        
        return progressBarWidth * fraction
    }
    
    // Get a description of what users unlock at each milestone
    private func getMilestoneDescription(for milestone: Int) -> String {
        switch milestone {
        case 10:
            return "Enhanced dream recall & detailed dream patterns. Logging for 10 days boosts memory abilities."
        case 21:
            return "Habit formation unlocked! Access special pattern recognition & personalized theme analysis."
        case 60:
            return "Advanced pattern detection & recurring symbol insights. Compare dreams over time."
        case 90:
            return "Master status! AI predictions, exclusive interpretations & waking-dream connections."
        default:
            return "Keep your streak to unlock special insights and features!"
        }
    }
}

struct StreakProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        StreakProgressBar()
            .padding()
            .previewLayout(.sizeThatFits)
    }
} 