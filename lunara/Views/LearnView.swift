import SwiftUI

// Database model for dream articles
struct DreamArticle: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
    let link: String
    let category: ArticleCategory
    
    enum ArticleCategory: String, CaseIterable {
        case science = "Science"
        case techniques = "Techniques"
        case psychology = "Psychology"
        case symbols = "Symbols"
        case research = "Research"
    }
    
    static let allArticles: [DreamArticle] = [
        DreamArticle(
            icon: "moon.stars.fill",
            title: "Understanding REM Sleep",
            description: "Learn how REM sleep affects dreaming and memory consolidation",
            link: "https://example.com/rem-sleep",
            category: .science
        ),
        DreamArticle(
            icon: "brain.head.profile",
            title: "The Science of Nightmares",
            description: "Explore the psychological and neurological causes of nightmares",
            link: "https://example.com/nightmares",
            category: .psychology
        ),
        DreamArticle(
            icon: "bed.double.fill",
            title: "Dream Journaling Methods",
            description: "Effective techniques to record and remember your dreams",
            link: "https://example.com/dream-journaling",
            category: .techniques
        ),
        DreamArticle(
            icon: "sparkles",
            title: "Lucid Dreaming for Beginners",
            description: "Simple steps to start controlling your dreams consciously",
            link: "https://example.com/lucid-dreaming-basics",
            category: .techniques
        ),
        DreamArticle(
            icon: "figure.mind.and.body",
            title: "Dreams and Emotional Healing",
            description: "How dreams can help process emotions and support mental health",
            link: "https://example.com/emotional-healing",
            category: .psychology
        ),
        DreamArticle(
            icon: "eye.fill",
            title: "Dream Symbols Across Cultures",
            description: "Comparative study of dream interpretation in different societies",
            link: "https://example.com/cultural-symbols",
            category: .symbols
        ),
        DreamArticle(
            icon: "clock.fill",
            title: "Circadian Rhythms and Dreams",
            description: "The relationship between your body clock and dream patterns",
            link: "https://example.com/circadian-rhythms",
            category: .science
        ),
        DreamArticle(
            icon: "book.closed.fill",
            title: "Famous Dream Theories",
            description: "Exploring theories from Freud, Jung, and modern neuroscience",
            link: "https://example.com/dream-theories",
            category: .psychology
        ),
        DreamArticle(
            icon: "waveform.path.ecg",
            title: "Sleep Disorders and Dreaming",
            description: "How various sleep disorders affect dream experiences",
            link: "https://example.com/sleep-disorders",
            category: .science
        ),
        DreamArticle(
            icon: "gear.badge",
            title: "Technology and Dream Research",
            description: "Modern tools and apps that help study and enhance dreams",
            link: "https://example.com/dream-technology",
            category: .research
        )
    ]
}

struct LearnCard: View {
    let icon: String
    let title: String
    let description: String
    let buttonTitle: String
    let isPrimary: Bool
    let isAlternate: Bool
    let action: () -> Void
    
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 16) {
                // Left part - Icon
                ZStack {
                    Circle()
                        .fill(lightPurple)
                        .frame(width: 70, height: 70)
                    Image(systemName: icon)
                        .font(.system(size: 28))
                        .foregroundColor(primaryPurple)
                }
                
                // Right part - Text
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineSpacing(2)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            
            Divider()
                .background(lightPurple)
                .padding(.horizontal, 16)
            
            // Action Button
            Button(action: action) {
                HStack(spacing: 8) {
                    Image(systemName: isPrimary ? "play.circle.fill" : "sparkles")
                        .font(.system(size: 16, weight: .semibold))
                    Text(buttonTitle)
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(primaryPurple)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
            }
            .padding(.horizontal, 16)
        }
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(isAlternate ? lightPurple : .white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .strokeBorder(lightPurple, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 4)
    }
}

struct SymbolOfTheDay: View {
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    
    var body: some View {
        VStack(spacing: 16) {
            Text("SYMBOL OF THE DAY")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            ZStack {
                Circle()
                    .fill(lightPurple)
                    .frame(width: 120, height: 120)
                
                Image(systemName: "questionmark")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(primaryPurple)
            }
            .padding(.vertical, 8)
            
            Text("Question Mark")
                .font(.title3)
                .fontWeight(.semibold)
            
            Text("A symbol of mystery and the unknown in dreams")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
            
            Button(action: {
                // Show more details
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 16, weight: .semibold))
                    Text("SHOW MORE")
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
            .padding(.top, 8)
        }
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .strokeBorder(lightPurple, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 4)
    }
}

