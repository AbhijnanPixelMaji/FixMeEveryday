import SwiftUI

struct ThemeSelectionView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                headerView
                themeOptions
                Spacer()
            }
            .navigationTitle("Choose Theme")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    themeManager.isDarkMode ? Color.black : Color.blue.opacity(0.05),
                    themeManager.isDarkMode ? Color.purple.opacity(0.1) : Color.purple.opacity(0.02),
                    themeManager.isDarkMode ? Color.indigo.opacity(0.1) : Color.mint.opacity(0.03)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            // Theme preview icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.blue.opacity(0.1), .purple.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Image(systemName: themeManager.currentTheme.icon)
                    .font(.system(size: 40))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            VStack(spacing: 8) {
                Text("Customize Your Experience")
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text("Choose how MoodBloom looks and feels. Your selection will be saved automatically.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
    }
    
    private var themeOptions: some View {
        VStack(spacing: 16) {
            ForEach(AppTheme.allCases, id: \.self) { theme in
                ThemeOptionCard(
                    theme: theme,
                    isSelected: theme == themeManager.currentTheme
                ) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        themeManager.setTheme(theme)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

struct ThemeOptionCard: View {
    let theme: AppTheme
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Theme icon
                ZStack {
                    Circle()
                        .fill(themeColor.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: theme.icon)
                        .font(.title2)
                        .foregroundColor(themeColor)
                }
                
                // Theme info
                VStack(alignment: .leading, spacing: 4) {
                    Text(theme.displayName)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(themeDescription)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Selection indicator
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(themeColor)
                        .scaleEffect(1.1)
                } else {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                        .frame(width: 24, height: 24)
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .opacity(isSelected ? 1.0 : 0.8)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        isSelected ? themeColor : Color.gray.opacity(0.2),
                        lineWidth: isSelected ? 2 : 1
                    )
            )
            .shadow(
                color: isSelected ? themeColor.opacity(0.2) : Color.black.opacity(0.1),
                radius: isSelected ? 8 : 4,
                x: 0,
                y: isSelected ? 4 : 2
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var themeColor: Color {
        switch theme {
        case .light:
            return .orange
        case .dark:
            return .indigo
        case .system:
            return .blue
        }
    }
    
    private var themeDescription: String {
        switch theme {
        case .light:
            return "Always use light appearance"
        case .dark:
            return "Always use dark appearance"
        case .system:
            return "Match your device settings"
        }
    }
}

// MARK: - Theme Preview Components

struct ThemePreviewCard: View {
    let theme: AppTheme
    
    var body: some View {
        VStack(spacing: 8) {
            // Mini header
            HStack {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 12, height: 12)
                
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 4)
                    .cornerRadius(2)
                
                Spacer()
            }
            
            // Mini content area
            VStack(spacing: 4) {
                Rectangle()
                    .fill(Color.pink.opacity(0.6))
                    .frame(height: 8)
                    .cornerRadius(4)
                
                Rectangle()
                    .fill(Color.green.opacity(0.6))
                    .frame(height: 8)
                    .cornerRadius(4)
                
                Rectangle()
                    .fill(Color.orange.opacity(0.6))
                    .frame(height: 8)
                    .cornerRadius(4)
            }
        }
        .padding(8)
        .frame(width: 80, height: 60)
        .background(previewBackground)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
        )
    }
    
    private var previewBackground: Color {
        switch theme {
        case .light:
            return .white
        case .dark:
            return .black
        case .system:
            return Color(.systemBackground)
        }
    }
}

#Preview {
    ThemeSelectionView()
        .environmentObject(ThemeManager())
}