import SwiftUI
import Foundation

struct DreamContentView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: DreamContentViewModel
    @State private var tipIndex = 0
    @State private var showTip = false
    @State private var pulseAnimation = false
    
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    
    // Dream tips to show during loading
    private let dreamTips = [
        "Most people have 4-6 dreams per night...",
        "Dream journaling can improve dream recall by 50%...",
        "Lucid dreamers can control their dream environment...",
        "REM sleep is when most vivid dreams occur...",
        "Dreams help process emotions and memories...",
        "Everyone dreams, even if they don't remember...",
        "Dream symbols are highly personal to each dreamer...",
        "Dream content is influenced by daily experiences..."
    ]
    
    init(contentType: DreamContentType) {
        _viewModel = StateObject(wrappedValue: DreamContentViewModel(contentType: contentType))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color(UIColor.systemBackground)
                    .edgesIgnoringSafeArea(.all)
                
                if viewModel.isLoading {
                    enhancedLoadingView
                } else if let error = viewModel.errorMessage {
                    errorView(message: error)
                } else if let content = viewModel.currentContent {
                    ScrollView {
                        VStack(spacing: 24) {
                            headerView(icon: viewModel.contentType.icon, title: content.title)
                            
                            introductionView(text: content.introduction)
                            
                            // Content sections
                            ForEach(content.sections) { section in
                                contentSectionView(section: section)
                            }
                            
                            conclusionView(text: content.conclusion)
                            
                            improvedShareButton
                                .padding(.top, 16)
                                .padding(.bottom, 32)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                    }
                } else {
                    emptyView
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(viewModel.contentType.rawValue)
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(primaryPurple)
                    }
                }
            }
            .task {
                if viewModel.currentContent == nil {
                    await viewModel.fetchContent()
                }
            }
        }
    }
    
    // MARK: - Enhanced Loading View
    
    private var enhancedLoadingView: some View {
        VStack(spacing: 40) {
            // Animated icon
            ZStack {
                Circle()
                    .fill(lightPurple.opacity(0.5))
                    .frame(width: 120, height: 120)
                    .scaleEffect(pulseAnimation ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: pulseAnimation)
                
                Circle()
                    .fill(lightPurple)
                    .frame(width: 100, height: 100)
                
                Image(systemName: viewModel.contentType.icon)
                    .font(.system(size: 40))
                    .foregroundColor(primaryPurple)
                    .rotationEffect(.degrees(pulseAnimation ? 10 : -10))
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: pulseAnimation)
            }
            .onAppear {
                pulseAnimation = true
            }
            
            VStack(spacing: 16) {
                Text("Generating your \(viewModel.contentType.rawValue.lowercased())...")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                // Animated progress bar
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 6)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(primaryPurple)
                        .frame(width: pulseAnimation ? UIScreen.main.bounds.width * 0.7 : 50, height: 6)
                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: pulseAnimation)
                }
                .frame(width: UIScreen.main.bounds.width * 0.7)
                
                // Animated tips
                Text(dreamTips[tipIndex])
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .frame(height: 50)
                    .opacity(showTip ? 1 : 0)
                    .onAppear {
                        showTip = true
                        // Start the timer to cycle through tips
                        Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { _ in
                            withAnimation(.easeInOut(duration: 0.7)) {
                                showTip = false
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                tipIndex = (tipIndex + 1) % dreamTips.count
                                withAnimation(.easeInOut(duration: 0.7)) {
                                    showTip = true
                                }
                            }
                        }
                    }
            }
        }
    }
    
    // MARK: - Subviews
    
    private func errorView(message: String) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            Text("Something went wrong")
                .font(.title3)
                .fontWeight(.bold)
            
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            Button(action: {
                Task {
                    await viewModel.fetchContent()
                }
            }) {
                Text("Try Again")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(primaryPurple)
                    .cornerRadius(10)
            }
            .padding(.top, 8)
        }
    }
    
    private var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "moon.stars")
                .font(.system(size: 50))
                .foregroundColor(primaryPurple)
            
            Text("Let's explore your \(viewModel.contentType.rawValue.lowercased())")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Button(action: {
                Task {
                    await viewModel.fetchContent()
                }
            }) {
                Text("Generate Content")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(primaryPurple)
                    .cornerRadius(10)
            }
            .padding(.top, 8)
        }
    }
    
    private func headerView(icon: String, title: String) -> some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(lightPurple)
                    .frame(width: 100, height: 100)
                
                Image(systemName: icon)
                    .font(.system(size: 50))
                    .foregroundColor(primaryPurple)
            }
            
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.bottom, 8)
    }
    
    private func introductionView(text: String) -> some View {
        Text(text)
            .font(.body)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, 8)
    }
    
    private func contentSectionView(section: DreamContent.ContentSection) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(section.heading)
                .font(.headline)
                .foregroundColor(primaryPurple)
                .fixedSize(horizontal: false, vertical: true)
            
            Text(section.content)
                .font(.body)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.secondarySystemBackground))
        )
    }
    
    private func conclusionView(text: String) -> some View {
        Text(text)
            .font(.headline)
            .foregroundColor(primaryPurple)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
    }
    
    // MARK: - Improved Share Button
    
    private var improvedShareButton: some View {
        Button(action: {
            viewModel.shareContent()
        }) {
            HStack(spacing: 8) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 16, weight: .semibold))
                Text("SHARE")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(primaryPurple)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(primaryPurple, lineWidth: 1)
            )
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    DreamContentView(contentType: .dailyRitual)
} 