struct ArticleOfTheDay: View {
    let article: DreamArticle
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 16) {
            Text("ARTICLE OF THE DAY")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(DynamicColors.textSecondary)
            
            ZStack {
                Circle()
                    .fill(DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.3 : 1.0))
                    .frame(width: 120, height: 120)
                
                Image(systemName: article.icon)
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(DynamicColors.primaryPurple)
            }
            .padding(.vertical, 8)
            
            Text(article.title)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(DynamicColors.textPrimary)
                .multilineTextAlignment(.center)
            
            Text(article.description)
                .font(.subheadline)
                .foregroundColor(DynamicColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
            
            Button(action: {
                if let url = URL(string: article.link) {
                    UIApplication.shared.open(url)
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "book.fill")
                        .font(.system(size: 16, weight: .semibold))
                    Text("READ MORE")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(DynamicColors.primaryPurple)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .strokeBorder(DynamicColors.primaryPurple, lineWidth: 1)
                )
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .padding(.vertical, 16)
        .modifier(CardStyle())
    }
}

struct EncyclopediaItem: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    
    var body: some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: 16) {
                // Left part - Icon
                ZStack {
                    Circle()
                        .fill(lightPurple)
                        .frame(width: 50, height: 50)
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(primaryPurple)
                }
                
                // Right part - Text
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                    Text(subtitle.trimmingCharacters(in: .whitespacesAndNewlines))
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing, 8)
                
                Spacer(minLength: 0)
            }
            .frame(width: 250)
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(lightPurple, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 4)
        }
    }
}

struct ArticleCatalogView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @State private var searchText = ""
    @State private var selectedCategories: Set<DreamArticle.ArticleCategory> = []
    
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    
    let articles: [DreamArticle]
    
    private var filteredArticles: [DreamArticle] {
        articles.filter { article in
            // Filter by search text
            let matchesSearch = searchText.isEmpty || 
                article.title.localizedCaseInsensitiveContains(searchText) ||
                article.description.localizedCaseInsensitiveContains(searchText)
            
            // Filter by selected categories
            let matchesCategory = selectedCategories.isEmpty || selectedCategories.contains(article.category)
            
            return matchesSearch && matchesCategory
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField("Search articles...", text: $searchText)
                        .foregroundColor(.primary)
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.bottom, 12)
                
                // Category filters
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(DreamArticle.ArticleCategory.allCases, id: \.self) { category in
                            CategoryFilterButton(
                                category: category,
                                isSelected: selectedCategories.contains(category),
                                action: {
                                    toggleCategory(category)
                                }
                            )
                        }
                        
                        if !selectedCategories.isEmpty {
                            Button(action: {
                                selectedCategories.removeAll()
                            }) {
                                Text("Clear")
                                    .foregroundColor(primaryPurple)
                                    .font(.system(size: 14, weight: .medium))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(primaryPurple, lineWidth: 1)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                }
                
                Divider()
                
                // Results count
                HStack {
                    if filteredArticles.isEmpty {
                        Text("No articles found")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    } else {
                        Text("\(filteredArticles.count) article\(filteredArticles.count == 1 ? "" : "s")")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                if filteredArticles.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                        Text("No matching articles found")
                            .font(.title3)
                            .fontWeight(.medium)
                        Text("Try adjusting your search or filters")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // Articles grid
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(filteredArticles) { article in
                                ArticleGridItem(article: article)
                            }
                        }
                        .padding(16)
                    }
                }
            }
            .navigationTitle("Dream Encyclopedia")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(primaryPurple)
                    }
                }
            }
        }
    }
    
    private func toggleCategory(_ category: DreamArticle.ArticleCategory) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
    }
}

struct CategoryFilterButton: View {
    let category: DreamArticle.ArticleCategory
    let isSelected: Bool
    let action: () -> Void
    
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    
    var body: some View {
        Button(action: action) {
            Text(category.rawValue)
                .font(.system(size: 14, weight: isSelected ? .semibold : .medium))
                .foregroundColor(isSelected ? .white : primaryPurple)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isSelected ? primaryPurple : Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(isSelected ? Color.clear : primaryPurple, lineWidth: 1)
                        )
                )
        }
    }
}

struct ArticleGridItem: View {
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    
    let article: DreamArticle
    
