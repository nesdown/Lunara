import SwiftUI
import StoreKit

struct PromoOfferView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var subscriptionService = SubscriptionService.shared
    let onDismiss: () -> Void
    
    @State private var isLoading = false
    // Animation states
    @State private var giftIconScale = 0.5
    @State private var giftIconRotation = -30.0
    @State private var titleOffset = 50.0
    @State private var priceOffset = 50.0
    @State private var featuresOffset = 50.0
    @State private var buttonScale = 0.9
    @State private var showGlow = false
    @State private var giftIconOffset = 0.0
    
    // Add these state variables for the countdown timer
    @State private var hours: Int = 23
    @State private var minutes: Int = 59
    @State private var seconds: Int = 59
    @State private var timer: Timer? = nil
    @State private var shineRotation: Double = 0
    @State private var elementOpacity: Double = 0
    @State private var buttonGlowOpacity: Double = 0.0
    
    // Custom colors (matching SubscriptionView)
    private let backgroundGradientStart = Color(red: 48/255, green: 25/255, blue: 94/255)
    private let backgroundGradientEnd = Color(red: 80/255, green: 49/255, blue: 149/255)
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient with deeper colors for premium feel
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 40/255, green: 20/255, blue: 80/255),
                        Color(red: 70/255, green: 40/255, blue: 130/255)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Enhanced subtle background effect
                ZStack {
                    // Large subtle stars
                    ForEach(0..<15) { i in
                        Circle()
                            .fill(Color.white.opacity(Double.random(in: 0.05...0.15)))
                            .frame(width: CGFloat.random(in: 2...4))
                            .position(
                                x: CGFloat.random(in: 0...geometry.size.width),
                                y: CGFloat.random(in: 0...geometry.size.height)
                            )
                            .blur(radius: 0.5)
                    }
                    
                    // Small subtle stars
                    ForEach(0..<20) { i in
                        Circle()
                            .fill(Color.white.opacity(Double.random(in: 0.03...0.1)))
                            .frame(width: CGFloat.random(in: 1...2))
                            .position(
                                x: CGFloat.random(in: 0...geometry.size.width),
                                y: CGFloat.random(in: 0...geometry.size.height)
                            )
                    }
                }
                
                // Main content
                ZStack(alignment: .top) {
                    // Content area - replaced ScrollView with VStack
                    VStack(spacing: 0) {
                        // Gift icon with improved proportions
                        ZStack {
                            // Soft glow behind gift
                            Circle()
                                .fill(
                                    RadialGradient(
                                        gradient: Gradient(colors: [
                                            primaryPurple.opacity(0.4), 
                                            primaryPurple.opacity(0.0)
                                        ]), 
                                        center: .center, 
                                        startRadius: 30,
                                        endRadius: 80
                                    )
                                )
                                .frame(width: 140, height: 140) // Reduced size
                                .opacity(showGlow ? 0.7 : 0.4)
                            
                            // Main circle
                            Circle()
                                .fill(Color.white)
                                .frame(width: 74, height: 74) // Reduced size
                                .shadow(color: primaryPurple.opacity(0.5), radius: 10)
                            
                            // Gift icon
                            Image(systemName: "gift.fill")
                                .font(.system(size: 36)) // Reduced size
                                .foregroundColor(primaryPurple)
                        }
                        .scaleEffect(giftIconScale)
                        .rotationEffect(.degrees(giftIconRotation))
                        .offset(y: giftIconOffset)
                        .padding(.top, max(geometry.safeAreaInsets.top + 10, 20))
                        .padding(.bottom, 0) // Reduced padding
                        .opacity(elementOpacity)
                        
                        // Title with enhanced visual design
                        Text("Exclusive Offer Just For You!")
                            .font(.system(size: 20, weight: .bold)) // Reduced font size
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8) // Reduced padding
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.13))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(Color.white.opacity(0.25), lineWidth: 1)
                                    )
                            )
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                            .padding(.bottom, 12) // Reduced padding
                            .padding(.horizontal, 20)
                            .offset(y: titleOffset)
                            .opacity(titleOffset == 0 ? elementOpacity : 0)
                        
                        // Unlock text with improved typography
                        Text("UNLOCK\nFULL MONTH")
                            .font(.system(size: 30, weight: .heavy)) // Reduced font size
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineSpacing(2) // Reduced spacing
                            .tracking(0.5)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom, 10) // Reduced padding
                            .offset(y: titleOffset)
                            .opacity(titleOffset == 0 ? elementOpacity : 0)
                        
                        // Price section with enhanced visual clarity
                        HStack(alignment: .center, spacing: 10) { // Reduced spacing
                            Text("$19.99/mo")
                                .strikethrough()
                                .foregroundColor(.white.opacity(0.7))
                                .font(.system(size: 18, weight: .medium)) // Reduced font size
                            
                            Text("$0.99")
                                .font(.system(size: 28, weight: .bold)) // Reduced font size
                                .foregroundColor(.white)
                            
                            Text("(95% OFF)")
                                .font(.system(size: 14, weight: .bold)) // Reduced font size
                                .foregroundColor(Color(red: 95/255, green: 220/255, blue: 110/255))
                                .padding(.horizontal, 8) // Reduced padding
                                .padding(.vertical, 4) // Reduced padding
                                .background(
                                    Capsule()
                                        .fill(Color.green.opacity(0.15))
                                        .overlay(
                                            Capsule()
                                                .strokeBorder(Color.green.opacity(0.3), lineWidth: 1)
                                        )
                                )
                        }
                        .offset(y: priceOffset)
                        .opacity(priceOffset == 0 ? elementOpacity : 0)
                        .padding(.bottom, 16) // Reduced padding
                        
                        // Features with improved layout and spacing
                        VStack(alignment: .leading, spacing: 10) { // Reduced spacing
                            PremiumFeatureRow(icon: "sparkles", text: "Unlimited Dream Interpretations")
                            PremiumFeatureRow(icon: "moon.fill", text: "Advanced AI Dream Analysis")
                            PremiumFeatureRow(icon: "chart.bar.fill", text: "Personalized Dream Insights")
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 16) // Reduced padding
                        .offset(y: featuresOffset)
                        .opacity(featuresOffset == 0 ? elementOpacity : 0)
                        
                        // Enhanced countdown timer with improved contrast
                        HStack(spacing: 6) {
                            Text("OFFER EXPIRES IN:")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white.opacity(0.95))
                                .tracking(0.5)
                            
                            // Hours
                            Text("\(hours < 10 ? "0" : "")\(hours)")
                                .font(.system(size: 16, weight: .bold))
                                .monospacedDigit()
                                .foregroundColor(.white)
                            
                            Text(":")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white.opacity(0.7))
                            
                            // Minutes
                            Text("\(minutes < 10 ? "0" : "")\(minutes)")
                                .font(.system(size: 16, weight: .bold))
                                .monospacedDigit()
                                .foregroundColor(.white)
                            
                            Text(":")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white.opacity(0.7))
                            
                            // Seconds
                            Text("\(seconds < 10 ? "0" : "")\(seconds)")
                                .font(.system(size: 16, weight: .bold))
                                .monospacedDigit()
                                .foregroundColor(.white)
                        }
                        .padding(.vertical, 7) // Reduced padding
                        .padding(.horizontal, 14) // Reduced padding
                        .background(
                            Capsule()
                                .fill(Color.black.opacity(0.3))
                                .overlay(
                                    Capsule()
                                        .strokeBorder(Color.white.opacity(0.18), lineWidth: 1)
                                )
                        )
                        .padding(.bottom, 16) // Reduced padding
                        .opacity(elementOpacity)
                        
                        Spacer(minLength: 10)
                        
                        // Claim button with new animation style
                        Button {
                            hapticFeedback()
                            purchasePromoSubscription()
                        } label: {
                            ZStack {
                                // Pulsing glow behind button for a subtle effect
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(primaryPurple.opacity(0.5))
                                    .blur(radius: 8)
                                    .scaleEffect(buttonGlowOpacity > 0.5 ? 1.05 : 0.95)
                                    .opacity(buttonGlowOpacity)
                                
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(1.2)
                                } else {
                                    Text("CLAIM MY OFFER")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                        .tracking(0.8)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 48) // Reduced height
                            .background(
                                ZStack {
                                    // Premium button gradient
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 155/255, green: 105/255, blue: 235/255),
                                            Color(red: 125/255, green: 85/255, blue: 205/255)
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                    
                                    // Subtle shine effect
                                    Rectangle()
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(
                                                    colors: [
                                                        .clear,
                                                        .white.opacity(0.05),
                                                        .white.opacity(0.1),
                                                        .white.opacity(0.05),
                                                        .clear
                                                    ]
                                                ),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .offset(x: showGlow ? geometry.size.width : -geometry.size.width)
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(Color.white.opacity(0.22), lineWidth: 1)
                                )
                            )
                            .shadow(color: primaryPurple.opacity(0.4), radius: 8, x: 0, y: 3)
                        }
                        .scaleEffect(buttonScale)
                        .padding(.horizontal, 20)
                        .opacity(elementOpacity)
                        .contentShape(Rectangle())
                        
                        // Terms text with improved readability
                        Text("$0.99 - introductory offer, yearly subscription automatically\nrenews after first month.")
                            .font(.system(size: 11)) // Reduced font size
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.top, 8) // Reduced padding
                            .padding(.bottom, geometry.safeAreaInsets.bottom + 5) // Adjusted for bottom safe area
                            .opacity(elementOpacity)
                    }
                    .padding(.horizontal, 16)
                    .frame(maxHeight: .infinity) // Make sure it takes all available space
                    
                    // Close button positioned absolutely in top-right corner
                    HStack {
                        Spacer()
                        Button {
                            dismiss()
                            onDismiss()
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.2))
                                    .frame(width: 32, height: 32)
                                
                                Image(systemName: "xmark")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                        .accessibilityLabel("Close")
                        .contentShape(Rectangle())
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, geometry.safeAreaInsets.top + 6)
                }
            }
        }
        .onAppear {
            loadPromoProduct()
            startAnimations()
            startCountdownTimer()
        }
        .onDisappear {
            timer?.invalidate()
            timer = nil
        }
        .alert(item: $alertMessage) { message in
            Alert(
                title: Text(message.title),
                message: Text(message.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    // Alert message structure
    struct AlertMessage: Identifiable {
        let id = UUID()
        let title: String
        let message: String
    }
    
    @State private var alertMessage: AlertMessage?
    
    private func hapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    private func startAnimations() {
        // Fade in overall elements
        withAnimation(.easeIn(duration: 0.7)) {
            elementOpacity = 1.0
        }
        
        // Initial animations
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            giftIconScale = 1.0
            giftIconRotation = 0
        }
        
        withAnimation(.easeOut(duration: 0.5).delay(0.3)) {
            titleOffset = 0
        }
        
        withAnimation(.easeOut(duration: 0.5).delay(0.5)) {
            priceOffset = 0
        }
        
        withAnimation(.easeOut(duration: 0.5).delay(0.7)) {
            featuresOffset = 0
        }
        
        withAnimation(.easeOut(duration: 0.4).delay(0.8)) {
            buttonScale = 1.0
        }
        
        // Continuous animations
        // Glow effect - more subtle
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            showGlow = true
        }
        
        // Floating animation for gift icon - more subtle
        withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
            giftIconOffset = -5
        }
        
        // Rotating shine effect
        withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
            shineRotation = 360
        }
        
        // Button pulse animation
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            buttonGlowOpacity = 0.7
        }
    }
    
    private func startCountdownTimer() {
        // Generate random time between 24 hours and 1.5 hours
        let minSeconds = Int(1.5 * 60 * 60) // 1.5 hours in seconds
        let maxSeconds = 24 * 60 * 60 // 24 hours in seconds
        let randomTotalSeconds = Int.random(in: minSeconds...maxSeconds)
        
        // Convert to hours, minutes, seconds
        hours = randomTotalSeconds / 3600
        let remainingSeconds = randomTotalSeconds % 3600
        minutes = remainingSeconds / 60
        seconds = remainingSeconds % 60
        
        print("Random countdown set: \(hours)h \(minutes)m \(seconds)s")
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if seconds > 0 {
                seconds -= 1
            } else {
                seconds = 59
                if minutes > 0 {
                    minutes -= 1
                } else {
                    minutes = 59
                    if hours > 0 {
                        hours -= 1
                    }
                }
            }
        }
    }
    
    private func loadPromoProduct() {
        Task {
            await subscriptionService.loadPromoProduct()
        }
    }
    
    private func purchasePromoSubscription() {
        guard !isLoading else { return } // Prevent multiple taps
        
        let productID = "lunara.subscription.yearlypromo"
        
        // Check if product exists in subscription service
        guard let product = subscriptionService.getProduct(for: productID) else {
            print("Product not found: \(productID)")
            alertMessage = AlertMessage(
                title: "Product Not Available",
                message: "The promotional offer is currently not available. Please try again later."
            )
            
            // Load products and try again if products list is empty
            if subscriptionService.products.isEmpty {
                Task {
                    await subscriptionService.loadProducts()
                    await subscriptionService.loadPromoProduct()
                }
            }
            return
        }
        
        // Button press animation
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            buttonScale = 0.96
            buttonGlowOpacity = 0.9
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) {
                buttonScale = 1.03
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) {
                    buttonScale = 1.0
                }
            }
        }
        
        isLoading = true
        
        Task {
            do {
                let success = try await subscriptionService.purchase(product)
                
                await MainActor.run {
                    isLoading = false
                    
                    if success {
                        // Success animation
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            buttonScale = 1.1
                            buttonGlowOpacity = 1.0
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                                buttonScale = 1.0
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                dismiss()
                                onDismiss()
                            }
                        }
                    } else {
                        // Reset button on cancellation
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            buttonScale = 1.0
                        }
                    }
                }
            } catch {
                print("Purchase error: \(error.localizedDescription)")
                
                await MainActor.run {
                    isLoading = false
                    
                    // Show error alert
                    alertMessage = AlertMessage(
                        title: "Purchase Failed",
                        message: "There was an error processing your purchase: \(error.localizedDescription)"
                    )
                    
                    // Reset button scale
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        buttonScale = 1.0
                    }
                }
            }
        }
    }
}

// Enhanced feature row with improved visual hierarchy
private struct PremiumFeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) { // Reduced spacing
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.18))
                    .frame(width: 34, height: 34) // Reduced size
                
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium)) // Reduced size
                    .foregroundColor(.white)
            }
            
            Text(text)
                .font(.system(size: 16, weight: .medium)) // Reduced size
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .padding(.vertical, 1) // Reduced vertical padding
    }
}

// Enhanced countdown box for premium appearance
private struct PremiumCountdownBox: View {
    let value: Int
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(value < 10 ? "0" : "")\(value)")
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.white)
            
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
                .tracking(1)
        }
        .frame(width: 60, height: 60)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.4))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(Color.white.opacity(0.15), lineWidth: 1)
                )
        )
    }
} 