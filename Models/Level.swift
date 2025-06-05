import Foundation

enum Level: String, CaseIterable {
    case easy, medium, hard, expert

    var displayName: String {
        switch self {
        case .easy: return "Easy 4x3"
        case .medium: return "Medium 4x4"
        case .hard: return "Hard 6x4"
        case .expert: return "Expert 6x6"
        }
    }
    var grid: (rows: Int, columns: Int) {
        switch self {
        case .easy: return (3, 4)
        case .medium: return (4, 4)
        case .hard: return (4, 6)
        case .expert: return (6, 6)
        }
    }
} 