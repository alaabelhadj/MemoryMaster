import Foundation

struct MemoryCard: Identifiable, Equatable {
    let id = UUID()
    let content: String // emoji ou nom d'image
    var isFaceUp: Bool = false
    var isMatched: Bool = false
}
