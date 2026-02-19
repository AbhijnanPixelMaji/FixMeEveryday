import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentPage = 0
    
    var body: some View {
        TabView(selection: $currentPage) {
            OnboardingPage1()
                .tag(0)
            OnboardingPage2()
                .tag(1)
            OnboardingPage3()
                .tag(2)
            OnboardingPage4()
                .tag(3)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

struct OnboardingPage1: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "heart.fill")
                .font(.system(size: 80))
                .foregroundColor(.pink)
                .background(
                    Circle()
                        .fill(.pink.opacity(0.1))
                        .frame(width: 120, height: 120)
                )
            
            VStack(spacing: 16) {
                Text("Welcome to MoodBloom")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text("Your personal mental health companion that helps you feel happy, calm, and refreshed every day.")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Spacer()
            Spacer()
        }
        .padding()
    }
}

struct OnboardingPage2: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 80))
                .foregroundColor(.blue)
                .background(
                    Circle()
                        .fill(.blue.opacity(0.1))
                        .frame(width: 120, height: 120)
                )
            
            VStack(spacing: 16) {
                Text("Track Your Mood")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text("Log how you're feeling each day with our simple mood tracker. Watch your patterns emerge over time.")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Spacer()
            Spacer()
        }
        .padding()
    }
}

struct OnboardingPage3: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "leaf.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)
                .background(
                    Circle()
                        .fill(.green.opacity(0.1))
                        .frame(width: 120, height: 120)
                )
            
            VStack(spacing: 16) {
                Text("Grow Your Garden")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text("Complete daily rituals and log your moods to earn XP. Watch your beautiful garden bloom as you take care of yourself.")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Spacer()
            Spacer()
        }
        .padding()
    }
}

struct OnboardingPage4: View {
    @EnvironmentObject var appState: AppState
    @State private var name = ""
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "sparkles")
                .font(.system(size: 80))
                .foregroundColor(.orange)
                .background(
                    Circle()
                        .fill(.orange.opacity(0.1))
                        .frame(width: 120, height: 120)
                )
            
            VStack(spacing: 16) {
                Text("Let's Get Started!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text("What should we call you?")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            TextField("Enter your name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 40)
                .font(.title3)
            
            Button(action: {
                appState.userProfile.name = name.isEmpty ? "Friend" : name
                appState.completeOnboarding()
            }) {
                Text("Start My Journey")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(15)
                    .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            .padding(.horizontal, 40)
            
            Spacer()
            Spacer()
        }
        .padding()
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AppState())
        .environmentObject(SubscriptionManager())
}