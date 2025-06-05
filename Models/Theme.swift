import Foundation

enum Theme: String, CaseIterable {
    case emojis, shapes

    var displayName: String {
        switch self {
        case .emojis: return "Emojis"
        case .shapes: return "Shapes"
        }
    }
    var contents: [String] {
        switch self {
        case .emojis:
            return ["😀","😅","😂","🥰","😎","🤩","😇","🥳","😡","😭","😱","🤠","👻","💩","👽","🤖","🎃","😺"]
        case .shapes:
            return ["▲","■","●","◆","★","♥️","♣️","♠️","⬟","⬢","⬣","⬤","⬥","⬦","⬧","⬨","⬩","⬪"]
        }
    }
} 