import SwiftUI

struct TodaysNewsView: View {
    @StateObject private var viewModel = NewsViewModel()

    @State private var selectedCategory: NewsCategory = .all // Default selection
    // Computed property to filter news items based on category and publication date
    private var filteredAndRecentNewsItems: [NewsItem] {
        let twoWeeksAgo = Calendar.current.date(byAdding: .day, value: -14, to: Date())!
        return viewModel.newsItems.filter { item in
            (item.category == selectedCategory.rawValue || selectedCategory == .all) && item.date > twoWeeksAgo
        }
    }

    enum NewsCategory: String, CaseIterable {
        case all = "All"
        case politics = "Politics"
        case technology = "Technology"
        case sports = "Sports"
        case crime = "Crime"
        case economy = "Economy"
        case worldNews = "World News"
        case health = "Health"
        case science = "Science"
        // Add more categories as needed
    }

        var body: some View {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(NewsCategory.allCases, id: \.self) { category in
                            CategoryButton(category: category.rawValue, isSelected: selectedCategory == category) {
                                selectedCategory = category
                            }
                        }
                    }
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(20)
                    .shadow(radius: 5)
                    .padding()
                }

                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(filteredAndRecentNewsItems) { item in
                            NewsItemCard(newsItem: item)
                        }
                    }
                    .padding()
                }
            }
            .onAppear {
                     // Fetching news from various sources
                     let urls = [
                         "http://images.apple.com/main/rss/hotnews/hotnews.rss",
                         "https://www.newschannel5.com/news.rss",
                         "https://search.cnbc.com/rs/search/combinedcms/view.xml?partnerId=wrss01&id=20910258",
                         "https://search.cnbc.com/rs/search/combinedcms/view.xml?partnerId=wrss01&id=100003114",
                         "https://www.apple.com/newsroom/?sr=hotnews.rss",
                         "https://rss.nytimes.com/services/xml/rss/nyt/World.xml",
                     ]
                     urls.forEach { viewModel.fetchNewsItems(url: $0) }
                 }
             }
        }

    struct CategoryButton: View {
        
        @State private var isHovering = false
        let category: String
        let isSelected: Bool
        let action: () -> Void

        var body: some View {
            Button(action: action) {
                Text(category)
                    .fontWeight(.semibold)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(isSelected ? Color.purple : isHovering ? Color.purple.opacity(0.25): Color.gray.opacity(0.3))
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .onHover(perform: { hovering in
                        isHovering = hovering;
                    })
            }
            .buttonStyle(PlainButtonStyle())
            .shadow(radius: isSelected ? 5 : 0)
        }
    }

struct NewsItemCard: View {
    let newsItem: NewsItem
    @State private var isHovering = false
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(newsItem.title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary) // Ensure title is readable

            Text(newsItem.summary)
                .font(.subheadline)
                .lineLimit(3)
                .foregroundColor(.secondary) // Improved contrast for summary

            Text("From: \(newsItem.feedTitle), Publish Date: \(newsItem.date, formatter: dateFormatter)")
                .font(.caption)
                .foregroundColor(.gray) // Ensure date is readable

            Button(action: {
                        // Handle navigation
                if let url = URL(string: newsItem.link.absoluteString) {
                            NSWorkspace.shared.open(url)
                        }
                    }) {
                        Text("Read More")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .frame(width: 100, height: 25)
                            .background(isHovering ?
                                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.purple.opacity(0.5)]), startPoint: .leading, endPoint: .trailing) :
                                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.25), Color.purple.opacity(0.25)]), startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.blue) // Link color for readability
                    }
                    .buttonStyle(PlainButtonStyle()) // Removes button styling
                    .onHover { hovering in
                        isHovering = hovering
                    }
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 100, alignment: .leading) // Standardizing size
        .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]), startPoint: .leading, endPoint: .trailing))// Adapts to light/dark mode
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}

    

// Assuming you have a NewsItem struct and NewsViewModel class defined elsewhere

// DateFormatter for displaying the publish date
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
}()

