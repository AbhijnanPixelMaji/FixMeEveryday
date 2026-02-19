import SwiftUI

struct PremiumSubscriptionView: View {
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPlan: SubscriptionPlan = .monthly
    
    enum SubscriptionPlan: CaseIterable {
        case monthly
        case yearly
        
        var title: String {
            switch self {
            case .monthly: return "Monthly"
            case .yearly: return "Yearly"
            }
        }
        
        var price: String {
            switch self {
            case .monthly: return "$4.99/month"
            case .yearly: return "$39.99/year"
            }
        }
        
        var savings: String? {
            switch self {
            case .monthly: return nil
            case .yearly: return "Save 33%"
            }
        }
        
        var description: String {
            switch self {
            case .monthly: return "Perfect for trying premium features"
            case .yearly: return "Best value • 2 months free"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    headerView
                    featuresGrid
                    subscriptionPlans
                    subscribeButton
                    footerView
                    Spacer(minLength: 50)
                }
                .padding()
            }
            .background(premiumBackground)
            .navigationTitle("MoodBloom Premium")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            Image(systemName: "crown.fill")
                .font(.system(size: 60))
                .foregroundColor(.orange)
                .background(
                    Circle()
                        .fill(.orange.opacity(0.1))
                        .frame(width: 100, height: 100)
                )
            
            Text("Unlock Your Full Potential")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text("Discover advanced insights, premium plants, and exclusive features to enhance your wellness journey.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    private var featuresGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 20) {
            PremiumFeatureCard(
                icon: "brain.head.profile",
                title: "AI Insights",
                description: "Personalized wellness patterns",
                color: .purple
            )
            
            PremiumFeatureCard(
                icon: "tag.fill",
                title: "Journal Tags",
                description: "Organize your thoughts",
                color: .blue
            )
            
            PremiumFeatureCard(
                icon: "square.and.arrow.up",
                title: "Data Export",
                description: "Download your journal as PDF",
                color: .green
            )
            
            PremiumFeatureCard(
                icon: "sparkles",
                title: "Premium Rituals",
                description: "Exclusive wellness activities",
                color: .pink
            )
            
            PremiumFeatureCard(
                icon: "leaf.fill",
                title: "Rare Plants",
                description: "Beautiful garden additions",
                color: .mint
            )
            
            PremiumFeatureCard(
                icon: "paintpalette.fill",
                title: "Garden Themes",
                description: "Customize your space",
                color: .orange
            )
        }
    }
    
    private var subscriptionPlans: some View {
        VStack(spacing: 16) {
            Text("Choose Your Plan")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                ForEach(SubscriptionPlan.allCases, id: \.self) { plan in
                    SubscriptionPlanCard(
                        plan: plan,
                        isSelected: selectedPlan == plan
                    ) {
                        selectedPlan = plan
                    }
                }
            }
        }
    }
    
    private var subscribeButton: some View {
        VStack(spacing: 12) {
            Button(action: subscribeToPremium) {
                HStack {
                    Image(systemName: "crown.fill")
                    Text("Start Premium")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.orange, .pink]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(16)
                .shadow(color: .orange.opacity(0.4), radius: 10, x: 0, y: 5)
            }
            
            Button("Restore Purchases") {
                Task {
                    await subscriptionManager.restorePurchases()
                }
            }
            .font(.caption)
            .foregroundColor(.blue)
        }
    }
    
    private var footerView: some View {
        VStack(spacing: 8) {
            Text("• Cancel anytime • No hidden fees • Secure payment")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Text("By subscribing, you agree to our Terms of Service and Privacy Policy")
                .font(.caption2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    private var premiumBackground: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.orange.opacity(0.1),
                Color.pink.opacity(0.05),
                Color.purple.opacity(0.1)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private func subscribeToPremium() {
        Task {
            await subscriptionManager.loadProducts()
            
            let productId = selectedPlan == .monthly ? "moodbloom_premium_monthly" : "moodbloom_premium_yearly"
            if let product = subscriptionManager.products.first(where: { $0.id == productId }) {
                await subscriptionManager.purchase(product)
            }
        }
    }
}

struct PremiumFeatureCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(color)
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(color.opacity(0.1))
                )
            
            VStack(spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .background(Color.white.opacity(0.6))
        .cornerRadius(16)
        .shadow(color: color.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

struct SubscriptionPlanCard: View {
    let plan: PremiumSubscriptionView.SubscriptionPlan
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(plan.title)
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        if let savings = plan.savings {
                            Text(savings)
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.orange)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.orange.opacity(0.2))
                                .cornerRadius(4)
                        }
                    }
                    
                    Text(plan.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(plan.price)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(isSelected ? .orange : .primary)
                }
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .orange : .gray)
                    .font(.title3)
            }
            .padding()
            .background(isSelected ? Color.orange.opacity(0.1) : Color.white.opacity(0.6))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.orange : Color.gray.opacity(0.2), lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    PremiumSubscriptionView()
        .environmentObject(SubscriptionManager())
}