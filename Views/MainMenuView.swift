import SwiftUI

struct MainMenuView: View {
    @State private var showScores = false
    @State private var showSettings = false
    @State private var showGame = false
    @State private var playerName: String = ""
    @State private var showNamePrompt = false
    @State private var animateTitle = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
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
                ForEach(0..<15, id: \.self) { _ in
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: CGFloat.random(in: 10...30))
                        .position(
                            x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                            y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                        )
                        .animation(.easeInOut(duration: Double.random(in: 3...8)).repeatForever(autoreverses: true), value: animateTitle)
                }
                
                VStack(spacing: 50) {
                    Spacer()
                    
                    // Title Section
                    VStack(spacing: 20) {
                        // Icon/Logo
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.2))
                                .frame(width: 120, height: 120)
                            
                            Image(systemName: "brain.head.profile")
                                .font(.system(size: 50))
                                .foregroundColor(.white)
                        }
                        .scaleEffect(animateTitle ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: animateTitle)
                        
                        Text("MemoryMaster")
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.white, .yellow.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                        
                        Text("Match the cards in the shortest time possible")
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    
                    Spacer()
                    
                    // Buttons Section
                    VStack(spacing: 20) {
                        // Play Button (Primary)
                        Button(action: { showNamePrompt = true }) {
                            HStack {
                                Image(systemName: "play.fill")
                                    .font(.title2)
                                Text("PLAY")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(
                                LinearGradient(
                                    colors: [.orange, .red],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(30)
                            .shadow(color: .red.opacity(0.4), radius: 10, x: 0, y: 5)
                        }
                        .scaleEffect(animateTitle ? 1.02 : 1.0)
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: animateTitle)
                        .padding(.horizontal, 30)
                        
                        // Secondary Buttons
                        HStack(spacing: 20) {
                            Button(action: { showScores = true }) {
                                HStack {
                                    Image(systemName: "trophy.fill")
                                    Text("Scores")
                                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.white.opacity(0.2))
                                .foregroundColor(.white)
                                .cornerRadius(25)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                            }
                            
                            Button(action: { showSettings = true }) {
                                HStack {
                                    Image(systemName: "gearshape.fill")
                                    Text("Settings")
                                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.white.opacity(0.2))
                                .foregroundColor(.white)
                                .cornerRadius(25)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                            }
                        }
                        .padding(.horizontal, 30)
                    }
                    
                    Spacer()
                }
            }
            .onAppear {
                animateTitle = true
            }
        }
        .sheet(isPresented: $showScores) {
            ScoresView()
        }
        .sheet(isPresented: $showSettings) {
            ThemeSelectionView()
        }
        .fullScreenCover(isPresented: $showGame) {
            GameView(playerName: playerName)
        }
        .alert("Enter your name", isPresented: $showNamePrompt, actions: {
            TextField("Name", text: $playerName)
            Button("Start") {
                if !playerName.trimmingCharacters(in: .whitespaces).isEmpty {
                    showGame = true
                }
            }
            Button("Cancel", role: .cancel) {}
        }, message: {
            Text("Please enter your name to start the game.")
        })
    }
}