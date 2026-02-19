import SwiftUI

struct TodayView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedMood: MoodLevel = .neutral
    @State private var moodNote = ""
    @State private var showMoodLogger = false
    @State private var showAchievementAlert = false
    @State private var newAchievement: Achievement?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    headerView
                    streakCard
                    moodSection
                    dailyRitualSection
                    affirmationCard
                    Spacer(minLength: 100)
                }
                .padding()
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.05), Color.purple.opacity(0.05)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .navigationTitle("Today")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showMoodLogger) {
            MoodLoggerSheet(selectedMood: $selectedMood, moodNote: $moodNote) { mood, note in
                logMood(mood, note: note)
            }
        }
        .alert("Achievement Unlocked! 🎉", isPresented: $showAchievementAlert) {
            Button("Awesome!") { }
        } message: {
            if let achievement = newAchievement {
                Text("\(achievement.title)\n\(achievement.description)\n+\(achievement.xpReward) XP")
            }
        }
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Hello, \(appState.userProfile.name.isEmpty ? "Friend" : appState.userProfile.name)!")
                        .font(.title2)
                        .fontWeight(.medium)
                    
                    Text("How are you feeling today?")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack {
                    Text("\(appState.currentXP)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    Text("XP")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(12)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
            }
        }
    }
    
    private var streakCard: some View {
        HStack {
            Image(systemName: "flame.fill")
                .font(.title2)
                .foregroundColor(.orange)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Current Streak")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("\(appState.currentStreak) days")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            Spacer()
            
            if appState.bestStreak > 0 {
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Best Streak")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("\(appState.bestStreak) days")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)
                }
            }
        }
        .padding()
        .background(Color.orange.opacity(0.05))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.orange.opacity(0.2), lineWidth: 1)
        )
    }
    
    private var moodSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "heart.fill")
                    .foregroundColor(.pink)
                Text("Mood Check-in")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                if appState.hasLoggedMoodToday {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title3)
                }
            }
            
            if appState.hasLoggedMoodToday {
                HStack {
                    if let todaysMood = appState.moodEntries.last {
                        Text(todaysMood.mood.emoji)
                            .font(.system(size: 40))
                        
                        VStack(alignment: .leading) {
                            Text("Today's Mood: \(todaysMood.mood.label)")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            if !todaysMood.note.isEmpty {
                                Text(todaysMood.note)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .lineLimit(2)
                            }
                        }
                        
                        Spacer()
                    }
                }
                .padding()
                .background(Color.green.opacity(0.05))
                .cornerRadius(12)
            } else {
                Button(action: {
                    showMoodLogger = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                        
                        Text("Log Your Mood")
                            .font(.headline)
                        
                        Spacer()
                        
                        Text("+10 XP")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(8)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.pink, .purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                    .shadow(color: .pink.opacity(0.3), radius: 10, x: 0, y: 5)
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    private var dailyRitualSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(.blue)
                Text("Daily Ritual")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            
            if let ritual = appState.todaysRituals.first {
                DailyRitualCard(ritual: ritual)
            }
        }
        .padding(.vertical, 8)
    }
    
    private var affirmationCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "quote.bubble.fill")
                    .foregroundColor(.green)
                Text("Today's Affirmation")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            
            Text(appState.dailyAffirmation)
                .font(.title3)
                .fontWeight(.medium)
                .multilineTextAlignment(.leading)
                .padding()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.green.opacity(0.1), Color.blue.opacity(0.1)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.green.opacity(0.2), lineWidth: 1)
                )
        }
        .padding(.vertical, 8)
    }
    
    private func logMood(_ mood: MoodLevel, note: String) {
        let unlockedBefore = appState.unlockedAchievements.count
        appState.logMood(mood, note: note)
        
        let unlockedAfter = appState.unlockedAchievements.count
        if unlockedAfter > unlockedBefore {
            newAchievement = appState.unlockedAchievements.first
            showAchievementAlert = true
        }
        
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
}

struct DailyRitualCard: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    let ritual: DailyRitual
    @State private var isCompleted = false
    @State private var showPremiumAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(ritual.title)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        if ritual.isPremium {
                            Text("PREMIUM")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.orange)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.orange.opacity(0.2))
                                .cornerRadius(4)
                        }
                    }
                    
                    Text(ritual.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                } else {
                    Button(action: completeRitual) {
                        HStack(spacing: 4) {
                            Image(systemName: "plus.circle")
                                .font(.subheadline)
                            Text("+15 XP")
                                .font(.caption)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.blue)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                    }
                }
            }
        }
        .padding()
        .background(Color.blue.opacity(0.05))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.blue.opacity(0.2), lineWidth: 1)
        )
        .onAppear {
            checkIfCompleted()
        }
        .alert("Premium Feature", isPresented: $showPremiumAlert) {
            Button("Upgrade") {
                // Navigate to premium screen
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This ritual requires a premium subscription to access.")
        }
    }
    
    private func completeRitual() {
        if ritual.isPremium && !subscriptionManager.isPremium {
            showPremiumAlert = true
            return
        }
        
        appState.completeRitual(ritual)
        isCompleted = true
        
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    private func checkIfCompleted() {
        let today = Calendar.current.startOfDay(for: Date())
        isCompleted = appState.completedRituals.contains { completion in
            Calendar.current.isDate(completion.date, inSameDayAs: today) && completion.ritualId == ritual.id
        }
    }
}

#Preview {
    TodayView()
        .environmentObject(AppState())
        .environmentObject(SubscriptionManager())
}