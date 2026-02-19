import SwiftUI

struct PlantDetailView: View {
    let plant: Plant
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                plantImageView
                plantInfoView
                Spacer()
            }
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.green.opacity(0.1), Color.mint.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .navigationTitle(plant.name)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var plantImageView: some View {
        VStack(spacing: 16) {
            Image(systemName: getPlantSystemImage(for: plant.imageName))
                .font(.system(size: 100))
                .foregroundColor(.green)
                .padding()
                .background(
                    Circle()
                        .fill(Color.green.opacity(0.1))
                        .frame(width: 160, height: 160)
                )
                .shadow(color: .green.opacity(0.3), radius: 20, x: 0, y: 10)
            
            if plant.isPremium {
                HStack {
                    Image(systemName: "crown.fill")
                        .foregroundColor(.orange)
                    Text("Premium Plant")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(20)
            }
        }
    }
    
    private var plantInfoView: some View {
        VStack(spacing: 20) {
            if let plantedDate = plant.plantedDate {
                VStack(spacing: 8) {
                    Text("Planted on")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(plantedDate, formatter: dateFormatter)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                    
                    Text(plantedDate, formatter: relativeDateFormatter)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.green.opacity(0.05))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.green.opacity(0.2), lineWidth: 1)
                )
            }
            
            VStack(spacing: 8) {
                Text("Required XP to Unlock")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("\(plant.requiredXP) XP")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
            .padding()
            .background(Color.blue.opacity(0.05))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.blue.opacity(0.2), lineWidth: 1)
            )
            
            Text("This beautiful plant represents your commitment to mental wellness. Each time you log your mood or complete a ritual, you're nurturing both your garden and your well-being.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color.white.opacity(0.5))
                .cornerRadius(16)
        }
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

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    return formatter
}()

private let relativeDateFormatter: RelativeDateTimeFormatter = {
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .full
    return formatter
}()

#Preview {
    PlantDetailView(plant: Plant(name: "Rose", imageName: "plant.rose", requiredXP: 200))
}