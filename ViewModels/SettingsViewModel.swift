import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var selectedTheme: Theme = .emojis
    @Published var soundOn: Bool = true
} 