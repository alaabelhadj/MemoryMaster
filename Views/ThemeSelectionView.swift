import SwiftUI

struct ThemeSelectionView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var settings = SettingsViewModel()
    @State private var animateElements = false
    
    var body: some View {
        ZStack {
            // Background gradient identique aux autres vues
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
            ForEach(0..<8, id: \.self) { _ in
                Circle()
                    .fill(Color.white.opacity(0.06))
                    .frame(width: CGFloat.random(in: 10...25))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .animation(.easeInOut(duration: Double.random(in: 5...12)).repeatForever(autoreverses: true), value: animateElements)
            }
            
            VStack(spacing: 30) {
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                
                Text("Themes")
                    .font(.largeTitle).bold()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                ForEach(Theme.allCases, id: \.self) { theme in
                    Button(action: { settings.selectedTheme = theme }) {
                        HStack {
                            Text(theme.displayName)
                                .font(.headline)
                                .foregroundColor(.white)
                            Spacer()
                            if settings.selectedTheme == theme {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.15))
                        .cornerRadius(20)
                    }
                    .padding(.horizontal)
                }
                
                HStack {
                    Text("Sound")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    Toggle("", isOn: $settings.soundOn)
                        .labelsHidden()
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: { dismiss() }) {
                    Text("Done")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }
                .padding()
            }
        }
        .onAppear {
            animateElements = true
        }
    }
}

#Preview {
    ThemeSelectionView()
}