import Foundation
import SwiftUI

// MARK: - Mood System
enum MoodLevel: Int, CaseIterable, Codable {
    case verySad = 1
    case sad = 2
    case neutral = 3
    case happy = 4
    case veryHappy = 5
    
    var emoji: String {
        switch self {
        case .verySad: return "😢"
        case .sad: return "😔"
        case .neutral: return "😐"
        case .happy: return "😊"
        case .veryHappy: return "😄"
        }
    }
    
    var label: String {
        switch self {
        case .verySad: return "Very Sad"
        case .sad: return "Sad"
        case .neutral: return "Neutral"
        case .happy: return "Happy"
        case .veryHappy: return "Very Happy"
        }
    }
    
    var color: Color {
        switch self {
        case .verySad: return .red
        case .sad: return .orange
        case .neutral: return .gray
        case .happy: return .blue
        case .veryHappy: return .green
        }
    }
}

struct MoodEntry: Identifiable, Codable {
    let id = UUID()
    let date: Date
    let mood: MoodLevel
    let note: String
    let xpEarned: Int
    
    init(mood: MoodLevel, note: String = "", xpEarned: Int = 10) {
        self.date = Date()
        self.mood = mood
        self.note = note
        self.xpEarned = xpEarned
    }
}

// MARK: - Journal System
struct JournalEntry: Identifiable, Codable {
    let id = UUID()
    let date: Date
    let content: String
    let tags: [String]
    let xpEarned: Int
    
    init(content: String, tags: [String] = [], xpEarned: Int = 5) {
        self.date = Date()
        self.content = content
        self.tags = tags
        self.xpEarned = xpEarned
    }
}

// MARK: - Ritual System
struct DailyRitual: Identifiable, Codable {
    let id = UUID()
    let title: String
    let description: String
    let category: RitualCategory
    let isPremium: Bool
    
    enum RitualCategory: String, CaseIterable, Codable {
        case breathing = "Breathing"
        case gratitude = "Gratitude"
        case movement = "Movement"
        case mindfulness = "Mindfulness"
        case affirmation = "Affirmation"
    }
}

struct CompletedRitual: Identifiable, Codable {
    let id = UUID()
    let ritualId: UUID
    let date: Date
    let xpEarned: Int
    
    init(ritualId: UUID, xpEarned: Int = 15) {
        self.ritualId = ritualId
        self.date = Date()
        self.xpEarned = xpEarned
    }
}

// MARK: - Garden System
struct Plant: Identifiable, Codable {
    let id = UUID()
    let name: String
    let imageName: String
    let requiredXP: Int
    let isPremium: Bool
    var isUnlocked: Bool
    var plantedDate: Date?
    
    init(name: String, imageName: String, requiredXP: Int, isPremium: Bool = false) {
        self.name = name
        self.imageName = imageName
        self.requiredXP = requiredXP
        self.isPremium = isPremium
        self.isUnlocked = requiredXP == 0
        self.plantedDate = nil
    }
}

enum GardenTheme: String, CaseIterable, Codable {
    case spring = "Spring"
    case summer = "Summer"
    case autumn = "Autumn"
    case winter = "Winter"
    case tropical = "Tropical"
    case zen = "Zen"
    
    var isPremium: Bool {
        switch self {
        case .spring: return false
        case .summer, .autumn, .winter, .tropical, .zen: return true
        }
    }
}

// MARK: - Achievement System
struct Achievement: Identifiable, Codable {
    let id = UUID()
    let title: String
    let description: String
    let iconName: String
    let requiredValue: Int
    let xpReward: Int
    let category: AchievementCategory
    var isUnlocked: Bool
    var unlockedDate: Date?
    
    enum AchievementCategory: String, CaseIterable, Codable {
        case streaks = "Streaks"
        case xp = "XP"
        case moods = "Moods"
        case journal = "Journal"
        case rituals = "Rituals"
    }
    
    init(title: String, description: String, iconName: String, requiredValue: Int, xpReward: Int, category: AchievementCategory) {
        self.title = title
        self.description = description
        self.iconName = iconName
        self.requiredValue = requiredValue
        self.xpReward = xpReward
        self.category = category
        self.isUnlocked = false
        self.unlockedDate = nil
    }
}

// MARK: - User Profile
struct UserProfile: Codable {
    var name: String
    var avatar: String
    var joinDate: Date
    var favoriteColor: Color
    var notificationsEnabled: Bool
    var reminderTime: Date
    
    init() {
        self.name = ""
        self.avatar = "person.circle.fill"
        self.joinDate = Date()
        self.favoriteColor = .blue
        self.notificationsEnabled = true
        self.reminderTime = Calendar.current.date(bySettingHour: 19, minute: 0, second: 0, of: Date()) ?? Date()
    }
}

extension Color: Codable {
    enum CodingKeys: String, CodingKey {
        case red, green, blue, alpha
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let red = try container.decode(Double.self, forKey: .red)
        let green = try container.decode(Double.self, forKey: .green)
        let blue = try container.decode(Double.self, forKey: .blue)
        let alpha = try container.decode(Double.self, forKey: .alpha)
        self = Color(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
    
    public func encode(to encoder: Encoder) throws {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Double(red), forKey: .red)
        try container.encode(Double(green), forKey: .green)
        try container.encode(Double(blue), forKey: .blue)
        try container.encode(Double(alpha), forKey: .alpha)
    }
}