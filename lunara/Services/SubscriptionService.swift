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
    
    private var productIDs: Set<String> {
        return [weeklySubscriptionID, yearlySubscriptionID]
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
        } catch {
            self.error = "Failed to load products: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    // MARK: - Purchase Processing
    
    @MainActor
    func purchase(_ product: Product) async throws -> Bool {
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verificationResult):
                // Check whether the transaction is verified
                switch verificationResult {
                case .verified(let transaction):
                    // Update the purchased products
                    await updatePurchasedProducts()
                    // Finish the transaction
                    await transaction.finish()
                    return true
                    
                case .unverified:
                    throw StoreError.failedVerification
                }
                
            case .userCancelled:
                return false
                
            case .pending:
                return false
                
            @unknown default:
                return false
            }
            
        } catch {
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
            // Update the purchased products
            purchasedProductIDs.insert(transaction.productID)
            
            // Finish the transaction
            await transaction.finish()
            
        case .unverified:
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
            }
        }
    }
    
    // MARK: - Helper Methods
    
    func getProduct(for id: String) -> Product? {
        return products.first { $0.id == id }
    }
    
    func isSubscribed() -> Bool {
        return !purchasedProductIDs.isEmpty
    }
    
    // MARK: - Formatting Helpers
    
    func formattedPrice(for product: Product) -> String {
        return product.displayPrice
    }
}

// MARK: - Store Errors

enum StoreError: Error {
    case failedVerification
    case transactionFailed
} 