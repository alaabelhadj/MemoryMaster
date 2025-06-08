import SwiftUI

struct ScoreEntry: Identifiable, Codable {
    let id = UUID()
    let playerName: String
    let moves: Int
    let date: Date
}

class ScoresViewModel: ObservableObject {
    @Published var scores: [ScoreEntry] = []

    init() {
        load()
    }

    func addScore(_ entry: ScoreEntry) {
        scores.append(entry)
        scores.sort { $0.moves < $1.moves }
        save()
    }

    private func save() {
        if let data = try? JSONEncoder().encode(scores) {
            UserDefaults.standard.set(data, forKey: "scores")
        }
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: "scores"),
           let decoded = try? JSONDecoder().decode([ScoreEntry].self, from: data) {
            scores = decoded
        }
    }

    func clear() {
        scores = []
        UserDefaults.standard.removeObject(forKey: "scores")
    }
} 