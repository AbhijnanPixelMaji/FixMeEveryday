import SwiftUI
import Combine

class ThemeManager: ObservableObject {
    @Published var currentTheme: AppTheme = .system
    @Published var isDarkMode: Bool = false
    
    private let userDefaults = UserDefaults.standard
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadThemePreference()
        setupSystemThemeObserver()
    }
    
    private func loadThemePreference() {
        if let themeRawValue = userDefaults.string(forKey: "selectedTheme"),
           let theme = AppTheme(rawValue: themeRawValue) {
            currentTheme = theme
        }
        updateIsDarkMode()
    }
    
    private func setupSystemThemeObserver() {
        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { [weak self] _ in
                self?.updateIsDarkMode()
            }
            .store(in: &cancellables)
    }
    
    func setTheme(_ theme: AppTheme) {
        currentTheme = theme
        userDefaults.set(theme.rawValue, forKey: "selectedTheme")
        updateIsDarkMode()
        
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
    
    private func updateIsDarkMode() {
        switch currentTheme {
        case .light:
            isDarkMode = false
        case .dark:
            isDarkMode = true
        case .system:
            isDarkMode = UITraitCollection.current.userInterfaceStyle == .dark
        }
    }
}

enum AppTheme: String, CaseIterable {
    case light = "light"
    case dark = "dark"
    case system = "system"
    
    var displayName: String {
        switch self {
        case .light: return "Light"
        case .dark: return "Dark" 
        case .system: return "System"
        }
    }
    
    var icon: String {
        switch self {
        case .light: return "sun.max.fill"
        case .dark: return "moon.fill"
        case .system: return "gear"
        }
    }
}

// MARK: - Theme Colors and Styles

struct AppColors {
    static func primary(isDark: Bool) -> Color {
        isDark ? .white : .black
    }
    
    static func secondary(isDark: Bool) -> Color {
        isDark ? Color.white.opacity(0.7) : Color.black.opacity(0.6)
    }
    
    static func background(isDark: Bool) -> Color {
        isDark ? Color.black : Color.white
    }
    
    static func cardBackground(isDark: Bool) -> Color {
        isDark ? Color.white.opacity(0.05) : Color.white.opacity(0.8)
    }
    
    static func surface(isDark: Bool) -> Color {
        isDark ? Color.white.opacity(0.1) : Color.black.opacity(0.05)
    }
    
    static func accent(isDark: Bool) -> Color {
        isDark ? .blue.opacity(0.8) : .blue
    }
    
    // Gradient backgrounds
    static func backgroundGradient(isDark: Bool) -> LinearGradient {
        if isDark {
            return LinearGradient(
                gradient: Gradient(colors: [
                    Color.black,
                    Color.purple.opacity(0.1),
                    Color.blue.opacity(0.1),
                    Color.indigo.opacity(0.1)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            return LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.1),
                    Color.purple.opacity(0.05),
                    Color.pink.opacity(0.08),
                    Color.mint.opacity(0.06)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    // Card gradients
    static func cardGradient(color: Color, isDark: Bool) -> LinearGradient {
        if isDark {
            return LinearGradient(
                colors: [color.opacity(0.2), color.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            return LinearGradient(
                colors: [color.opacity(0.1), color.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    // Floating particles
    static func particleColors(isDark: Bool) -> [Color] {
        if isDark {
            return [
                .white.opacity(0.03),
                .blue.opacity(0.05),
                .purple.opacity(0.04),
                .pink.opacity(0.03)
            ]
        } else {
            return [
                .blue.opacity(0.1),
                .purple.opacity(0.05),
                .pink.opacity(0.06),
                .mint.opacity(0.04)
            ]
        }
    }
}

// MARK: - Adaptive Color Extensions

extension Color {
    static func adaptiveText(isDark: Bool) -> Color {
        isDark ? .white : .black
    }
    
    static func adaptiveSecondary(isDark: Bool) -> Color {
        isDark ? Color.white.opacity(0.7) : Color.black.opacity(0.6)
    }
    
    static func adaptiveBackground(isDark: Bool) -> Color {
        isDark ? Color.black : Color.white
    }
    
    static func adaptiveCardBackground(isDark: Bool) -> Color {
        isDark ? Color.white.opacity(0.05) : Color.white.opacity(0.8)
    }
    
    static func adaptiveSurface(isDark: Bool) -> Color {
        isDark ? Color.white.opacity(0.1) : Color.black.opacity(0.05)
    }
}

// MARK: - Theme-Aware Modifiers

struct AdaptiveCardStyle: ViewModifier {
    let isDark: Bool
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColors.cardGradient(color: color, isDark: isDark))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        color.opacity(isDark ? 0.3 : 0.2),
                        lineWidth: isDark ? 1 : 2
                    )
            )
            .shadow(
                color: isDark ? color.opacity(0.1) : color.opacity(0.2),
                radius: isDark ? 5 : 10,
                x: 0,
                y: isDark ? 2 : 5
            )
    }
}

extension View {
    func adaptiveCardStyle(color: Color, isDark: Bool) -> some View {
        modifier(AdaptiveCardStyle(isDark: isDark, color: color))
    }
}