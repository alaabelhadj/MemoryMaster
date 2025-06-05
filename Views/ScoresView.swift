import SwiftUI

struct ScoresView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var animateCards = false
    
    // Données d'exemple - à remplacer par vos vraies données
    let levelScores = [
        ("Easy", "02:45", "15 moves"),
        ("Medium", "04:23", "28 moves"),
        ("Hard", "07:12", "45 moves"),
        ("Expert", "12:30", "72 moves")
    ]
    
    var body: some View {
        ZStack {
            // Background gradient identique au menu principal
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.purple.opacity(0.8),
                    Color.blue.opacity(0.9),
                    Color.indigo
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Floating particles effect
            ForEach(0..<10, id: \.self) { _ in
                Circle()
                    .fill(Color.white.opacity(0.08))
                    .frame(width: CGFloat.random(in: 8...20))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .animation(.easeInOut(duration: Double.random(in: 4...10)).repeatForever(autoreverses: true), value: animateCards)
            }
            
            VStack(spacing: 30) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                // Title Section
                VStack(spacing: 15) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.15))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "trophy.fill")
                            .font(.system(size: 35))
                            .foregroundColor(.yellow)
                    }
                    .scaleEffect(animateCards ? 1.05 : 1.0)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: animateCards)
                    
                    Text("Best Times")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, .yellow.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                }
                
                // Scores Cards
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 15) {
                        ForEach(Array(levelScores.enumerated()), id: \.offset) { index, score in
                            ScoreCard(
                                level: score.0,
                                time: score.1,
                                moves: score.2,
                                rank: index + 1
                            )
                            .scaleEffect(animateCards ? 1.0 : 0.8)
                            .opacity(animateCards ? 1.0 : 0.0)
                            .animation(.spring().delay(Double(index) * 0.1), value: animateCards)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                Spacer()
                
                // Clear All Button
                Button(action: {
                    // Action pour effacer les scores
                }) {
                    HStack {
                        Image(systemName: "trash.fill")
                            .font(.title3)
                        Text("Clear All Records")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color.red.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(27.5)
                    .shadow(color: .red.opacity(0.4), radius: 8, x: 0, y: 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 27.5)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 20)
            }
        }
        .onAppear {
            animateCards = true
        }
    }
}

struct ScoreCard: View {
    let level: String
    let time: String
    let moves: String
    let rank: Int
    
    private var levelColor: Color {
        switch level {
        case "Easy": return .green
        case "Medium": return .orange
        case "Hard": return .red
        case "Expert": return .purple
        default: return .blue
        }
    }
    
    private var rankEmoji: String {
        switch rank {
        case 1: return "🥇"
        case 2: return "🥈"
        case 3: return "🥉"
        default: return "🏆"
        }
    }
    
    var body: some View {
        HStack(spacing: 15) {
            // Rank
            VStack {
                Text(rankEmoji)
                    .font(.title2)
                Text("#\(rank)")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            // Level indicator
            VStack {
                Circle()
                    .fill(levelColor)
                    .frame(width: 12, height: 12)
                Text(level)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            // Stats
            VStack(alignment: .trailing, spacing: 5) {
                HStack {
                    Image(systemName: "clock.fill")
                        .foregroundColor(.cyan)
                        .font(.caption)
                    Text(time)
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                }
                
                HStack {
                    Image(systemName: "hand.tap.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                    Text(moves)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white.opacity(0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(
                            LinearGradient(
                                colors: [levelColor.opacity(0.6), Color.white.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    ScoresView()
}