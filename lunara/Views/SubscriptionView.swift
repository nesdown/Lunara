import SwiftUI
import StoreKit

@MainActor
final class SubscriptionViewModel: ObservableObject {
    @Published var showPromoOffer = false
}

struct SubscriptionFeature: Identifiable, Equatable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
    let iconColor: Color
}

struct SubscriptionView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var subscriptionService = SubscriptionService.shared
    @StateObject private var viewModel = SubscriptionViewModel()
    
    @State private var isYearlySelected = false // Set to false by default for 3 Days Free
    @State private var freeTrialEnabled = true
    @State private var isLoading = false
    @State private var currentFeatureIndex = 0
    @State private var carouselTimer: Timer? = nil
    
    // Appearance animations
    @State private var titleAppeared = false
    @State private var featureAppeared = false
    @State private var optionsAppeared = false
    @State private var buttonAppeared = false
    @State private var crossButtonAppeared = false
    
    // Features carousel
    private let features = [
        SubscriptionFeature(
            icon: "sparkles",
            title: "Unlimited Interpretations",
            description: "Analyze all your dreams without limits",
            iconColor: Color(red: 255/255, green: 215/255, blue: 0/255)
        ),
        SubscriptionFeature(
            icon: "brain.head.profile",
            title: "Advanced AI Insights",
            description: "Get deeper psychological analysis of your dream patterns",
            iconColor: Color(red: 0/255, green: 191/255, blue: 255/255)
        ),
        SubscriptionFeature(
            icon: "chart.line.uptrend.xyaxis",
            title: "Sleep Pattern Analytics",
            description: "Track your dream quality and sleep cycles over time",
            iconColor: Color(red: 50/255, green: 205/255, blue: 50/255)
        ),
        SubscriptionFeature(
            icon: "books.vertical.fill",
            title: "Symbol Dictionary",
            description: "Access to extensive library of dream symbols and meanings",
            iconColor: Color(red: 255/255, green: 105/255, blue: 180/255)
        ),
        SubscriptionFeature(
            icon: "star.circle.fill",
            title: "Premium Support",
            description: "Priority customer support and feature requests",
            iconColor: Color(red: 138/255, green: 43/255, blue: 226/255)
        )
    ]
    
    // Custom colors
    private let backgroundGradientStart = Color(red: 48/255, green: 25/255, blue: 94/255)
    private let backgroundGradientEnd = Color(red: 80/255, green: 49/255, blue: 149/255)
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    private let starColor = Color(red: 255/255, green: 215/255, blue: 0/255)
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [backgroundGradientStart, backgroundGradientEnd]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                // Star particles background effect
                ZStack {
                    ForEach(0..<30) { i in
                        Circle()
                            .fill(Color.white.opacity(Double.random(in: 0.1...0.3)))
                            .frame(width: CGFloat.random(in: 1...3))
                            .position(
                                x: CGFloat.random(in: 0...geometry.size.width),
                                y: CGFloat.random(in: 0...geometry.size.height)
                            )
                            .animation(
                                Animation.linear(duration: Double.random(in: 5...10))
                                    .repeatForever(autoreverses: true)
                                    .delay(Double.random(in: 0...5)),
                                value: UUID()
                            )
                    }
                }
                
                // Main content
                VStack(spacing: 0) {
                    // Extra safe area padding to prevent status bar overlap
                    Spacer()
                        .frame(height: 35)
                    
                    // Top buttons (cross on left, restore on right)
                    HStack {
                        Button {
                            viewModel.showPromoOffer = true
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.15))
                                    .frame(width: 36, height: 36)
                                
                                Image(systemName: "xmark")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                            }
                        }
                        .opacity(crossButtonAppeared ? 1 : 0)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation(.easeIn(duration: 0.3)) {
                                    crossButtonAppeared = true
                                }
                            }
                        }
                        
                        Spacer()
                        
                        Button {
                            // Restore purchases
                            Task {
                                await subscriptionService.updatePurchasedProducts()
                            }
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.15))
                                    .frame(width: 36, height: 36)
                                
                                Image(systemName: "arrow.clockwise")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.top, 10)
                    .padding(.horizontal, 16)
                    
                    // Main title
                    Text("Get unlimited access")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 15)
                        .padding(.bottom, 15)
                        .offset(y: titleAppeared ? 0 : 20)
                        .opacity(1)
                        .onAppear {
                            withAnimation(.easeOut(duration: 0.7)) {
                                // This is for title animation only
                            }
                        }
                    
                    // Feature Carousel
                    TabView(selection: $currentFeatureIndex) {
                        ForEach(0..<features.count) { index in
                            featureCard(feature: features[index])
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .frame(height: 130)
                    .offset(y: featureAppeared ? 0 : 30)
                    .opacity(featureAppeared ? 1 : 0)
                    .padding(.bottom, 10)
                    .onAppear {
                        // Start auto-cycling the features
                        withAnimation(.easeOut(duration: 0.7).delay(0.3)) {
                            featureAppeared = true
                        }
                        startCarouselTimer()
                    }
                    .onDisappear {
                        carouselTimer?.invalidate()
                    }
                    
                    // App Store rating
                    HStack(alignment: .center, spacing: 16) {
                        Text("4.8")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 60, alignment: .center)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 4) {
                                ForEach(0..<5) { _ in
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                }
                            }
                            
                            Button {
                                // Open App Store rating
                            } label: {
                                Text("App Store")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .background(Capsule().fill(Color.white.opacity(0.2)))
                            }
                        }
                    }
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.05))
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                    
                    // Subscription options
                    VStack(spacing: 10) {
                        // Weekly subscription
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                isYearlySelected = false
                                freeTrialEnabled = true
                            }
                            HapticManager.shared.light()
                        } label: {
                            HStack {
                                ZStack {
                                    Circle()
                                        .stroke(Color.white, lineWidth: 1)
                                        .frame(width: 24, height: 24)
                                    
                                    if !isYearlySelected {
                                        Circle()
                                            .fill(Color.white)
                                            .frame(width: 16, height: 16)
                                    }
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("3 Days Free")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                    
                                    if let weeklyProduct = subscriptionService.getProduct(for: "lunara.sub.weekly") {
                                        Text("then \(weeklyProduct.displayPrice)/week")
                                            .font(.system(size: 14))
                                            .foregroundColor(.white.opacity(0.8))
                                    } else {
                                        Text("then 6,99 USD/week")
                                            .font(.system(size: 14))
                                            .foregroundColor(.white.opacity(0.8))
                                    }
                                }
                                
                                Spacer()
                                
                                if !isYearlySelected {
                                    Text("Free Trial")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(
                                            Capsule()
                                                .fill(primaryPurple.opacity(0.6))
                                        )
                                }
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(!isYearlySelected ? Color.white.opacity(0.15) : Color.clear)
                                    .stroke(Color.white.opacity(0.3), lineWidth: !isYearlySelected ? 2 : 1)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        // Yearly subscription
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                isYearlySelected = true
                                freeTrialEnabled = false
                            }
                            HapticManager.shared.light()
                        } label: {
                            HStack {
                                ZStack {
                                    Circle()
                                        .stroke(Color.white, lineWidth: 1)
                                        .frame(width: 24, height: 24)
                                    
                                    if isYearlySelected {
                                        Circle()
                                            .fill(Color.white)
                                            .frame(width: 16, height: 16)
                                    }
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("Annual Plan")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                    
                                    if let yearlyProduct = subscriptionService.getProduct(for: "lunara.sub.yearly") {
                                        Text("\(yearlyProduct.displayPrice)/year")
                                            .font(.system(size: 14))
                                            .foregroundColor(.white.opacity(0.8))
                                    } else {
                                        Text("49,99 USD/year")
                                            .font(.system(size: 14))
                                            .foregroundColor(.white.opacity(0.8))
                                    }
                                }
                                
                                Spacer()
                                
                                if isYearlySelected {
                                    VStack(alignment: .center) {
                                        Text("US$0.96/week")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(.white)
                                        Text("Save 86%")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(starColor)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 2)
                                            .background(
                                                Capsule()
                                                    .fill(starColor.opacity(0.2))
                                            )
                                    }
                                }
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(isYearlySelected ? Color.white.opacity(0.15) : Color.clear)
                                    .stroke(Color.white.opacity(0.3), lineWidth: isYearlySelected ? 2 : 1)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        // Free trial toggle
                        HStack {
                            Text("Free trial enabled")
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Toggle("", isOn: $freeTrialEnabled)
                                .toggleStyle(SwitchToggleStyle(tint: primaryPurple))
                                .onChange(of: freeTrialEnabled) { _, newValue in
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        isYearlySelected = !newValue
                                    }
                                    HapticManager.shared.light()
                                }
                        }
                        .padding(.vertical, 8)
                        
                        // Subscribe button
                        Button {
                            purchaseSubscription()
                            HapticManager.shared.medium()
                        } label: {
                            ZStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("Try for free")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [primaryPurple, primaryPurple.opacity(0.7)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 30))
                            )
                            .shadow(color: primaryPurple.opacity(0.5), radius: 10, x: 0, y: 5)
                        }
                        .buttonStyle(SubscriptionScaleButtonStyle())
                        .disabled(isLoading)
                        .padding(.top, 8)
                        .padding(.bottom, 8)
                        
                        // Money-back guarantee
                        HStack(spacing: 6) {
                            Image(systemName: "checkmark.shield.fill")
                                .font(.system(size: 14))
                                .foregroundColor(Color.green.opacity(0.9))
                            
                            Text("30-Day Money-Back Guarantee")
                                .font(.system(size: 13))
                                .foregroundColor(.white)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 10)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.white.opacity(0.08))
                        )
                        .padding(.top, 10)
                        .padding(.bottom, 8)
                        
                        // Terms & Privacy links
                        HStack(spacing: 16) {
                            Button {
                                // Open terms
                            } label: {
                                Text("Terms of Use")
                                    .font(.footnote)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            
                            Button {
                                // Open privacy
                            } label: {
                                Text("Privacy Policy")
                                    .font(.footnote)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 10)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                    .offset(y: optionsAppeared ? 0 : 40)
                    .opacity(optionsAppeared ? 1 : 0)
                    .onAppear {
                        withAnimation(.easeOut(duration: 0.7).delay(0.5)) {
                            optionsAppeared = true
                        }
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            Task {
                await subscriptionService.loadProducts()
            }
        }
        .fullScreenCover(isPresented: $viewModel.showPromoOffer) {
            PromoOfferView {
                dismiss()
            }
            .interactiveDismissDisabled()
        }
    }
    
    private func featureCard(feature: SubscriptionFeature) -> some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(feature.iconColor.opacity(0.2))
                    .frame(width: 44, height: 44)
                
                Image(systemName: feature.icon)
                    .font(.system(size: 20))
                    .foregroundColor(feature.iconColor)
            }
            
            Text(feature.title)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text(feature.description)
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 4)
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.1))
        .cornerRadius(18)
        .padding(.horizontal, 20)
    }
    
    private func startCarouselTimer() {
        carouselTimer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { _ in
            withAnimation {
                currentFeatureIndex = (currentFeatureIndex + 1) % features.count
            }
        }
    }
    
    private func purchaseSubscription() {
        let productID = isYearlySelected ? "lunara.sub.yearly" : "lunara.sub.weekly"
        
        guard let product = subscriptionService.getProduct(for: productID) else {
            return
        }
        
        isLoading = true
        
        Task {
            do {
                let success = try await subscriptionService.purchase(product)
                
                await MainActor.run {
                    isLoading = false
                    
                    if success {
                        dismiss()
                    }
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                }
            }
        }
    }
}

// MARK: - Supporting Views and Styles

private struct SubscriptionScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
} 