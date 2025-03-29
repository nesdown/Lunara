import Foundation
import Models

// Notification names for dream storage events
extension Notification.Name {
    static let dreamsSaved = Notification.Name("dreamsSaved")
}

class DreamStorageService {
    static let shared = DreamStorageService()
    
    private let userDefaults = UserDefaults.standard
    private let dreamsKey = "savedDreams"
    
    private init() {}
    
    // MARK: - Save Operations
    
    func saveDream(_ dream: DreamEntry) {
        var dreams = getAllDreams()
        
        // Check if dream already exists (update)
        if let index = dreams.firstIndex(where: { $0.id == dream.id }) {
            dreams[index] = dream
        } else {
            dreams.append(dream)
        }
        
        saveDreams(dreams)
        
        // Post notification that dreams were updated
        NotificationCenter.default.post(name: .dreamsSaved, object: nil)
    }
    
    private func saveDreams(_ dreams: [DreamEntry]) {
        do {
            let data = try JSONEncoder().encode(dreams)
            userDefaults.set(data, forKey: dreamsKey)
        } catch {
            print("Error saving dreams: \(error)")
        }
    }
    
    // MARK: - Retrieve Operations
    
    func getAllDreams() -> [DreamEntry] {
        guard let data = userDefaults.data(forKey: dreamsKey) else { return [] }
        
        do {
            let dreams = try JSONDecoder().decode([DreamEntry].self, from: data)
            return dreams.sorted(by: { $0.createdAt > $1.createdAt }) // Sort by date (newest first)
        } catch {
            print("Error retrieving dreams: \(error)")
            return []
        }
    }
    
    func getLatestDreams(limit: Int = 3) -> [DreamEntry] {
        let dreams = getAllDreams()
        return Array(dreams.prefix(limit))
    }
    
    func getDream(with id: UUID) -> DreamEntry? {
        return getAllDreams().first { $0.id == id }
    }
    
    func dreamExists(id: UUID) -> Bool {
        return getAllDreams().contains { $0.id == id }
    }
    
    func getDreams(for date: Date) -> [DreamEntry] {
        let calendar = Calendar.current
        return getAllDreams().filter { dream in
            calendar.isDate(dream.createdAt, inSameDayAs: date)
        }
    }
    
    func getDreamsGroupedByMonth() -> [Date: [DreamEntry]] {
        let dreams = getAllDreams()
        var groupedDreams: [Date: [DreamEntry]] = [:]
        
        let calendar = Calendar.current
        for dream in dreams {
            let components = calendar.dateComponents([.year, .month], from: dream.createdAt)
            if let firstDayOfMonth = calendar.date(from: components) {
                if groupedDreams[firstDayOfMonth] == nil {
                    groupedDreams[firstDayOfMonth] = []
                }
                groupedDreams[firstDayOfMonth]?.append(dream)
            }
        }
        
        return groupedDreams
    }
    
    // MARK: - Delete Operations
    
    func deleteDream(with id: UUID) {
        var dreams = getAllDreams()
        dreams.removeAll { $0.id == id }
        saveDreams(dreams)
        
        // Post notification that dreams were updated
        NotificationCenter.default.post(name: .dreamsSaved, object: nil)
    }
    
    // Alias for deleteDream for better semantic clarity
    func removeDream(id: UUID) {
        deleteDream(with: id)
    }
    
    func deleteAllDreams() {
        saveDreams([])
        
        // Post notification that dreams were updated
        NotificationCenter.default.post(name: .dreamsSaved, object: nil)
    }
} 