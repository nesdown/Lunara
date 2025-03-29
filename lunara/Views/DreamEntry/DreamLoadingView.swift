import SwiftUI

struct DreamLoadingView: View {
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1.0
    @State private var currentMessageIndex = 0
    @State private var starOpacity: Double = 0.0
    @State private var particleSystem = ParticleSystem()
    
    let messages = [
        "Analyzing dream patterns...",
        "Exploring symbolic meanings...",
        "Connecting with your subconscious...",
        "Discovering hidden insights...",
        "Interpreting dream elements..."
    ]
    
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    
    var body: some View {
        ZStack {
            // Background particles
            particleSystem
                .opacity(0.6)
                .allowsHitTesting(false)
            
            VStack(spacing: 40) {
                ZStack {
                    // Glowing background
                    Circle()
                        .fill(primaryPurple.opacity(0.15))
                        .frame(width: 120, height: 120)
                        .blur(radius: 15)
                        .scaleEffect(scale * 1.2)
                    
                    // Main icon
                    Image(systemName: "moon.stars.fill")
                        .font(.system(size: 80))
                        .foregroundColor(primaryPurple)
                        .rotationEffect(.degrees(rotation))
                        .scaleEffect(scale)
                        .shadow(color: primaryPurple.opacity(0.5), radius: 10, x: 0, y: 0)
                    
                    // Orbiting stars
                    ForEach(0..<3) { i in
                        Image(systemName: "star.fill")
                            .font(.system(size: 14 + CGFloat(i * 4)))
                            .foregroundColor(primaryPurple)
                            .offset(x: cos(rotation / 180 * .pi + Double(i) * 2.0) * 70,
                                    y: sin(rotation / 180 * .pi + Double(i) * 2.0) * 70)
                            .opacity(starOpacity)
                    }
                }
                .onAppear {
                    // Main rotation animation
                    withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
                        rotation = 360
                    }
                    
                    // Breathing effect
                    withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                        scale = 1.1
                    }
                    
                    // Fade in stars
                    withAnimation(.easeIn(duration: 1.5)) {
                        starOpacity = 0.8
                    }
                }
                
                // Message text with fade transition
                Text(messages[currentMessageIndex])
                    .font(.title3)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                    .padding(.horizontal)
                    .transition(AnyTransition.opacity.combined(with: .scale(scale: 0.95)))
                    .id(currentMessageIndex)
                    .onReceive(timer) { _ in
                        withAnimation(AppAnimation.gentleSpring) {
                            currentMessageIndex = (currentMessageIndex + 1) % messages.count
                        }
                    }
                
                // Custom progress indicator
                LoadingIndicator()
                    .frame(width: 50, height: 50)
                    .padding(.top, 20)
            }
            .padding(.horizontal, 30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .onAppear {
            particleSystem.center = UnitPoint(x: 0.5, y: 0.4)
        }
    }
}

// Custom loading indicator
struct LoadingIndicator: View {
    @State private var isAnimating = false
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    
    var body: some View {
        ZStack {
            ForEach(0..<8) { i in
                Circle()
                    .fill(primaryPurple.opacity(0.8))
                    .frame(width: 8, height: 8)
                    .offset(y: -18)
                    .rotationEffect(.degrees(Double(i) * 45))
                    .opacity(isAnimating ? 1 : 0.3)
                    .animation(
                        Animation.easeInOut(duration: 0.8)
                            .repeatForever(autoreverses: true)
                            .delay(Double(i) * 0.1),
                        value: isAnimating
                    )
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

// Particle system for background effect
struct ParticleSystem: View {
    @State private var particles = [Particle]()
    @State private var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    var center = UnitPoint.center
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Circle()
                    .fill(Color.purple.opacity(particle.opacity))
                    .frame(width: particle.size, height: particle.size)
                    .position(particle.position)
                    .blur(radius: particle.size / 3)
            }
        }
        .onReceive(timer) { _ in
            if particles.count < 20 && Bool.random() {
                addParticle()
            }
            
            for i in particles.indices {
                particles[i].update()
            }
            
            particles.removeAll(where: { $0.opacity <= 0 })
        }
    }
    
    func addParticle() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        let x = center.x * screenWidth + CGFloat.random(in: -100...100)
        let y = center.y * screenHeight + CGFloat.random(in: -100...100)
        
        let particle = Particle(
            position: CGPoint(x: x, y: y),
            size: CGFloat.random(in: 3...12),
            opacity: Double.random(in: 0.1...0.3),
            lifetime: Double.random(in: 2...5)
        )
        
        particles.append(particle)
    }
}

struct Particle: Identifiable {
    let id = UUID()
    var position: CGPoint
    let size: CGFloat
    var opacity: Double
    let lifetime: Double
    let creationTime = Date()
    
    mutating func update() {
        let age = Date().timeIntervalSince(creationTime)
        let progress = age / lifetime
        
        // Fade out as particle ages
        opacity = max(0, 0.3 - progress * 0.3)
        
        // Slight upward drift
        position.y -= 0.5
        
        // Slight random movement
        position.x += CGFloat.random(in: -0.5...0.5)
    }
} 