import StoreKit
import SwiftUI

class SubscriptionService: ObservableObject {
    static let shared = SubscriptionService()
    
    @Published var products: [Product] = []
    @Published var purchasedProductIDs = Set<String>()
    @Published var isLoading = false
    @Published var error: String?
    
    private let weeklySubscriptionID = "lunara.sub.weekly"
    private let yearlySubscriptionID = "lunara.sub.yearly"
    private let yearlyPromoSubscriptionID = "lunara.subscription.yearlypromo"
    
    private let freeInterpretationAttemptsKey = "freeInterpretationAttempts"
    private let freeLucidDreamingLessonAttemptsKey = "freeLucidDreamingLessonAttempts"
    private let freeDailyDreamFactAttemptsKey = "freeDailyDreamFactAttempts"
    private let maxFreeAttempts = 1
    
    // Test mode - premium username
    private let premiumTestUsername = "premiumuser"
    
    private var productIDs: Set<String> {
        return [weeklySubscriptionID, yearlySubscriptionID, yearlyPromoSubscriptionID]
    }
    
    private var updates: Task<Void, Never>? = nil
    
    init() {
        updates = observeTransactionUpdates()
        Task {
            await loadProducts()
            await updatePurchasedProducts()
        }
    }
    
    deinit {
        updates?.cancel()
    }
    
    // MARK: - Product Loading
    
    @MainActor
    func loadProducts() async {
        isLoading = true
        error = nil
        
        do {
            products = try await Product.products(for: productIDs)
            products.sort { $0.price < $1.price } // Sort by price
            isLoading = false
            print("Loaded products: \(products.map { $0.id }.joined(separator: ", "))")
        } catch {
            self.error = "Failed to load products: \(error.localizedDescription)"
            print("Failed to load products: \(error.localizedDescription)")
            isLoading = false
        }
    }
    
    // MARK: - Purchase Processing
    
    @MainActor
    func purchase(_ product: Product) async throws -> Bool {
        do {
            print("Attempting to purchase product: \(product.id)")
            let result = try await product.purchase()
            
            switch result {
            case .success(let verificationResult):
                // Check whether the transaction is verified
                switch verificationResult {
                case .verified(let transaction):
                    print("Purchase successful for product: \(product.id)")
                    // Update the purchased products
                    purchasedProductIDs.insert(transaction.productID)
                    await updatePurchasedProducts()
                    // Finish the transaction
                    await transaction.finish()
                    return true
                    
                case .unverified:
                    print("Purchase verification failed for product: \(product.id)")
                    throw StoreError.failedVerification
                }
                
            case .userCancelled:
                print("User cancelled purchase for product: \(product.id)")
                return false
                
            case .pending:
                print("Purchase pending for product: \(product.id)")
                return false
                
            @unknown default:
                print("Unknown purchase result for product: \(product.id)")
                return false
            }
            
        } catch {
            print("Purchase error for product \(product.id): \(error.localizedDescription)")
            self.error = error.localizedDescription
            throw error
        }
    }
    
    // MARK: - Transaction Handling
    
    private func observeTransactionUpdates() -> Task<Void, Never> {
        return Task.detached { [weak self] in
            // Iterate through any transactions that don't have the `finish()` call
            for await result in StoreKit.Transaction.updates {
                await self?.handle(transactionResult: result)
            }
        }
    }
    
    @MainActor
    private func handle(transactionResult result: VerificationResult<StoreKit.Transaction>) async {
        switch result {
        case .verified(let transaction):
            print("Transaction verified for product: \(transaction.productID)")
            // Update the purchased products
            purchasedProductIDs.insert(transaction.productID)
            
            // Finish the transaction
            await transaction.finish()
            
        case .unverified:
            print("Transaction unverified")
            // Handle unverified transaction
            break
        }
    }
    