    var body: some View {
        Link(destination: URL(string: article.link)!) {
            VStack(alignment: .leading, spacing: 12) {
                // Header with icon and category
                HStack(alignment: .center) {
                    // Icon
                    ZStack {
                        Circle()
                            .fill(lightPurple)
                            .frame(width: 50, height: 50)
                        Image(systemName: article.icon)
                            .font(.system(size: 24))
                            .foregroundColor(primaryPurple)
                    }
                    
                    Spacer()
                    
                    // Category tag
                    Text(article.category.rawValue)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(primaryPurple)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(lightPurple.opacity(0.7))
                        )
                }
                .padding(.top, 8)
                
                // Title
                Text(article.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
                    .padding(.top, 4)
                
                // Description
                Text(article.description.trimmingCharacters(in: .whitespacesAndNewlines))
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .padding(.top, 16)
            .padding(.bottom, 16)
            .padding(.horizontal, 16)
            .frame(height: 180)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(UIColor.systemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(lightPurple, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 4)
        }
    }
}

struct LearnView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var showArticleCatalog = false
    @State private var showDailyRitual = false
    @State private var showLucidDreaming = false
    @State private var showDreamingFact = false
    @State private var searchText: String = ""
    @State private var selectedCategory: DreamArticle.ArticleCategory? = nil
    @State private var expandedArticle: UUID? = nil
    
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    private var filteredArticles: [DreamArticle] {
        var articles = DreamArticle.allArticles
        
        // Apply category filter if selected
        if let category = selectedCategory {
            articles = articles.filter { $0.category == category }
        }
        
        // Apply search text filter if not empty
        if !searchText.isEmpty {
            articles = articles.filter {
                $0.title.lowercased().contains(searchText.lowercased()) ||
                $0.description.lowercased().contains(searchText.lowercased())
            }
        }
        
        return articles
    }
    
    // Random article for the "Article of the Day" section
    private var articleOfTheDay: DreamArticle {
        DreamArticle.allArticles.randomElement() ?? DreamArticle.allArticles[0]
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                DynamicColors.backgroundPrimary.edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header section with title
                        TopBarView(
                            title: "Learn",
                            primaryPurple: DynamicColors.primaryPurple,
                            colorScheme: colorScheme,
                            rightButtons: []
                        )
                        
                        // Search Bar
                        searchBar
                            .padding(.horizontal, 16)
                        
                        // Category Filters
                        categoryFilters
                            .padding(.horizontal, 16)
                        
                        // Article of the Day
                        ArticleOfTheDay(article: articleOfTheDay)
                            .padding(.horizontal, 16)
                        
                        // Article Grid
                        articleGrid
                            .padding(.horizontal, 16)
                        
                        Spacer(minLength: 80)
                    }
                    .padding(.bottom, 24)
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var searchBar: some View {
                            HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(DynamicColors.gray3)
            
            TextField("Search articles...", text: $searchText)
                .foregroundColor(DynamicColors.textPrimary)
            
            if !searchText.isEmpty {
                                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(DynamicColors.gray3)
                }
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(DynamicColors.backgroundSecondary)
        )
    }
    
    private var categoryFilters: some View {
                            ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // All categories option
                CategoryPill(
                    name: "All",
                    isSelected: selectedCategory == nil,
                    action: { selectedCategory = nil }
                )
                
                // Individual category pills
                ForEach(DreamArticle.ArticleCategory.allCases, id: \.self) { category in
                    CategoryPill(
                        name: category.rawValue,
                        isSelected: selectedCategory == category,
                        action: {
                            selectedCategory = category
                        }
                    )
                }
            }
            .padding(.vertical, 8)
        }
    }
    
    private var articleGrid: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(filteredArticles) { article in
                ArticleCard(article: article)
            }
        }
    }
}

struct CategoryPill: View {
    let name: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(name)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : DynamicColors.primaryPurple)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? DynamicColors.primaryPurple : DynamicColors.primaryPurple.opacity(0.1))
                )
        }
    }
}

struct ArticleCard: View {
    let article: DreamArticle
    @State private var isPressed = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: {
            if let url = URL(string: article.link) {
                UIApplication.shared.open(url)
            }
        }) {
            VStack(alignment: .leading, spacing: 12) {
                // Icon
                ZStack {
                    Circle()
                        .fill(DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.3 : 1.0))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: article.icon)
                        .font(.system(size: 24))
                        .foregroundColor(DynamicColors.primaryPurple)
                }
                
                // Title
                Text(article.title)
                    .font(.headline)
                    .foregroundColor(DynamicColors.textPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                // Category
                Text(article.category.rawValue)
                    .font(.caption)
                    .foregroundColor(DynamicColors.primaryPurple)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(DynamicColors.primaryPurple.opacity(0.1))
                    )
                
                Spacer()
            }
            .padding(16)
            .frame(height: 160)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(colorScheme == .dark ? Color(white: 0.15) : .white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(DynamicColors.primaryPurple.opacity(0.15), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
            .onLongPressGesture(minimumDuration: .infinity, maximumDistance: 50) {
                // Never triggered
            } onPressingChanged: { pressing in
                isPressed = pressing
            }
        }
    }
}

struct ArticleListItem: View {
    let article: DreamArticle
    
    var body: some View {
        VStack(spacing: 16) {
            // Header with icon and title
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.3 : 1.0))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: article.icon)
                        .font(.system(size: 24))
                        .foregroundColor(DynamicColors.primaryPurple)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(article.title)
                        .font(.headline)
                        .foregroundColor(DynamicColors.textPrimary)
                    
                    Text(article.category.rawValue)
                        .font(.subheadline)
                        .foregroundColor(DynamicColors.primaryPurple)
                }
                
                Spacer()
            }
            
            // Description
            Text(article.description)
                .font(.body)
                .foregroundColor(DynamicColors.textSecondary)
                .multilineTextAlignment(.leading)
            
            // Read More button
            Button(action: {
                if let url = URL(string: article.link) {
                    UIApplication.shared.open(url)
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 16, weight: .semibold))
                    Text("SHOW MORE")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(DynamicColors.primaryPurple)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .strokeBorder(DynamicColors.primaryPurple, lineWidth: 1)
                )
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .padding(.vertical, 16)
        .modifier(CardStyle())
    }
    
    @Environment(\.colorScheme) var colorScheme
}

#Preview {
    LearnView()
} 