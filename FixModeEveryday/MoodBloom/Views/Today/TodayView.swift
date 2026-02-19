import SwiftUI

struct TodayView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var themeManager: ThemeManager
    @State private var selectedMood: MoodLevel = .neutral
    @State private var moodNote = ""
    @State private var showMoodLogger = false
    @State private var showAchievementAlert = false
    @State private var newAchievement: Achievement?
    @State private var animateEntrance = false
    @State private var pulseAnimation = false
    @State private var sparkleAnimation = false
    @State private var cardHoverStates: [Int: Bool] = [:]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 24) {
                    headerView
                        .opacity(animateEntrance ? 1 : 0)
                        .offset(y: animateEntrance ? 0 : -20)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: animateEntrance)
                    
                    streakCard
                        .opacity(animateEntrance ? 1 : 0)
                        .offset(y: animateEntrance ? 0 : -20)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: animateEntrance)
                    
                    moodSection
                        .opacity(animateEntrance ? 1 : 0)
                        .offset(y: animateEntrance ? 0 : -20)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: animateEntrance)
                    
                    dailyRitualSection
                        .opacity(animateEntrance ? 1 : 0)
                        .offset(y: animateEntrance ? 0 : -20)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: animateEntrance)
                    
                    affirmationCard
                        .opacity(animateEntrance ? 1 : 0)
                        .offset(y: animateEntrance ? 0 : -20)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: animateEntrance)
                    
                    quickStatsSection
                        .opacity(animateEntrance ? 1 : 0)
                        .offset(y: animateEntrance ? 0 : -20)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.6), value: animateEntrance)
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
            .background(AppColors.backgroundGradient(isDark: themeManager.isDarkMode))
            .navigationTitle("Today")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                withAnimation {
                    animateEntrance = true
                }
                startContinuousAnimations()
            }
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
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Hello, \(appState.userProfile.name.isEmpty ? "Friend" : appState.userProfile.name)!")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        if sparkleAnimation {
                            Image(systemName: "sparkles")
                                .foregroundColor(.yellow)
                                .scaleEffect(sparkleAnimation ? 1.2 : 0.8)
                                .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: sparkleAnimation)
                        }
                    }
                    
                    Text("Ready to bloom today? 🌸")
                        .font(.subheadline)
                        .foregroundColor(AppColors.secondary(isDark: themeManager.isDarkMode))
                        .italic()
                }
                
                Spacer()
                
                gamifiedXPBadge
            }
            
            // Daily Progress Ring
            dailyProgressRing
        }
        .padding(.vertical, 8)
    }
    
    private var gamifiedXPBadge: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: "bolt.fill")
                    .foregroundColor(.yellow)
                    .scaleEffect(pulseAnimation ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: pulseAnimation)
                
                Text("\(appState.currentXP)",)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            Text("XP")
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(.white.opacity(0.9))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            LinearGradient(
                colors: [.blue, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
        .shadow(color: .blue.opacity(0.4), radius: 8, x: 0, y: 4)
        .scaleEffect(cardHoverStates[0] == true ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: cardHoverStates[0])
    }
    
    private var dailyProgressRing: some View {
        HStack(spacing: 20) {
            // Mood Progress
            CircularProgressView(
                progress: appState.hasLoggedMoodToday ? 1.0 : 0.0,
                title: "Mood",
                icon: "heart.fill",
                color: .pink,
                isCompleted: appState.hasLoggedMoodToday
            )
            
            // Ritual Progress
            CircularProgressView(
                progress: todayRitualsCompleted > 0 ? 1.0 : 0.0,
                title: "Ritual",
                icon: "sparkles",
                color: .orange,
                isCompleted: todayRitualsCompleted > 0
            )
            
            // Journal Progress
            CircularProgressView(
                progress: hasjournalledToday ? 1.0 : 0.0,
                title: "Journal",
                icon: "book.fill",
                color: .green,
                isCompleted: hasjournalledToday
            )
            
            Spacer()
            
            // Daily Completion Badge
            if dailyTasksCompleted >= 2 {
                VStack(spacing: 4) {
                    Image(systemName: "crown.fill")
                        .foregroundColor(Color.gold)
                        .font(.title2)
                        .scaleEffect(sparkleAnimation ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: sparkleAnimation)
                    
                    Text("Great day!")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.gold)
                }
            }
        }
        .padding(.horizontal)
    }
    
    private var streakCard: some View {
        HStack(spacing: 16) {
            // Streak Fire Animation
            VStack(spacing: 8) {
                ZStack {
                    // Fire glow effect
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [.orange.opacity(0.6), .red.opacity(0.3), .clear],
                                center: .center,
                                startRadius: 0,
                                endRadius: 25
                            )
                        )
                        .frame(width: 50, height: 50)
                        .scaleEffect(pulseAnimation ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: pulseAnimation)
                    
                    Image(systemName: "flame.fill")
                        .font(.title)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.orange, .red],
                                startPoint: .bottom,
                                endPoint: .top
                            )
                        )
                        .scaleEffect(appState.currentStreak > 0 ? 1.0 : 0.7)
                        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: appState.currentStreak)
                }
                
                Text("\(appState.currentStreak)")
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.orange, .red],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Daily Streak 🔥")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text(streakMessage)
                    .font(.subheadline)
                    .foregroundColor(AppColors.secondary(isDark: themeManager.isDarkMode))
                    .lineLimit(2)
            }
            
            Spacer()
            
            // Best streak badge
            if appState.bestStreak > 0 {
                VStack(spacing: 4) {
                    Image(systemName: "crown.fill")
                        .foregroundColor(Color.gold)
                        .font(.title3)
                    
                    Text("\(appState.bestStreak)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.gold)
                    
                    Text("Best")
                        .font(.caption2)
                        .foregroundColor(Color.gold)
                }
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gold.opacity(0.1))
                        .stroke(Color.gold.opacity(0.3), lineWidth: 1)
                )
            }
        }
        .padding(20)
        .adaptiveCardStyle(color: .orange, isDark: themeManager.isDarkMode)
        .scaleEffect(cardHoverStates[1] == true ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: cardHoverStates[1])
    }
    
    private var moodSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "heart.fill")
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.pink, .red],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .font(.title2)
                    .scaleEffect(pulseAnimation ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: pulseAnimation)
                
                Text("Mood Check-in 💭")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                if appState.hasLoggedMoodToday {
                    ZStack {
                        Circle()
                            .fill(.green.opacity(0.2))
                            .frame(width: 30, height: 30)
                        
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.title3)
                    }
                    .scaleEffect(sparkleAnimation ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: sparkleAnimation)
                }
            }
            
            if appState.hasLoggedMoodToday {
                // Completed mood display
                HStack(spacing: 16) {
                    if let todaysMood = appState.moodEntries.last {
                        // Large mood emoji with glow
                        ZStack {
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [todaysMood.mood.color.opacity(0.3), .clear],
                                        center: .center,
                                        startRadius: 0,
                                        endRadius: 40
                                    )
                                )
                                .frame(width: 80, height: 80)
                                .scaleEffect(pulseAnimation ? 1.1 : 1.0)
                                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: pulseAnimation)
                            
                            Text(todaysMood.mood.emoji)
                                .font(.system(size: 45))
                                .scaleEffect(sparkleAnimation ? 1.05 : 1.0)
                                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: sparkleAnimation)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Feeling \(todaysMood.mood.label)")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(todaysMood.mood.color)
                                
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                    .scaleEffect(sparkleAnimation ? 1.2 : 0.8)
                                    .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: sparkleAnimation)
                            }
                            
                            if !todaysMood.note.isEmpty {
                                Text(todaysMood.note)
                                    .font(.subheadline)
                                    .foregroundColor(AppColors.secondary(isDark: themeManager.isDarkMode))
                                    .lineLimit(3)
                                    .italic()
                            }
                            
                            // XP earned badge
                            HStack(spacing: 4) {
                                Image(systemName: "bolt.fill")
                                    .foregroundColor(.yellow)
                                Text("+\(todaysMood.xpEarned) XP earned")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.blue)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.green.opacity(0.1))
                            .cornerRadius(8)
                        }
                        
                        Spacer()
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [.green.opacity(0.1), .mint.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.green.opacity(0.3), lineWidth: 2)
                )
                .shadow(color: .green.opacity(0.2), radius: 8, x: 0, y: 4)
            } else {
                // Mood logging button
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                        showMoodLogger = true
                    }
                }) {
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(.white.opacity(0.2))
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Log Your Mood")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("How are you feeling right now?")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        Spacer()
                        
                        VStack(spacing: 4) {
                            HStack(spacing: 4) {
                                Image(systemName: "bolt.fill")
                                    .foregroundColor(.yellow)
                                    .font(.caption)
                                
                                Text("10 XP")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(.white.opacity(0.2))
                            .cornerRadius(12)
                            
                            Image(systemName: "arrow.right")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.caption)
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    colors: [.pink, .purple, .blue],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                    .shadow(color: .purple.opacity(0.4), radius: 15, x: 0, y: 8)
                }
                .scaleEffect(cardHoverStates[2] == true ? 1.02 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: cardHoverStates[2])
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
    
    // MARK: - Helper Methods and Computed Properties
    
    private func startContinuousAnimations() {
        withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
            pulseAnimation = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                sparkleAnimation = true
            }
        }
    }
    
    
    private var quickStatsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today's Progress 📈")
                .font(.headline)
                .fontWeight(.bold)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                QuickStatCard(
                    title: "Total XP",
                    value: "\(appState.currentXP)",
                    icon: "bolt.fill",
                    color: .blue,
                    isHighlighted: true
                )
                
                QuickStatCard(
                    title: "Streak",
                    value: "\(appState.currentStreak)",
                    icon: "flame.fill",
                    color: .orange
                )
                
                QuickStatCard(
                    title: "Moods Logged",
                    value: "\(appState.moodEntries.count)",
                    icon: "heart.fill",
                    color: .pink
                )
                
                QuickStatCard(
                    title: "Journal Entries",
                    value: "\(appState.journalEntries.count)",
                    icon: "book.fill",
                    color: .green
                )
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var streakMessage: String {
        switch appState.currentStreak {
        case 0:
            return "Start your wellness journey today!"
        case 1:
            return "Great start! Keep it going tomorrow."
        case 2...4:
            return "Building momentum! You're doing amazing."
        case 5...9:
            return "Incredible consistency! You're on fire!"
        case 10...19:
            return "Unstoppable! You're a wellness champion."
        default:
            return "Legendary streak! You're inspiring!"
        }
    }
    
    private var todayRitualsCompleted: Int {
        let today = Calendar.current.startOfDay(for: Date())
        return appState.completedRituals.filter { completion in
            Calendar.current.isDate(completion.date, inSameDayAs: today)
        }.count
    }
    
    private var hasjournalledToday: Bool {
        let today = Calendar.current.startOfDay(for: Date())
        return appState.journalEntries.contains { entry in
            Calendar.current.isDate(entry.date, inSameDayAs: today)
        }
    }
    
    private var dailyTasksCompleted: Int {
        var completed = 0
        if appState.hasLoggedMoodToday { completed += 1 }
        if todayRitualsCompleted > 0 { completed += 1 }
        if hasjournalledToday { completed += 1 }
        return completed
    }
}

