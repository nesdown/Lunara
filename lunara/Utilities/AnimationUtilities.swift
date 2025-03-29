import SwiftUI

// MARK: - Animation Constants
struct AppAnimation {
    // Standard durations
    static let fast = 0.3
    static let standard = 0.4
    static let slow = 0.6
    
    // Standard curves
    static let spring = Animation.spring(response: 0.4, dampingFraction: 0.7, blendDuration: 0.3)
    static let gentleSpring = Animation.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.3)
    static let easeOut = Animation.easeOut(duration: standard)
    static let easeIn = Animation.easeIn(duration: standard)
    static let easeInOut = Animation.easeInOut(duration: standard)
    
    // Specific animations for common use cases
    static let buttonPress = spring.speed(1.2)
    static let appearance = gentleSpring.delay(0.1)
    static let cardExpand = spring.speed(0.9)
    static let listItemMove = easeInOut.speed(1.1)
    
    // Screen transitions
    static let screenTransition = AnyTransition.asymmetric(
        insertion: .opacity.combined(with: .move(edge: .trailing).animation(.easeOut(duration: 0.3))),
        removal: .opacity.combined(with: .move(edge: .leading).animation(.easeIn(duration: 0.2)))
    )
    
    static let modalTransition = AnyTransition.asymmetric(
        insertion: .opacity.combined(with: .move(edge: .bottom).animation(.spring(response: 0.35, dampingFraction: 0.7))),
        removal: .opacity.combined(with: .move(edge: .bottom).animation(.easeIn(duration: 0.25)))
    )
    
    static let fadeTransition = AnyTransition.opacity.animation(.easeInOut(duration: 0.2))
    
    static let scaleTransition = AnyTransition.asymmetric(
        insertion: .scale(scale: 0.95).combined(with: .opacity).animation(.spring(response: 0.35, dampingFraction: 0.7)),
        removal: .scale(scale: 0.95).combined(with: .opacity).animation(.easeOut(duration: 0.2))
    )
}

// MARK: - View Extensions for Animations
extension View {
    // Apply standard entry animation for content
    func appearanceAnimation(delay: Double = 0) -> some View {
        self.transition(.opacity)
            .animation(.spring(response: 0.4, dampingFraction: 0.7).delay(delay), value: true)
    }
    
    // Apply staggered appearance for lists
    func staggeredAppearance(index: Int, baseDelay: Double = 0.05) -> some View {
        let delay = baseDelay * Double(index)
        return self.transition(.opacity)
            .animation(.spring(response: 0.4, dampingFraction: 0.7).delay(delay), value: true)
    }
    
    // Apply bounce effect for important elements
    func bounceEffect(on condition: Bool) -> some View {
        self.scaleEffect(condition ? 1.05 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: condition)
    }
    
    // Apply subtle breathing effect for attention items
    func breathingEffect(active: Bool = true, duration: Double = 2.0) -> some View {
        self.modifier(BreathingEffectModifier(active: active, duration: duration))
    }
}

// MARK: - Custom Modifiers
struct BreathingEffectModifier: ViewModifier {
    let active: Bool
    let duration: Double
    @State private var scale: CGFloat = 1.0
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .onAppear {
                guard active else { return }
                withAnimation(Animation.easeInOut(duration: duration).repeatForever(autoreverses: true)) {
                    scale = 1.03
                }
            }
    }
}

// MARK: - Custom Transitions
extension AnyTransition {
    static var slideUp: AnyTransition {
        AnyTransition.move(edge: .bottom).combined(with: .opacity)
    }
    
    static var slideDown: AnyTransition {
        AnyTransition.move(edge: .top).combined(with: .opacity)
    }
    
    static var slideLeft: AnyTransition {
        AnyTransition.move(edge: .trailing).combined(with: .opacity)
    }
    
    static var slideRight: AnyTransition {
        AnyTransition.move(edge: .leading).combined(with: .opacity)
    }
} 