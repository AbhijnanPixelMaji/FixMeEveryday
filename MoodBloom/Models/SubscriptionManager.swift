import Foundation
import StoreKit
import SwiftUI

@MainActor
class SubscriptionManager: ObservableObject {
    @Published var isPremium: Bool = false
    @Published var products: [Product] = []
    @Published var purchasedProducts: [Product] = []
    
    private var updates: Task<Void, Never>?
    
    init() {
        updates = observeTransactionUpdates()
    }
    
    deinit {
        updates?.cancel()
    }
    
    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [weak self] in
            for await _ in Transaction.updates {
                await self?.updatePurchasedProducts()
            }
        }
    }
    
    func loadProducts() async {
        do {
            let productIds = ["moodbloom_premium_monthly", "moodbloom_premium_yearly"]
            products = try await Product.products(for: Set(productIds))
        } catch {
            print("Failed to load products: \(error)")
        }
    }
    
    func purchase(_ product: Product) async {
        do {
            let result = try await product.purchase()
            
            switch result {
            case let .success(.verified(transaction)):
                await transaction.finish()
                await updatePurchasedProducts()
            case let .success(.unverified(_, error)):
                print("Unverified transaction: \(error)")
            case .pending:
                print("Transaction is pending")
            case .userCancelled:
                print("User cancelled transaction")
            @unknown default:
                print("Unknown purchase result")
            }
        } catch {
            print("Failed to purchase product: \(error)")
        }
    }
    
    func restorePurchases() async {
        try? await AppStore.sync()
        await updatePurchasedProducts()
    }
    
    private func updatePurchasedProducts() async {
        var purchasedProducts: [Product] = []
        
        for await result in Transaction.currentEntitlements {
            if case let .verified(transaction) = result {
                if let product = products.first(where: { $0.id == transaction.productID }) {
                    purchasedProducts.append(product)
                }
            }
        }
        
        self.purchasedProducts = purchasedProducts
        self.isPremium = !purchasedProducts.isEmpty
    }
    
    // MARK: - Premium Feature Checks
    func requiresPremium(for feature: PremiumFeature) -> Bool {
        return feature.requiresPremium && !isPremium
    }
    
    enum PremiumFeature {
        case advancedInsights
        case journalTags
        case journalExport
        case premiumRituals
        case premiumPlants
        case premiumThemes
        
        var requiresPremium: Bool {
            switch self {
            case .advancedInsights, .journalTags, .journalExport, .premiumRituals, .premiumPlants, .premiumThemes:
                return true
            }
        }
        
        var title: String {
            switch self {
            case .advancedInsights: return "AI Wellness Insights"
            case .journalTags: return "Journal Tags"
            case .journalExport: return "Export Journal"
            case .premiumRituals: return "Premium Rituals"
            case .premiumPlants: return "Rare Plants"
            case .premiumThemes: return "Garden Themes"
            }
        }
        
        var description: String {
            switch self {
            case .advancedInsights: return "Get AI-powered insights about your mood patterns"
            case .journalTags: return "Organize your journal entries with custom tags"
            case .journalExport: return "Export your journal as a PDF"
            case .premiumRituals: return "Access exclusive wellness rituals"
            case .premiumPlants: return "Unlock beautiful rare plants for your garden"
            case .premiumThemes: return "Choose from stunning garden themes"
            }
        }
    }
}