import SwiftUI

class GameViewModel: ObservableObject {
    @Published var cards: [MemoryCard] = []
    @Published var moves: Int = 0
    @Published var pairsFound: Int = 0
    @Published var isGameOver: Bool = false

    // Configuration par défaut : 4x3
    let rows: Int = 3
    let columns: Int = 4
    let theme: Theme = .emojis

    private var indexOfFirstFaceUp: Int?

    init() {
        startNewGame()
    }

    func startNewGame() {
        moves = 0
        pairsFound = 0
        isGameOver = false
        indexOfFirstFaceUp = nil

        let pairCount = (rows * columns) / 2
        let contents = Array(theme.contents.shuffled().prefix(pairCount))
        var newCards: [MemoryCard] = []
        for content in contents {
            newCards.append(MemoryCard(content: content))
            newCards.append(MemoryCard(content: content))
        }
        cards = newCards.shuffled()
    }

    func choose(_ card: MemoryCard) {
        guard let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
              !cards[chosenIndex].isFaceUp,
              !cards[chosenIndex].isMatched else { return }

        if let potentialMatchIndex = indexOfFirstFaceUp {
            cards[chosenIndex].isFaceUp = true
            moves += 1
            if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                cards[chosenIndex].isMatched = true
                cards[potentialMatchIndex].isMatched = true
                pairsFound += 1
                if pairsFound == cards.count / 2 {
                    isGameOver = true
                }
                indexOfFirstFaceUp = nil
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.cards[chosenIndex].isFaceUp = false
                    self.cards[potentialMatchIndex].isFaceUp = false
                    self.indexOfFirstFaceUp = nil
                    self.objectWillChange.send()
                }
            }
        } else {
            for idx in cards.indices {
                cards[idx].isFaceUp = false
            }
            cards[chosenIndex].isFaceUp = true
            indexOfFirstFaceUp = chosenIndex
        }
        objectWillChange.send()
    }
} 