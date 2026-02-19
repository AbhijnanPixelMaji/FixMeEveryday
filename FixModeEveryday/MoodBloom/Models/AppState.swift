import Foundation
import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var hasCompletedOnboarding: Bool = false
    @Published var userProfile: UserProfile = UserProfile()
    @Published var currentXP: Int = 0
    @Published var currentStreak: Int = 0
    @Published var bestStreak: Int = 0
    @Published var lastMoodLogDate: Date?
    @Published var moodEntries: [MoodEntry] = []
    @Published var journalEntries: [JournalEntry] = []
    @Published var completedRituals: [CompletedRitual] = []
    @Published var unlockedPlants: [Plant] = []
    @Published var currentGardenTheme: GardenTheme = .spring
    @Published var achievements: [Achievement] = []
    
    private let userDefaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    init() {
        loadData()
        setupDefaultData()
    }
    
    // MARK: - Data Persistence
    private func loadData() {
        hasCompletedOnboarding = userDefaults.bool(forKey: "hasCompletedOnboarding")
        currentXP = userDefaults.integer(forKey: "currentXP")
        currentStreak = userDefaults.integer(forKey: "currentStreak")
        bestStreak = userDefaults.integer(forKey: "bestStreak")
        
        if let lastMoodLogData = userDefaults.data(forKey: "lastMoodLogDate"),
           let date = try? decoder.decode(Date.self, from: lastMoodLogData) {
            lastMoodLogDate = date
        }
        
        if let profileData = userDefaults.data(forKey: "userProfile"),
           let profile = try? decoder.decode(UserProfile.self, from: profileData) {
            userProfile = profile
        }
        
        if let moodData = userDefaults.data(forKey: "moodEntries"),
           let moods = try? decoder.decode([MoodEntry].self, from: moodData) {
            moodEntries = moods
        }
        
        if let journalData = userDefaults.data(forKey: "journalEntries"),
           let journals = try? decoder.decode([JournalEntry].self, from: journalData) {
            journalEntries = journals
        }
        
        if let ritualsData = userDefaults.data(forKey: "completedRituals"),
           let rituals = try? decoder.decode([CompletedRitual].self, from: ritualsData) {
            completedRituals = rituals
        }
        
        if let plantsData = userDefaults.data(forKey: "unlockedPlants"),
           let plants = try? decoder.decode([Plant].self, from: plantsData) {
            unlockedPlants = plants
        }
        
        if let themeData = userDefaults.data(forKey: "currentGardenTheme"),
           let theme = try? decoder.decode(GardenTheme.self, from: themeData) {
            currentGardenTheme = theme
        }
        
        if let achievementsData = userDefaults.data(forKey: "achievements"),
           let loadedAchievements = try? decoder.decode([Achievement].self, from: achievementsData) {
            achievements = loadedAchievements
        }
    }
    
    private func saveData() {
        userDefaults.set(hasCompletedOnboarding, forKey: "hasCompletedOnboarding")
        userDefaults.set(currentXP, forKey: "currentXP")
        userDefaults.set(currentStreak, forKey: "currentStreak")
        userDefaults.set(bestStreak, forKey: "bestStreak")
        
        if let lastMoodLogDate = lastMoodLogDate,
           let dateData = try? encoder.encode(lastMoodLogDate) {
            userDefaults.set(dateData, forKey: "lastMoodLogDate")
        }
        
        if let profileData = try? encoder.encode(userProfile) {
            userDefaults.set(profileData, forKey: "userProfile")
        }
        
        if let moodData = try? encoder.encode(moodEntries) {
            userDefaults.set(moodData, forKey: "moodEntries")
        }
        
        if let journalData = try? encoder.encode(journalEntries) {
            userDefaults.set(journalData, forKey: "journalEntries")
        }
        
        if let ritualsData = try? encoder.encode(completedRituals) {
            userDefaults.set(ritualsData, forKey: "completedRituals")
        }
        
        if let plantsData = try? encoder.encode(unlockedPlants) {
            userDefaults.set(plantsData, forKey: "unlockedPlants")
        }
        
        if let themeData = try? encoder.encode(currentGardenTheme) {
            userDefaults.set(themeData, forKey: "currentGardenTheme")
        }
        
        if let achievementsData = try? encoder.encode(achievements) {
            userDefaults.set(achievementsData, forKey: "achievements")
        }
    }
    
    // MARK: - Setup Default Data
    private func setupDefaultData() {
        if unlockedPlants.isEmpty {
            unlockedPlants = createDefaultPlants()
        }
        
        if achievements.isEmpty {
            achievements = createDefaultAchievements()
        }
        
        updateStreakIfNeeded()
    }
    
    private func createDefaultPlants() -> [Plant] {
        return [
            Plant(name: "Seedling", imageName: "plant.seedling", requiredXP: 0),
            Plant(name: "Daisy", imageName: "plant.daisy", requiredXP: 50),
            Plant(name: "Sunflower", imageName: "plant.sunflower", requiredXP: 100),
            Plant(name: "Rose", imageName: "plant.rose", requiredXP: 200),
            Plant(name: "Tree", imageName: "plant.tree", requiredXP: 300),
            Plant(name: "Cherry Blossom", imageName: "plant.cherry", requiredXP: 500, isPremium: true),
            Plant(name: "Lotus", imageName: "plant.lotus", requiredXP: 750, isPremium: true),
        ]
    }
    
    private func createDefaultAchievements() -> [Achievement] {
        return [
            Achievement(title: "First Steps", description: "Log your first mood", iconName: "star.fill", requiredValue: 1, xpReward: 10, category: .moods),
            Achievement(title: "Consistency", description: "5-day mood logging streak", iconName: "flame.fill", requiredValue: 5, xpReward: 25, category: .streaks),
            Achievement(title: "Dedication", description: "10-day mood logging streak", iconName: "flame.fill", requiredValue: 10, xpReward: 50, category: .streaks),
            Achievement(title: "Champion", description: "30-day mood logging streak", iconName: "crown.fill", requiredValue: 30, xpReward: 100, category: .streaks),
            Achievement(title: "XP Novice", description: "Earn 100 XP", iconName: "bolt.fill", requiredValue: 100, xpReward: 20, category: .xp),
            Achievement(title: "XP Expert", description: "Earn 500 XP", iconName: "bolt.fill", requiredValue: 500, xpReward: 50, category: .xp),
            Achievement(title: "XP Master", description: "Earn 1000 XP", iconName: "bolt.fill", requiredValue: 1000, xpReward: 100, category: .xp),
            Achievement(title: "Reflective Soul", description: "Write 10 journal entries", iconName: "book.fill", requiredValue: 10, xpReward: 30, category: .journal),
            Achievement(title: "Ritual Beginner", description: "Complete 5 daily rituals", iconName: "sparkles", requiredValue: 5, xpReward: 25, category: .rituals),
        ]
    }
    
    // MARK: - Core Actions
    func completeOnboarding() {
        hasCompletedOnboarding = true
        saveData()
    }
    
    func logMood(_ mood: MoodLevel, note: String = "") {
        let entry = MoodEntry(mood: mood, note: note)
        moodEntries.append(entry)
        addXP(entry.xpEarned)
        updateStreak()
        checkAchievements()
        saveData()
    }
    
    func addJournalEntry(_ content: String, tags: [String] = []) {
        let entry = JournalEntry(content: content, tags: tags)
        journalEntries.append(entry)
        addXP(entry.xpEarned)
        checkAchievements()
        saveData()
    }
    
    func completeRitual(_ ritual: DailyRitual) {
        let completion = CompletedRitual(ritualId: ritual.id)
        completedRituals.append(completion)
        addXP(completion.xpEarned)
        checkAchievements()
        saveData()
    }
    
    private func addXP(_ amount: Int) {
        currentXP += amount
        unlockNewPlants()
        checkAchievements()
    }
    
    private func updateStreak() {
        let today = Calendar.current.startOfDay(for: Date())
        
        if let lastLogDate = lastMoodLogDate {
            let lastLog = Calendar.current.startOfDay(for: lastLogDate)
            let daysDifference = Calendar.current.dateComponents([.day], from: lastLog, to: today).day ?? 0
            
            if daysDifference == 1 {
                currentStreak += 1
                if currentStreak > bestStreak {
                    bestStreak = currentStreak
                }
            } else if daysDifference > 1 {
                currentStreak = 1
            }
        } else {
            currentStreak = 1
        }
        
        lastMoodLogDate = Date()
    }
    
    private func updateStreakIfNeeded() {
        guard let lastLogDate = lastMoodLogDate else { return }
        
        let today = Calendar.current.startOfDay(for: Date())
        let lastLog = Calendar.current.startOfDay(for: lastLogDate)
        let daysDifference = Calendar.current.dateComponents([.day], from: lastLog, to: today).day ?? 0
        
        if daysDifference > 1 {
            currentStreak = 0
        }
    }
    
    private func unlockNewPlants() {
        for index in unlockedPlants.indices {
            if !unlockedPlants[index].isUnlocked && currentXP >= unlockedPlants[index].requiredXP {
                unlockedPlants[index].isUnlocked = true
                unlockedPlants[index].plantedDate = Date()
            }
        }
    }
    
    private func checkAchievements() {
        let newlyUnlocked = AchievementManager.shared.checkForNewAchievements(in: self)
        // The AchievementManager already updates the achievements and adds XP
    }
    
    // MARK: - Computed Properties
    var todaysRituals: [DailyRitual] {
        // Return daily rituals based on current date
        let rituals = [
            DailyRitual(title: "Deep Breathing", description: "Take 5 deep breaths to center yourself", category: .breathing, isPremium: false),
            DailyRitual(title: "Gratitude Moment", description: "Think of three things you're grateful for", category: .gratitude, isPremium: false),
            DailyRitual(title: "Body Stretch", description: "Do gentle stretches to release tension", category: .movement, isPremium: false),
            DailyRitual(title: "Mindful Walking", description: "Take a 5-minute mindful walk", category: .mindfulness, isPremium: true),
            DailyRitual(title: "Positive Affirmation", description: "Repeat: 'I am worthy of happiness and peace'", category: .affirmation, isPremium: false)
        ]
        
        // Return one ritual per day, cycling through them
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        return [rituals[dayOfYear % rituals.count]]
    }
    
    var dailyAffirmation: String {
        let affirmations = [
            "Today I choose peace over worry.",
            "I am capable of amazing things.",
            "My mental health matters and I prioritize it.",
            "I am growing stronger every day.",
            "I deserve love, especially from myself.",
            "Today is full of possibilities.",
            "I am exactly where I need to be.",
            "My feelings are valid and temporary.",
            "I choose progress over perfection.",
            "I am worthy of happiness and joy."
        ]
        
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        return affirmations[dayOfYear % affirmations.count]
    }
    
    var hasLoggedMoodToday: Bool {
        guard let lastLogDate = lastMoodLogDate else { return false }
        return Calendar.current.isDate(lastLogDate, inSameDayAs: Date())
    }
    
    var availablePlants: [Plant] {
        return unlockedPlants.filter { $0.isUnlocked }
    }
    
    var unlockedAchievements: [Achievement] {
        return achievements.filter { $0.isUnlocked }.sorted { $0.unlockedDate ?? Date.distantPast > $1.unlockedDate ?? Date.distantPast }
    }
}