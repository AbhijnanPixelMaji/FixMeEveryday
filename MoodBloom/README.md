# MoodBloom 🌸

A SwiftUI iOS mental health & wellbeing companion app that helps users feel happy, calm, and refreshed every day through mood tracking, journaling, and gamified wellness activities.

## 📱 App Overview

MoodBloom combines evidence-based mental health practices with engaging gamification to create a delightful daily wellness routine.

### ✨ Key Features

- **Mood Tracking**: Simple 5-level mood logging with optional notes
- **Daily Rituals**: Science-backed micro-activities for mental wellness
- **Gamified Garden**: Visual mood garden that grows with user engagement
- **XP & Achievement System**: Points and badges for consistent self-care
- **Journal**: Reflection entries with premium tags and search
- **Insights**: Charts and AI-powered wellness pattern analysis
- **Premium Features**: Advanced analytics, rare plants, and exclusive content

## 🏗️ App Structure

### 📋 Main Tabs

1. **Today (Home)**
   - Mood logging slider with 5 emotional states
   - Daily affirmation/quote
   - Daily ritual card with completion tracking
   - Streak counter with animations
   
2. **Garden 🌱 (Gamification)**
   - Visual garden that grows with XP
   - Plant unlocking system tied to milestones
   - Achievement badges and progress tracking
   - Premium plants and themes

3. **Journal ✍️**
   - Daily reflection entries
   - Premium: Tags, search functionality, PDF export
   - Mood history integration

4. **Insights 📊**
   - Mood trend charts (7D, 30D, 90D views)
   - Statistics cards (average mood, streaks, activity)
   - Premium: AI wellness insights and pattern analysis

5. **Settings ⚙️**
   - Profile customization with avatars and colors
   - Notification preferences
   - Subscription management
   - Data export and privacy controls

### 🎮 Gamification System

- **XP Rewards**: Mood logging (+10 XP), Journal entries (+5 XP), Rituals (+15 XP)
- **Streak Tracking**: Daily consistency rewards with visual feedback
- **Plant Growth**: 7 unique plants unlock at XP milestones (0, 50, 100, 200, 300, 500, 750)
- **Achievement Categories**: Streaks, XP, Moods, Journal, Rituals
- **Premium Unlocks**: Rare plants, garden themes, advanced rituals

## 💎 Premium Features

### Free vs Premium Tiers

**Free Tier Includes:**
- Basic mood tracking and journaling
- Standard plants and achievements
- Basic insights and charts
- Core daily rituals

**Premium Tier Adds:**
- AI-powered wellness insights
- Journal tags and advanced search
- PDF export of journal entries
- Exclusive premium rituals
- Rare garden plants (Cherry Blossom, Lotus)
- Additional garden themes (Summer, Autumn, Winter, Tropical, Zen)

## 🛠️ Technical Implementation

### Framework & Requirements
- **Platform**: iOS 17.0+
- **Language**: Swift 5.9+
- **UI Framework**: SwiftUI
- **Charts**: Swift Charts framework
- **Persistence**: UserDefaults with Codable models
- **Subscriptions**: StoreKit 2
- **Architecture**: MVVM with EnvironmentObjects

### Project Structure
```
MoodBloom/
├── MoodBloomApp.swift              # App entry point
├── ContentView.swift               # Root view coordinator
├── Models/
│   ├── Models.swift                # Core data models
│   ├── AppState.swift              # Main app state management
│   └── SubscriptionManager.swift   # In-app purchase handling
├── Views/
│   ├── MainTabView.swift           # Tab bar coordinator
│   ├── Onboarding/
│   ├── Today/
│   ├── Garden/
│   ├── Journal/
│   ├── Insights/
│   └── Settings/
└── Utils/
    └── AchievementManager.swift    # Achievement logic
```

### Data Models

