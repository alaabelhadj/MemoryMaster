import SwiftUI

struct GameView: View {
    @ObservedObject var settings = SettingsViewModel()
    @StateObject var viewModel = GameViewModel()
    @ObservedObject var scoresVM = ScoresViewModel()
    @Environment(\.dismiss) var dismiss
    let playerName: String
    @State private var showScoreAlert = false

    init(playerName: String) {
        self.playerName = playerName
    }

    var body: some View {
        ZStack {
            // Fond élégant (dégradé subtil)
            LinearGradient(gradient: Gradient(colors: [Color.black, Color(.darkGray)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack(spacing: 24) {
                // Header moderne
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.blue.opacity(0.7))
                            .clipShape(Circle())
                    }
                    Spacer()
                    VStack(spacing: 4) {
                        Text("Moves")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("\(viewModel.moves)")
                            .font(.title2).bold()
                            .foregroundColor(.white)
                    }
                    Spacer()
                    VStack(spacing: 4) {
                        Text("Score")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("\(viewModel.pairsFound * 10)")
                            .font(.title2).bold()
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
                // Barre de progression (optionnelle)
                ProgressView(value: Double(viewModel.pairsFound), total: Double(viewModel.cards.count/2))
                    .accentColor(.blue)
                    .padding(.horizontal)
                // Grille de cartes
                let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: viewModel.columns)
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(viewModel.cards) { card in
                        CardView(card: card)
                            .onTapGesture {
                                withAnimation {
                                    viewModel.choose(card)
                                }
                            }
                            .aspectRatio(2/3, contentMode: .fit)
                    }
                }
                .padding(.horizontal)
                // Boutons stylés
                HStack(spacing: 20) {
                    Button(action: { viewModel.startNewGame() }) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Restart")
                        }
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                    }
                    Button(action: { dismiss() }) {
                        HStack {
                            Image(systemName: "house")
                            Text("Menu")
                        }
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(30)
                    }
                }
                .padding(.horizontal)
                Spacer(minLength: 10)
            }
        }
        .onChange(of: viewModel.isGameOver) { isOver in
            if isOver {
                let entry = ScoreEntry(playerName: playerName, moves: viewModel.moves, date: Date())
                scoresVM.addScore(entry)
                showScoreAlert = true
            }
        }
        .alert("Congratulations!", isPresented: $showScoreAlert) {
            Button("Play Again") { viewModel.startNewGame(); showScoreAlert = false }
            Button("Return to Menu") { dismiss() }
        } message: {
            Text("You found all pairs in \(viewModel.moves) moves!")
        }
    }
}

struct CardView: View {
    let card: MemoryCard

    var body: some View {
        ZStack {
            if card.isFaceUp || card.isMatched {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: Color.blue.opacity(0.15), radius: 8, x: 0, y: 4)
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.blue, lineWidth: 3)
                Text(card.content)
                    .font(.system(size: 38))
            } else {
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color(.systemIndigo)]), startPoint: .top, endPoint: .bottom))
                    .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 3)
                Image(systemName: "questionmark")
                    .font(.title)
                    .foregroundColor(.white.opacity(0.5))
            }
        }
        .opacity(card.isMatched ? 0 : 1)
        .rotation3DEffect(
            .degrees(card.isFaceUp ? 0 : 180),
            axis: (x: 0, y: 1, z: 0)
        )
        .animation(.easeInOut(duration: 0.4), value: card.isFaceUp)
    }
} 