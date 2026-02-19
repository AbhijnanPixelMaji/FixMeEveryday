import SwiftUI

struct AchievementsView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var selectedCategory: Achievement.AchievementCategory = .streaks
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                categoryPicker
                achievementsList
            }
            .navigationTitle("Achievements")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var categoryPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(Achievement.AchievementCategory.allCases, id: \.self) { category in
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            selectedCategory = category
                        }
                    }) {
                        Text(category.rawValue)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                selectedCategory == category
                                    ? Color.blue
                                    : Color.blue.opacity(0.1)
                            )
                            .foregroundColor(
                                selectedCategory == category
                                    ? .white
                                    : .blue
                            )
                            .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
        .background(Color(.systemBackground))
    }
    
    private var achievementsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredAchievements) { achievement in
                    AchievementRowView(achievement: achievement, isExpanded: true)
                }
            }
            .padding()
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.orange.opacity(0.05), Color.yellow.opacity(0.1)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
    
    private var filteredAchievements: [Achievement] {
        appState.achievements
            .filter { $0.category == selectedCategory }
            .sorted { achievement1, achievement2 in
                if achievement1.isUnlocked != achievement2.isUnlocked {
                    return achievement1.isUnlocked && !achievement2.isUnlocked
                }
                return achievement1.requiredValue < achievement2.requiredValue
            }
    }
}

struct AchievementRowView: View {
    let achievement: Achievement
    var isExpanded: Bool = false
    
    var body: some View {
        HStack(spacing: 16) {
            achievementIcon
            achievementInfo
            
            if achievement.isUnlocked {
                unlockedBadge
            } else {
                progressView
            }
        }
        .padding()
        .background(
            achievement.isUnlocked
                ? Color.orange.opacity(0.1)
                : Color.gray.opacity(0.05)
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    achievement.isUnlocked
                        ? Color.orange.opacity(0.3)
                        : Color.gray.opacity(0.2),
                    lineWidth: 1
                )
        )
        .opacity(achievement.isUnlocked ? 1.0 : 0.7)
    }
    
    private var achievementIcon: some View {
        Image(systemName: achievement.iconName)
            .font(.system(size: 24))
            .foregroundColor(achievement.isUnlocked ? .orange : .gray)
            .frame(width: 40, height: 40)
            .background(
                Circle()
                    .fill(
                        achievement.isUnlocked
                            ? Color.orange.opacity(0.2)
                            : Color.gray.opacity(0.1)
                    )
            )
    }
    
    private var achievementInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(achievement.title)
                .font(isExpanded ? .headline : .subheadline)
                .fontWeight(.semibold)
                .foregroundColor(achievement.isUnlocked ? .primary : .secondary)
            
            Text(achievement.description)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(isExpanded ? nil : 1)
            
            if achievement.isUnlocked, let unlockedDate = achievement.unlockedDate {
                Text("Unlocked \(unlockedDate, formatter: relativeDateFormatter)")
                    .font(.caption2)
                    .foregroundColor(.orange)
            }
        }
    }
    
    @ViewBuilder
    private var unlockedBadge: some View {
        VStack(spacing: 4) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.title3)
            
            Text("+\(achievement.xpReward) XP")
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(.blue)
        }
    }
    
    @ViewBuilder
    private var progressView: some View {
        VStack(alignment: .trailing, spacing: 4) {
            Text("\(currentProgress)/\(achievement.requiredValue)")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.blue)
            
            ProgressView(value: Double(currentProgress), total: Double(achievement.requiredValue))
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                .frame(width: 60)
                .scaleEffect(x: 1, y: 2)
        }
    }
    
    private var currentProgress: Int {
        guard let appState = getAppState() else { return 0 }
        
        switch achievement.category {
        case .moods:
            return appState.moodEntries.count
        case .streaks:
            return max(appState.currentStreak, appState.bestStreak)
        case .xp:
            return appState.currentXP
        case .journal:
            return appState.journalEntries.count
        case .rituals:
            return appState.completedRituals.count
        }
    }
    
    @EnvironmentObject private var appState: AppState
    
    private func getAppState() -> AppState? {
        return appState
    }
}

private let relativeDateFormatter: RelativeDateTimeFormatter = {
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .abbreviated
    return formatter
}()

#Preview {
    AchievementsView()
        .environmentObject(AppState())
}