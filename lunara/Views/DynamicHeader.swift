import SwiftUI

struct DynamicHeader: View {
    @State private var currentDate = Date()
    @State private var timer: Timer?
    
    var greeting: String {
        let hour = Calendar.current.component(.hour, from: currentDate)
        
        // Arrays of emojis for each time period
        let morningEmojis = ["🌅", "🌞", "☀️", "🌻", "🍳"]
        let afternoonEmojis = ["🌤️", "🌸", "🌺", "🦋", "🌈"]
        let eveningEmojis = ["🌙", "✨", "🌟", "🌖", "🌌"]
        let nightEmojis = ["💫", "🌠", "🌛", "⭐️", "🌜"]
        
        // Get random emoji for the current time period
        let randomEmoji: String = {
            let emojis: [String]
            switch hour {
            case 5..<12:
                emojis = morningEmojis
            case 12..<17:
                emojis = afternoonEmojis
            case 17..<22:
                emojis = eveningEmojis
            default:
                emojis = nightEmojis
            }
            return emojis[Int.random(in: 0..<emojis.count)]
        }()
        
        switch hour {
        case 5..<12:
            return "Good morning \(randomEmoji)"
        case 12..<17:
            return "Good afternoon \(randomEmoji)"
        case 17..<22:
            return "Good evening \(randomEmoji)"
        default:
            return "Good night \(randomEmoji)"
        }
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d"
        return formatter.string(from: currentDate)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(greeting)
                .font(.system(size: 26, weight: .bold))
            Text(formattedDate)
                .font(.system(size: 22, weight: .regular))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear {
            // Update time every minute
            timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
                currentDate = Date()
            }
        }
        .onDisappear {
            timer?.invalidate()
            timer = nil
        }
    }
} 