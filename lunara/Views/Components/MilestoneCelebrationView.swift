import SwiftUI

struct MilestoneCelebrationView: View {
    @Binding var isPresented: Bool
    let milestone: Int
    @ObservedObject var streakService = StreakService.shared
    @State private var showConfetti = false
    
    // Custom colors
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    private let darkPurple = Color(red: 102/255, green: 51/255, blue: 153/255)
    
    var body: some View {
        ZStack {
            // Background overlay
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    dismiss()
                }
            
            // Confetti effect
            ZStack {
                ForEach(0..<30, id: \.self) { i in
                    ConfettiPiece(rotationAngle: Double.random(in: 0...360))
                        .offset(x: showConfetti ? randomOffset() : 0,
                                y: showConfetti ? UIScreen.main.bounds.height * 0.6 : -50)
                        .opacity(showConfetti ? randomOpacity() : 0)
                }
            }
            .onAppear {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.5).delay(0.3)) {
                    showConfetti = true
                }
            }
            
            // Milestone card
            VStack(spacing: 20) {
                // Trophy icon
                Image(systemName: getMilestoneIcon(for: milestone))
                    .font(.system(size: 70))
                    .foregroundColor(primaryPurple)
                    .frame(width: 120, height: 120)
                    .background(
                        Circle()
                            .fill(Color.white)
                            .shadow(color: primaryPurple.opacity(0.3), radius: 20, x: 0, y: 10)
                    )
                    .overlay(
                        Circle()
                            .strokeBorder(LinearGradient(
                                gradient: Gradient(colors: [primaryPurple.opacity(0.6), primaryPurple.opacity(0.2)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ), lineWidth: 5)
                    )
                    .padding(.top, 30)
                
                // Title
                Text("🎉 Milestone Achieved! 🎉")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(darkPurple)
                    .multilineTextAlignment(.center)
                
                // Streak number
                Text("\(milestone)-Day Streak")
                    .font(.system(size: 32, weight: .heavy))
                    .foregroundColor(primaryPurple)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(lightPurple.opacity(0.3))
                    )
                
                // Insight text
                Text(streakService.getInsightForMilestone(milestone: milestone))
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                
                // Continue button
                Button {
                    dismiss()
                } label: {
                    Text("Continue Your Journey")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [primaryPurple, darkPurple]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: darkPurple.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
            }
            .frame(width: min(UIScreen.main.bounds.width - 40, 360))
            .background(Color(.systemBackground))
            .cornerRadius(24)
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
        }
        .onAppear {
            // When we show this view, mark the milestone as shown
            streakService.markMilestoneShown(milestone: milestone, shown: true)
            
            // Play a celebration sound
            HapticManager.shared.celebration()
        }
    }
    
    private func dismiss() {
        withAnimation {
            isPresented = false
        }
    }
    
    private func randomOffset() -> CGFloat {
        return CGFloat.random(in: -UIScreen.main.bounds.width * 0.5...UIScreen.main.bounds.width * 0.5)
    }
    
    private func randomOpacity() -> Double {
        return Double.random(in: 0.3...0.8)
    }
    
    private func getMilestoneIcon(for milestone: Int) -> String {
        switch milestone {
        case 10:
            return "trophy.fill"
        case 21:
            return "star.circle.fill"
        case 60:
            return "crown.fill"
        case 90:
            return "sparkles"
        default:
            return "medal.fill"
        }
    }
}

struct ConfettiPiece: View {
    let rotationAngle: Double
    
    // Random confetti colors
    private let colors: [Color] = [
        .red, .orange, .yellow, .green, .blue, .purple, .pink
    ]
    
    // Random shape
    @State private var shape = Int.random(in: 0...2)
    @State private var color = Int.random(in: 0...6)
    @State private var rotation = Double.random(in: 0...360)
    
    var body: some View {
        Group {
            if shape == 0 {
                Rectangle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(colors[color])
            } else if shape == 1 {
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(colors[color])
            } else {
                Text("★")
                    .font(.system(size: 16))
                    .foregroundColor(colors[color])
            }
        }
        .rotationEffect(.degrees(rotation))
        .rotationEffect(.degrees(rotationAngle))
    }
}

// Extension to add celebration haptic feedback
extension HapticManager {
    func celebration() {
        // Trigger multiple haptics to create a celebration feel
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                let impact = UIImpactFeedbackGenerator(style: .light)
                impact.impactOccurred()
            }
        }
    }
} 