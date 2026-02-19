import SwiftUI
import Charts

struct InsightsView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @State private var selectedTimeRange: TimeRange = .week
    @State private var showPremiumAlert = false
    
    enum TimeRange: String, CaseIterable {
        case week = "7D"
        case month = "30D"
        case threeMonths = "90D"
        
        var days: Int {
            switch self {
            case .week: return 7
            case .month: return 30
            case .threeMonths: return 90
            }
        }
        
        var title: String {
            switch self {
            case .week: return "Past Week"
            case .month: return "Past Month"
            case .threeMonths: return "Past 3 Months"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    timeRangePicker
                    moodTrendChart
                    statisticsCards
                    
                    if subscriptionManager.isPremium {
                        aiInsightsSection
                    } else {
                        premiumInsightsCard
                    }
                    
                    Spacer(minLength: 100)
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
            .navigationTitle("Insights")
            .navigationBarTitleDisplayMode(.large)
        }
        .alert("Premium Feature", isPresented: $showPremiumAlert) {
            Button("Upgrade") {
                // Navigate to premium screen
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("AI insights require a premium subscription.")
        }
    }
    
    private var timeRangePicker: some View {
        HStack {
            Text("Time Period")
                .font(.headline)
                .fontWeight(.semibold)
            
            Spacer()
            
            Picker("Time Range", selection: $selectedTimeRange) {
                ForEach(TimeRange.allCases, id: \.self) { range in
                    Text(range.rawValue).tag(range)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(width: 150)
        }
    }
    
    private var moodTrendChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Mood Trends")
                .font(.headline)
                .fontWeight(.semibold)
            
            if filteredMoodData.isEmpty {
                emptyChartView
            } else {
                Chart(filteredMoodData, id: \.date) { dataPoint in
                    LineMark(
                        x: .value("Date", dataPoint.date),
                        y: .value("Mood", dataPoint.moodValue)
                    )
                    .foregroundStyle(.blue)
                    .lineStyle(StrokeStyle(lineWidth: 3))
                    
                    PointMark(
                        x: .value("Date", dataPoint.date),
                        y: .value("Mood", dataPoint.moodValue)
                    )
                    .foregroundStyle(.blue)
                    .symbolSize(50)
                }
                .frame(height: 200)
                .chartYScale(domain: 1...5)
                .chartYAxis {
                    AxisMarks(values: [1, 2, 3, 4, 5]) { value in
                        AxisGridLine()
                        AxisValueLabel {
                            if let intValue = value.as(Int.self) {
                                Text(MoodLevel(rawValue: intValue)?.emoji ?? "")
                            }
                        }
                    }
                }
                .padding()
                .background(Color.white.opacity(0.8))
                .cornerRadius(16)
                .shadow(color: .blue.opacity(0.1), radius: 8, x: 0, y: 4)
            }
        }
    }
    
    private var emptyChartView: some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 40))
                .foregroundColor(.gray.opacity(0.6))
            
            Text("Not enough data yet")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("Log your mood for a few more days to see trends!")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.8))
        .cornerRadius(16)
    }
    
    private var statisticsCards: some View {
        VStack(spacing: 16) {
            Text("Statistics")
                .font(.headline)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                StatCard(
                    title: "Average Mood",
                    value: String(format: "%.1f", averageMood),
                    icon: "heart.fill",
                    color: .pink
                )
                
                StatCard(
                    title: "Total Entries",
                    value: "\(filteredMoodData.count)",
                    icon: "calendar.badge.plus",
                    color: .blue
                )
                
                StatCard(
                    title: "Current Streak",
                    value: "\(appState.currentStreak)",
                    icon: "flame.fill",
                    color: .orange
                )
                
                StatCard(
                    title: "Rituals Done",
                    value: "\(filteredRitualsCount)",
                    icon: "sparkles",
                    color: .purple
                )
            }
        }
    }
    
    private var aiInsightsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .foregroundColor(.purple)
                
                Text("AI Insights")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("Premium")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.orange.opacity(0.2))
                    .cornerRadius(4)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach(mockAIInsights, id: \.self) { insight in
                    InsightCard(insight: insight)
                }
            }
        }
    }
    
    private var premiumInsightsCard: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .foregroundColor(.purple)
                
                Text("AI Insights")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            
            VStack(spacing: 12) {
                Text("Get personalized insights about your mood patterns")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Button(action: { showPremiumAlert = true }) {
                    HStack {
                        Image(systemName: "crown.fill")
                        Text("Upgrade to Premium")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.purple, .orange]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                }
            }
        }
        .padding()
        .background(Color.purple.opacity(0.05))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.purple.opacity(0.2), lineWidth: 1)
        )
    }
    
    private var filteredMoodData: [MoodDataPoint] {
        let calendar = Calendar.current
        let endDate = Date()
        let startDate = calendar.date(byAdding: .day, value: -selectedTimeRange.days, to: endDate) ?? endDate
        
        return appState.moodEntries
            .filter { $0.date >= startDate && $0.date <= endDate }
            .map { MoodDataPoint(date: $0.date, moodValue: Double($0.mood.rawValue)) }
            .sorted { $0.date < $1.date }
    }
    
    private var averageMood: Double {
        guard !filteredMoodData.isEmpty else { return 0 }
        let sum = filteredMoodData.reduce(0) { $0 + $1.moodValue }
        return sum / Double(filteredMoodData.count)
    }
    
    private var filteredRitualsCount: Int {
        let calendar = Calendar.current
        let endDate = Date()
        let startDate = calendar.date(byAdding: .day, value: -selectedTimeRange.days, to: endDate) ?? endDate
        
        return appState.completedRituals.filter { ritual in
            ritual.date >= startDate && ritual.date <= endDate
        }.count
    }
    
    private var mockAIInsights: [String] {
        [
            "Your mood tends to be higher on weekends. Consider what activities make you feel good and try incorporating them into weekdays.",
            "You've been consistent with your journaling this week. Reflection is helping you process emotions better.",
            "Your mood dipped midweek. Try scheduling more self-care activities during this time."
        ]
    }
}

struct MoodDataPoint {
    let date: Date
    let moodValue: Double
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title3)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(color)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
        .background(color.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(color.opacity(0.2), lineWidth: 1)
        )
    }
}

struct InsightCard: View {
    let insight: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "lightbulb.fill")
                .foregroundColor(.yellow)
                .font(.title3)
                .padding(.top, 2)
            
            Text(insight)
                .font(.subheadline)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color.yellow.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.yellow.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    InsightsView()
        .environmentObject(AppState())
        .environmentObject(SubscriptionManager())
}