#### Core Models
- `MoodLevel`: 5-level emotional state enum
- `MoodEntry`: Daily mood logs with notes
- `JournalEntry`: Reflection entries with tags
- `DailyRitual`: Wellness activities
- `Achievement`: Badge system
- `Plant`: Garden growth system
- `UserProfile`: User customization

#### State Management
- `AppState`: Central observable data store
- `SubscriptionManager`: Premium feature management
- Persistent storage via UserDefaults with JSON encoding

## 🎨 Design Philosophy

### Visual Design
- **Soft Gradients**: Calming color palette with blue/purple/green tones
- **Rounded Cards**: Modern, approachable UI elements
- **Smooth Animations**: Spring-based transitions for user delight
- **Haptic Feedback**: Physical interaction feedback
- **SF Symbols**: Native iOS iconography

### User Experience
- **Progressive Onboarding**: 4-screen introduction flow
- **Micro-Interactions**: Reward feedback for every action
- **Visual Progress**: Charts, progress bars, and growth animations
- **Accessibility**: VoiceOver support and large text compatibility

## 📊 Analytics & Insights

### Data Tracking
- Mood patterns over time (weekly/monthly trends)
- Streak analysis and consistency metrics
- Activity completion rates
- XP accumulation and milestone progress

### Premium AI Insights (Placeholder)
- "Your mood tends to be higher on weekends"
- "Consistent journaling correlates with better mood"
- "Midweek stress patterns detected"

## 🔒 Privacy & Security

### Data Handling
- All personal data stored locally on device
- Encrypted cloud backup for premium users
- No sensitive data sharing with third parties
- GDPR-compliant data export and deletion

### Permissions
- Local notifications for daily reminders (optional)
- No camera, location, or contact access required

## 🚀 Getting Started

### Prerequisites
- Xcode 15.0+
- iOS 17.0+ target device/simulator
- Apple Developer account for StoreKit testing

### Installation
1. Clone/download the project files
2. Open `MoodBloom.xcodeproj` in Xcode
3. Configure your development team in project settings
4. Build and run on simulator or device

### StoreKit Configuration
1. Set up subscription products in App Store Connect:
   - `moodbloom_premium_monthly` ($4.99/month)
   - `moodbloom_premium_yearly` ($39.99/year)
2. Configure StoreKit testing in Xcode for development

## 📱 App Store Information

### App Store Description
"Transform your daily wellness routine with MoodBloom - the beautiful, gamified mental health companion that makes self-care fun and rewarding. Track your mood, grow a digital garden, and discover insights about your emotional patterns through science-backed activities."

### Keywords
Mental health, mood tracker, wellness, self-care, journaling, meditation, mindfulness, habit tracker, psychology, emotional wellbeing

### Target Categories
- Primary: Health & Fitness
- Secondary: Lifestyle

## 🔄 Future Enhancements

### Planned Features
- Apple HealthKit integration
- Widget support for Today view
- Siri Shortcuts for quick mood logging
- Social sharing of garden achievements
- Guided meditation integration
- Advanced AI insights with OpenAI integration
- Apple Watch companion app

### Monetization Strategy
- Freemium model with generous free tier
- $4.99/month or $39.99/year premium subscription
- Focus on value-driven premium features
- No ads or data selling

## 🤝 Development Notes

### Code Quality
- SwiftUI best practices with proper state management
- Modular view architecture for maintainability
- Comprehensive error handling
- Memory-efficient data persistence
- Smooth 60fps animations throughout

### Testing Strategy
- Unit tests for data models and business logic
- UI tests for critical user flows
- StoreKit sandbox testing for subscriptions
- Accessibility testing with VoiceOver

### Performance
- Lazy loading for large data sets
- Efficient Core Data queries
- Optimized image rendering
- Battery-conscious background processing

## 📄 License

This project is created as a demonstration of SwiftUI app development. All code is provided for educational purposes.

---

**MoodBloom** - *Nurture your mental wellness, one day at a time* 🌸