// MARK: - Supporting Views

struct CircularProgressView: View {
    let progress: Double
    let title: String
    let icon: String
    let color: Color
    let isCompleted: Bool
    
    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .stroke(color.opacity(0.2), lineWidth: 3)
                    .frame(width: 40, height: 40)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        LinearGradient(
                            colors: [color, color.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 3, lineCap: .round)
                    )
                    .frame(width: 40, height: 40)
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 1.0, dampingFraction: 0.8), value: progress)
                
                if isCompleted {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(color)
                } else {
                    Image(systemName: icon)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(color.opacity(0.6))
                }
            }
            
            Text(title)
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(isCompleted ? color : Color.secondary)
        }
    }
}

struct QuickStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let isHighlighted: Bool
    
    init(title: String, value: String, icon: String, color: Color, isHighlighted: Bool = false) {
        self.title = title
        self.value = value
        self.icon = icon
        self.color = color
        self.isHighlighted = isHighlighted
    }
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title3)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(isHighlighted ? color : .primary)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(Color.secondary)
            }
            
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(color.opacity(isHighlighted ? 0.3 : 0.1), lineWidth: isHighlighted ? 2 : 1)
        )
    }
}

// MARK: - Extensions

extension Color {
    static let gold = Color(red: 1.0, green: 0.84, blue: 0.0)
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
