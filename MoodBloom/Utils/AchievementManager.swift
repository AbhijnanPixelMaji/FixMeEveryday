import Foundation
import SwiftUI

class AchievementManager: ObservableObject {
    @Published var newlyUnlockedAchievements: [Achievement] = []
    
    static let shared = AchievementManager()
    
    private init() {}
    
    func checkForNewAchievements(in appState: AppState) -> [Achievement] {
        var newlyUnlocked: [Achievement] = []
        
        for index in appState.achievements.indices {
            let achievement = appState.achievements[index]
            
            if !achievement.isUnlocked && shouldUnlockAchievement(achievement, with: appState) {
                appState.achievements[index].isUnlocked = true
                appState.achievements[index].unlockedDate = Date()
                newlyUnlocked.append(appState.achievements[index])
                
                // Add XP reward
                appState.currentXP += achievement.xpReward
            }
        }
        
        return newlyUnlocked
    }
    
    private func shouldUnlockAchievement(_ achievement: Achievement, with appState: AppState) -> Bool {
        switch achievement.category {
        case .moods:
            return appState.moodEntries.count >= achievement.requiredValue
        case .streaks:
            return appState.currentStreak >= achievement.requiredValue || appState.bestStreak >= achievement.requiredValue
        case .xp:
            return appState.currentXP >= achievement.requiredValue
        case .journal:
            return appState.journalEntries.count >= achievement.requiredValue
        case .rituals:
            return appState.completedRituals.count >= achievement.requiredValue
        }
    }
    
    func getCurrentProgress(for achievement: Achievement, with appState: AppState) -> Int {
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
    
    func getProgressPercentage(for achievement: Achievement, with appState: AppState) -> Double {
        let current = Double(getCurrentProgress(for: achievement, with: appState))
        let required = Double(achievement.requiredValue)
        return min(1.0, current / required)
    }
}