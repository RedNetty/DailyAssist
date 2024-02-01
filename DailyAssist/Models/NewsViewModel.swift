x   
import Foundation
import SwiftUI
import SwiftSoup
import FeedKit



class NewsViewModel: ObservableObject {
    @Published var newsItems: [NewsItem] = []

    func fetchNewsItems(url: String) {
           guard let url = URL(string: url) else {
               print("Invalid URL")
               return
           }

           let parser = FeedParser(URL: url)
           parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { [weak self] (result) in
               DispatchQueue.main.async { // Ensure we're on the main thread when checking the result
                   switch result {
                   case .success(let feed):
                       if let items = self?.processFeed(feed) {
                           self?.newsItems.append(contentsOf: items)
                           self?.shuffleNewsItems() // Shuffle after adding new items
                       }
                   case .failure(let error):
                       print("An error occurred: \(error.localizedDescription)")
                   }
               }
           }
       }

    private func processFeed(_ feed: Feed) -> [NewsItem] {
        guard let rssItems = feed.rssFeed?.items else { return [] }
        newsItems.shuffle()
        
        return rssItems.compactMap { item in
            NewsItem(title: item.title ?? "Unknown Title",
                     feedTitle: feed.rssFeed?.title ?? "Unknown Feed Title",
                     summary: item.description ?? "No summary available",
                     source: item.source?.value ?? "Unknown Source",
                     link: item.link.flatMap(URL.init) ?? URL(string: "https://www.example.com")!,
                     date: item.pubDate ?? Date(),
                     category: categorizeNewsItem(title: item.title, summary: item.description))
        }
    
    }
    func shuffleNewsItems() {
        // Direct updates to @Published properties are already in a main thread context
        // from the calling point in fetchNewsItems, but if called elsewhere, ensure
        // DispatchQueue.main.async is used.
        newsItems.shuffle()
    }

    
    private func categorizeNewsItem(title: String?, summary: String?) -> String {
        // keyword definitions for broader categorization
        let categories = [
            "World News": ["ukraine","gaza", "world", "china","international affairs", "global summit", "world leader", "UN", "NATO", "WHO", "foreign policy", "embassy", "sanctions", "human rights", "international crisis", "peace talks", "global economy", "climate summit", "G7", "G20", "EU", "Brexit", "ASEAN", "Middle East", "Asia-Pacific", "Africa", "Latin America", "European Union"],
            "Crime": ["murder", "homicide", "theft", "robbery", "assault", "crime", "fraud", "embezzlement", "scandal", "arrest", "investigation", "police", "FBI", "CIA", "law enforcement", "drug trafficking", "human trafficking", "cybercrime", "identity theft", "money laundering", "terrorist", "shooting", "stabbing", "burglary", "domestic violence", "sexual assault", "child abuse"],
            "Politics": ["gaza", "israel", "ukraine", "russia", "election", "government", "senate", "congress", "parliament", "president", "prime minister", "policy", "legislation", "diplomacy", "campaign", "political party", "vote", "democracy", "autocracy", "sanction", "political crisis", "impeachment", "referendum", "coup", "civil rights", "social justice", "lobbying", "corruption", "political debate", "foreign relations", "trade agreement", "nuclear deal"],
            "Technology": ["tech", "gadget", "silicon valley", "startup", "innovation", "AI", "artificial intelligence", "machine learning", "software", "hardware", "cybersecurity", "internet", "blockchain", "cryptocurrency", "data breach", "VR", "virtual reality", "AR", "augmented reality", "IoT", "internet of things", "cloud computing", "big data", "quantum computing", "5G", "robotics", "drones", "tech regulation", "privacy", "data protection", "e-commerce", "social media", "gaming", "esports"],
            "Sports": ["football", "basketball", "soccer", "olympics", "tennis", "golf", "baseball", "NBA", "NFL", "FIFA", "NHL", "marathon", "track and field", "boxing", "MMA", "UFC", "cycling", "tour de france", "cricket", "rugby", "world cup", "swimming", "gymnastics", "figure skating", "skiing", "snowboarding", "skateboarding", "surfing", "equestrian", "badminton", "table tennis", "volleyball", "hockey", "biathlon", "triathlon", "Paralympics", "X Games"],
            "Entertainment": ["movie", "film", "cinema", "actor", "actress", "director", "screenplay", "hollywood", "bollywood", "film festival", "Oscars", "Grammys", "Emmys", "Cannes", "Netflix", "Amazon Prime", "Disney+", "HBO", "streaming", "TV show", "television", "celebrity", "music", "album", "concert", "tour", "band", "singer", "music video", "pop culture", "fashion", "red carpet", "premiere", "art exhibit", "literature", "book release", "bestseller", "comic", "manga", "anime", "fan convention", "cosplay"],
            "Economy": ["stock market", "NASDAQ", "Dow Jones", "S&P 500", "trading", "investment", "economy", "recession", "inflation", "deflation", "monetary policy", "fiscal policy", "central bank", "Federal Reserve", "European Central Bank", "cryptocurrency", "Bitcoin", "Ethereum", "ICO", "startup funding", "venture capital", "private equity", "IPO", "unemployment rate", "job market", "real estate", "housing market", "mortgage rates", "GDP", "trade deficit", "export", "import", "tariff", "trade war", "economic sanctions", "oil prices", "commodities market"],
            "Health": ["healthcare", "medical research", "COVID-19", "coronavirus", "pandemic", "vaccine", "immunization", "disease", "cancer", "heart disease", "diabetes", "mental health", "psychology", "wellness", "fitness", "nutrition", "diet", "obesity", "surgery", "hospital", "doctor", "nurse", "medicine", "pharmaceuticals", "drug approval", "FDA", "CDC", "WHO", "public health", "health policy", "insurance", "medicare", "medicaid", "health tech", "telemedicine", "biotech"],
            "Science": ["science", "research", "innovation", "NASA", "space", "astronomy", "astrophysics", "planet", "Mars mission", "space travel", "spaceX", "rocket", "physics", "chemistry", "biology", "genetics", "genome", "CRISPR", "climate change", "environment", "ecology", "sustainability", "renewable energy", "solar power", "wind power", "nuclear energy", "earthquake", "volcanology", "oceanography", "paleontology", "archaeology", "history", "anthropology", "STEM education", "scientific discovery", "quantum mechanics", "artificial intelligence research"]
        ]
        
        let safeTitle = title?.lowercased() ?? ""
           let safeSummary = summary?.lowercased() ?? ""

           for (category, keywords) in categories {
               for keyword in keywords {
                   if safeTitle.contains(keyword) || safeSummary.contains(keyword) {
                       return category
                   }
               }
           }

           return "General"
    }
}
