import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showPremiumSheet = false
    @State private var showProfileEditor = false
    @State private var showThemeSheet = false
    
    var body: some View {
        NavigationView {
            List {
                profileSection
                premiumSection
                appearanceSection
                notificationSection
                dataSection
                supportSection
                aboutSection
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showPremiumSheet) {
            PremiumSubscriptionView()
        }
        .sheet(isPresented: $showProfileEditor) {
            ProfileEditorView()
        }
        .sheet(isPresented: $showThemeSheet) {
            ThemeSelectionView()
        }
    }
    
    private var profileSection: some View {
        Section("Profile") {
            HStack {
                Image(systemName: appState.userProfile.avatar)
                    .font(.system(size: 30))
                    .foregroundColor(.blue)
                    .frame(width: 40, height: 40)
                    .background(Circle().fill(Color.blue.opacity(0.1)))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(appState.userProfile.name.isEmpty ? "Wellness Friend" : appState.userProfile.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("Member since \(appState.userProfile.joinDate, formatter: joinDateFormatter)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button("Edit") {
                    showProfileEditor = true
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
            .padding(.vertical, 4)
        }
    }
    
    private var premiumSection: some View {
        Section("Subscription") {
            if subscriptionManager.isPremium {
                HStack {
                    Image(systemName: "crown.fill")
                        .foregroundColor(.orange)
                    
                    VStack(alignment: .leading) {
                        Text("Premium Member")
                            .fontWeight(.semibold)
                        Text("Access to all features")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Text("Active")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                }
                
                Button("Manage Subscription") {
                    showPremiumSheet = true
                }
                .foregroundColor(.blue)
            } else {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Free Plan")
                            .fontWeight(.semibold)
                        Text("Upgrade for premium features")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button("Upgrade") {
                        showPremiumSheet = true
                    }
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.orange, .pink]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(8)
                }
            }
        }
    }
    
    private var appearanceSection: some View {
        Section("Appearance") {
            Button(action: {
                showThemeSheet = true
            }) {
                HStack {
                    Image(systemName: themeManager.currentTheme.icon)
                        .foregroundColor(.blue)
                        .font(.title3)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Theme")
                            .foregroundColor(.primary)
                            .fontWeight(.medium)
                        
                        Text("Currently: \(themeManager.currentTheme.displayName)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    private var notificationSection: some View {
        Section("Notifications") {
            HStack {
                Image(systemName: "bell.fill")
                    .foregroundColor(.blue)
                
                Toggle("Daily Reminders", isOn: Binding(
                    get: { appState.userProfile.notificationsEnabled },
                    set: { appState.userProfile.notificationsEnabled = $0 }
                ))
            }
            
            if appState.userProfile.notificationsEnabled {
                HStack {
                    Image(systemName: "clock.fill")
                        .foregroundColor(.blue)
                    
                    Text("Reminder Time")
                    
                    Spacer()
                    
                    DatePicker("", selection: Binding(
                        get: { appState.userProfile.reminderTime },
                        set: { appState.userProfile.reminderTime = $0 }
                    ), displayedComponents: .hourAndMinute)
                    .labelsHidden()
                }
            }
        }
    }
    
    private var dataSection: some View {
        Section("Your Data") {
            NavigationLink(destination: DataExportView()) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.blue)
                    Text("Export Data")
                }
            }
            
            HStack {
                Image(systemName: "chart.bar.fill")
                    .foregroundColor(.green)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Your Statistics")
                        .fontWeight(.medium)
                    
                    Text("\(appState.moodEntries.count) mood entries • \(appState.journalEntries.count) journal entries")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    private var supportSection: some View {
        Section("Support & Feedback") {
            Link(destination: URL(string: "mailto:support@moodbloom.app")!) {
                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(.blue)
                    Text("Contact Support")
                    Spacer()
                    Image(systemName: "arrow.up.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Link(destination: URL(string: "https://apps.apple.com/app/moodbloom")!) {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.orange)
                    Text("Rate MoodBloom")
                    Spacer()
                    Image(systemName: "arrow.up.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            NavigationLink(destination: FeedbackView()) {
                HStack {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                        .foregroundColor(.green)
                    Text("Send Feedback")
                }
            }
        }
    }
    
    private var aboutSection: some View {
        Section("About") {
            NavigationLink(destination: PrivacyPolicyView()) {
                HStack {
                    Image(systemName: "hand.raised.fill")
                        .foregroundColor(.purple)
                    Text("Privacy Policy")
                }
            }
            
            NavigationLink(destination: TermsOfServiceView()) {
                HStack {
                    Image(systemName: "doc.text.fill")
                        .foregroundColor(.blue)
                    Text("Terms of Service")
                }
            }
            
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.gray)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("MoodBloom")
                        .fontWeight(.medium)
                    Text("Version 1.0.0")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

private let joinDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

#Preview {
    SettingsView()
        .environmentObject(AppState())
        .environmentObject(SubscriptionManager())
}