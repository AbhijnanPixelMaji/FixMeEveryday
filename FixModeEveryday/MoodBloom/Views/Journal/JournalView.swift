import SwiftUI

struct JournalView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @State private var showNewEntry = false
    @State private var searchText = ""
    @State private var showPremiumAlert = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if subscriptionManager.isPremium {
                    searchBar
                }
                
                journalContent
            }
            .navigationTitle("Journal")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showNewEntry = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showNewEntry) {
                NewJournalEntryView()
            }
            .alert("Premium Feature", isPresented: $showPremiumAlert) {
                Button("Upgrade") {
                    // Navigate to premium screen
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Advanced journal features require a premium subscription.")
            }
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search your entries...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
    
    private var journalContent: some View {
        Group {
            if appState.journalEntries.isEmpty {
                emptyStateView
            } else {
                journalEntriesList
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "book.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("Start Your Journal")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Reflect on your thoughts and feelings. Writing helps process emotions and track your mental wellness journey.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Button(action: { showNewEntry = true }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Write First Entry")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .padding()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.blue, .purple]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(12)
            }
            
            Spacer()
            Spacer()
        }
        .padding()
    }
    
    private var journalEntriesList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredEntries) { entry in
                    JournalEntryCard(entry: entry)
                }
            }
            .padding()
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.02), Color.purple.opacity(0.02)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
    
    private var filteredEntries: [JournalEntry] {
        let entries = appState.journalEntries.sorted { $0.date > $1.date }
        
        if searchText.isEmpty {
            return entries
        } else {
            return entries.filter { entry in
                entry.content.localizedCaseInsensitiveContains(searchText) ||
                entry.tags.contains { $0.localizedCaseInsensitiveContains(searchText) }
            }
        }
    }
}

struct JournalEntryCard: View {
    let entry: JournalEntry
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            headerView
            contentView
            if subscriptionManager.isPremium && !entry.tags.isEmpty {
                tagsView
            }
        }
        .padding()
        .background(Color.white.opacity(0.8))
        .cornerRadius(16)
        .shadow(color: .blue.opacity(0.1), radius: 8, x: 0, y: 4)
        .onTapGesture {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                isExpanded.toggle()
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.date, formatter: dateFormatter)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(entry.date, formatter: timeFormatter)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(spacing: 2) {
                Text("+\(entry.xpEarned)")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                Text("XP")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(6)
        }
    }
    
    private var contentView: some View {
        Text(entry.content)
            .font(.body)
            .foregroundColor(.primary)
            .lineLimit(isExpanded ? nil : 3)
            .animation(.easeInOut(duration: 0.3), value: isExpanded)
    }
    
    @ViewBuilder
    private var tagsView: some View {
        if !entry.tags.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(entry.tags, id: \.self) { tag in
                        Text(tag)
                            .font(.caption2)
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal, 1)
            }
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

private let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter
}()

#Preview {
    JournalView()
        .environmentObject(AppState())
        .environmentObject(SubscriptionManager())
}