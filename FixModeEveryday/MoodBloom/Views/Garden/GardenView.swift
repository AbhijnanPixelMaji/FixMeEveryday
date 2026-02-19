import SwiftUI

struct GardenView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @State private var selectedPlant: Plant?
    @State private var showAchievements = false
    @State private var animateGrowth = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    headerView
                    xpProgressView
                    gardenGrid
                    achievementsSection
                    Spacer(minLength: 100)
                }
                .padding()
            }
            .background(gardenBackground)
            .navigationTitle("My Garden")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAchievements.toggle() }) {
                        Image(systemName: "trophy.fill")
                            .foregroundColor(.orange)
                    }
                }
            }
            .sheet(isPresented: $showAchievements) {
                AchievementsView()
            }
        }
        .onAppear {
            withAnimation(.spring(response: 1.0, dampingFraction: 0.8)) {
                animateGrowth.toggle()
            }
        }
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Your Wellness Garden")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Watch it bloom as you take care of yourself")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack {
                    Image(systemName: "leaf.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                    
                    Text("\(appState.availablePlants.count)/\(appState.unlockedPlants.count)")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                }
                .padding(12)
                .background(Color.green.opacity(0.1))
                .cornerRadius(12)
            }
        }
    }
    
    private var xpProgressView: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Experience Points")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("\(appState.currentXP) XP")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
            
            if let nextPlant = nextPlantToUnlock {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Next unlock: \(nextPlant.name)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("\(nextPlant.requiredXP - appState.currentXP) XP to go")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                    }
                    
                    ProgressView(value: Double(appState.currentXP), total: Double(nextPlant.requiredXP))
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .scaleEffect(x: 1, y: 2, anchor: .center)
                }
                .padding()
                .background(Color.blue.opacity(0.05))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                )
            }
        }
    }
    
    private var gardenGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
            ForEach(appState.unlockedPlants) { plant in
                PlantCard(plant: plant, isAnimated: animateGrowth)
                    .onTapGesture {
                        if plant.isUnlocked {
                            selectedPlant = plant
                        }
                    }
            }
        }
        .sheet(item: $selectedPlant) { plant in
            PlantDetailView(plant: plant)
        }
    }
    
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "trophy.fill")
                    .foregroundColor(.orange)
                
                Text("Recent Achievements")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("View All") {
                    showAchievements = true
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
            
            if appState.unlockedAchievements.isEmpty {
                Text("Complete activities to unlock achievements!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange.opacity(0.05))
                    .cornerRadius(12)
            } else {
                LazyVStack(spacing: 8) {
                    ForEach(Array(appState.unlockedAchievements.prefix(3))) { achievement in
                        AchievementRowView(achievement: achievement)
                    }
                }
            }
        }
    }
    
    private var gardenBackground: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.green.opacity(0.1),
                Color.blue.opacity(0.05),
                Color.mint.opacity(0.1)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var nextPlantToUnlock: Plant? {
        appState.unlockedPlants
            .filter { !$0.isUnlocked && appState.currentXP < $0.requiredXP }
            .min { $0.requiredXP < $1.requiredXP }
    }
}

struct PlantCard: View {
    let plant: Plant
    let isAnimated: Bool
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                if plant.isUnlocked {
                    Image(systemName: getPlantSystemImage(for: plant.imageName))
                        .font(.system(size: 50))
                        .foregroundColor(.green)
                        .scaleEffect(isAnimated ? 1.1 : 1.0)
                        .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(Double.random(in: 0...1)), value: isAnimated)
                } else {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.gray)
                }
                
                if plant.isPremium && !subscriptionManager.isPremium {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Image(systemName: "crown.fill")
                                .font(.caption2)
                                .foregroundColor(.orange)
                                .padding(4)
                                .background(Circle().fill(Color.white))
                        }
                    }
                }
            }
            .frame(width: 80, height: 80)
            .background(
                Circle()
                    .fill(plant.isUnlocked ? Color.green.opacity(0.1) : Color.gray.opacity(0.1))
            )
            
            VStack(spacing: 4) {
                Text(plant.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                
                if plant.isUnlocked {
                    if let plantedDate = plant.plantedDate {
                        Text("Planted \(plantedDate, formatter: relativeDateFormatter)")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                } else {
                    Text("\(plant.requiredXP) XP")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.8))
        .cornerRadius(16)
        .shadow(color: plant.isUnlocked ? .green.opacity(0.2) : .gray.opacity(0.1), radius: 8, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(plant.isUnlocked ? Color.green.opacity(0.3) : Color.gray.opacity(0.2), lineWidth: 1)
        )
        .opacity(plant.isUnlocked ? 1.0 : 0.6)
    }
    
    private func getPlantSystemImage(for imageName: String) -> String {
        switch imageName {
        case "plant.seedling": return "leaf.fill"
        case "plant.daisy": return "circle.fill"
        case "plant.sunflower": return "sun.max.fill"
        case "plant.rose": return "heart.fill"
        case "plant.tree": return "tree.fill"
        case "plant.cherry": return "snowflake"
        case "plant.lotus": return "sparkles"
        default: return "leaf.fill"
        }
    }
}

private let relativeDateFormatter: RelativeDateTimeFormatter = {
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .abbreviated
    return formatter
}()

#Preview {
    GardenView()
        .environmentObject(AppState())
        .environmentObject(SubscriptionManager())
}