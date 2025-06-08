import SwiftUI

struct ScoresView: View {
    @ObservedObject var scoresVM = ScoresViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var animateParticles = false
    
    var body: some View {
        ZStack {
            // Background gradient matching MainMenuView
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
                    .fill(Color.white.opacity(0.1))
                    .frame(width: CGFloat.random(in: 8...20))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .animation(.easeInOut(duration: Double.random(in: 4...10)).repeatForever(autoreverses: true), value: animateParticles)
            }
            
            VStack(spacing: 30) {
                // Header Section
                HStack {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 8) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                            Text("Back")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(25)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                // Title Section
                VStack(spacing: 15) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "trophy.fill")
                            .font(.system(size: 35))
                            .foregroundColor(.yellow)
                    }
                    .scaleEffect(animateParticles ? 1.05 : 1.0)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: animateParticles)
                    
                    Text("Best Scores")
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
                
                // Content Section
                if scoresVM.scores.isEmpty {
                    Spacer()
                    
                    VStack(spacing: 20) {
                        Image(systemName: "gamecontroller")
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.6))
                        
                        Text("No scores yet!")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Play your first game to see your scores here")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    
                    Spacer()
                } else {
                    // Scores List
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(Array(scoresVM.scores.enumerated()), id: \.element.id) { index, entry in
                                HStack(spacing: 16) {
                                    // Rank indicator
                                    ZStack {
                                        Circle()
                                            .fill(rankColor(for: index))
                                            .frame(width: 40, height: 40)
                                        
                                        Text("\(index + 1)")
                                            .font(.system(size: 16, weight: .bold, design: .rounded))
                                            .foregroundColor(.white)
                                    }
                                    
                                    // Player info
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(entry.playerName)
                                            .font(.system(size: 18, weight: .bold, design: .rounded))
                                            .foregroundColor(.white)
                                        
                                        Text(entry.date, style: .date)
                                            .font(.system(size: 14, weight: .medium, design: .rounded))
                                            .foregroundColor(.white.opacity(0.7))
                                    }
                                    
                                    Spacer()
                                    
                                    // Score
                                    VStack(alignment: .trailing, spacing: 2) {
                                        Text("\(entry.moves)")
                                            .font(.system(size: 24, weight: .bold, design: .rounded))
                                            .foregroundColor(.white)
                                        
                                        Text("moves")
                                            .font(.system(size: 12, weight: .medium, design: .rounded))
                                            .foregroundColor(.white.opacity(0.6))
                                    }
                                }
                                .padding(20)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.white.opacity(0.15))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(
                                                    LinearGradient(
                                                        colors: [Color.white.opacity(0.3), Color.white.opacity(0.1)],
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    ),
                                                    lineWidth: 1
                                                )
                                        )
                                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Clear Button
                    Button(action: { scoresVM.clear() }) {
                        HStack {
                            Image(systemName: "trash.fill")
                                .font(.title3)
                            Text("Clear All Scores")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(
                            LinearGradient(
                                colors: [.red.opacity(0.8), .pink.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(27)
                        .shadow(color: .red.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 20)
                }
            }
        }
        .onAppear {
            animateParticles = true
        }
    }
    
    // Helper function for rank colors
    private func rankColor(for index: Int) -> Color {
        switch index {
        case 0:
            return .yellow.opacity(0.8) // Gold
        case 1:
            return .gray.opacity(0.8)   // Silver
        case 2:
            return .orange.opacity(0.6) // Bronze
        default:
            return .blue.opacity(0.6)   // Regular
        }
    }
}

#Preview {
    ScoresView()
}