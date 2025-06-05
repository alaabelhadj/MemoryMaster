import SwiftUI

class ScoresViewModel: ObservableObject {
    @Published var bestTimes: [Level: [Int]] = [:] // à persister avec UserDefaults/CoreData
} 