    @MainActor
    func updatePurchasedProducts() async {
        // Retrieve all transactions for the app
        for await result in StoreKit.Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                purchasedProductIDs.insert(transaction.productID)
                print("Current entitlement found: \(transaction.productID)")
            }
        }
        print("Updated purchased products: \(purchasedProductIDs)")
    }
    
    // MARK: - Helper Methods
    
    func getProduct(for id: String) -> Product? {
        let product = products.first { $0.id == id }
        if product == nil {
            print("Product not found: \(id). Available products: \(products.map { $0.id }.joined(separator: ", "))")
        }
        return product
    }
    
    // MARK: - Subscription Status
    
    func isSubscribed() -> Bool {
        // During testing phase, all users have premium access
        return true
        
        /* Original implementation - uncomment when reactivating subscriptions
        // Check for test mode - if username is "premiumuser"
        if isPremiumTestUser() {
            return true
        }
        
        // Regular subscription check
        return !purchasedProductIDs.isEmpty
        */
    }
    
    // Test mode helper function
    private func isPremiumTestUser() -> Bool {
        let currentUsername = UserDefaults.standard.string(forKey: "userName") ?? ""
        return currentUsername.lowercased() == premiumTestUsername.lowercased()
    }
    
    // MARK: - Free Feature Attempts
    
    // Dream Interpretation
    func canInterpretDream() -> Bool {
        if isSubscribed() {
            return true
        }
        
        let usedAttempts = UserDefaults.standard.integer(forKey: freeInterpretationAttemptsKey)
        return usedAttempts < maxFreeAttempts
    }
    
    func incrementInterpretationAttempts() {
        if !isSubscribed() {
            let currentAttempts = UserDefaults.standard.integer(forKey: freeInterpretationAttemptsKey)
            UserDefaults.standard.set(currentAttempts + 1, forKey: freeInterpretationAttemptsKey)
        }
    }
    
    // Lucid Dreaming Lesson
    func canViewLucidDreamingLesson() -> Bool {
        if isSubscribed() {
            return true
        }
        
        let usedAttempts = UserDefaults.standard.integer(forKey: freeLucidDreamingLessonAttemptsKey)
        return usedAttempts < maxFreeAttempts
    }
    
    func incrementLucidDreamingLessonAttempts() {
        if !isSubscribed() {
            let currentAttempts = UserDefaults.standard.integer(forKey: freeLucidDreamingLessonAttemptsKey)
            UserDefaults.standard.set(currentAttempts + 1, forKey: freeLucidDreamingLessonAttemptsKey)
        }
    }
    
    // Daily Dream Fact
    func canViewDailyDreamFact() -> Bool {
        if isSubscribed() {
            return true
        }
        
        let usedAttempts = UserDefaults.standard.integer(forKey: freeDailyDreamFactAttemptsKey)
        return usedAttempts < maxFreeAttempts
    }
    
    func incrementDailyDreamFactAttempts() {
        if !isSubscribed() {
            let currentAttempts = UserDefaults.standard.integer(forKey: freeDailyDreamFactAttemptsKey)
            UserDefaults.standard.set(currentAttempts + 1, forKey: freeDailyDreamFactAttemptsKey)
        }
    }
    
    func resetAllFreeAttempts() {
        UserDefaults.standard.set(0, forKey: freeInterpretationAttemptsKey)
        UserDefaults.standard.set(0, forKey: freeLucidDreamingLessonAttemptsKey)
        UserDefaults.standard.set(0, forKey: freeDailyDreamFactAttemptsKey)
    }
    
    // MARK: - Formatting Helpers
    
    func formattedPrice(for product: Product) -> String {
        return product.displayPrice
    }
    
    // MARK: - Debug Methods
    
    func loadPromoProduct() async {
        do {
            let promoProducts = try await Product.products(for: [yearlyPromoSubscriptionID])
            if !promoProducts.isEmpty {
                print("Successfully loaded promo product: \(promoProducts[0].id)")
                if !products.contains(where: { $0.id == yearlyPromoSubscriptionID }) {
                    products.append(contentsOf: promoProducts)
                }
            } else {
                print("No promo product found with ID: \(yearlyPromoSubscriptionID)")
            }
        } catch {
            print("Failed to load promo product: \(error.localizedDescription)")
        }
    }
}

// MARK: - Store Errors

enum StoreError: Error {
    case failedVerification
    case transactionFailed
} 