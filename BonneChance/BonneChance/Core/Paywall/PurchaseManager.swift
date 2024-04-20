//
//  PaywallViewModel.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-04-16.
//

import Foundation
import StoreKit

@MainActor
final class PurchaseManager: ObservableObject {
    
    private let productIdentifiers = [ProductIdentifier.gold1Month.rawValue, ProductIdentifier.gold1Year.rawValue, ProductIdentifier.gold3Month.rawValue]
    
    @Published private(set) var products: [Product] = []
    @Published private(set) var purchasedProductIDs = Set<String>()
    
    private var productsLoaded = false
    private var updates: Task<Void, Never>? = nil
    
    init() {
        self.updates = observeTransactionUpdates()
    }
    
    deinit {
        self.updates?.cancel()
    }
    
    var hasUnlockedPro: Bool {
        return !self.purchasedProductIDs.isEmpty
    }
    
    func loadProducts() async throws {
        
        guard !self.productsLoaded else { return }
        let decoder = JSONDecoder()
        
        let productList = try await Product.products(for: productIdentifiers).sorted { product1, product2 in
            var result = false
            do {
                let product1DAO = try decoder.decode(ProductDAO.self, from: product1.jsonRepresentation)
                let product2DAO = try decoder.decode(ProductDAO.self, from: product2.jsonRepresentation)
                
                result = product1DAO.attributes.subscriptionFamilyRank < product2DAO.attributes.subscriptionFamilyRank
            } catch {
                print(error)
            }
            return result
        }
        
        self.products = productList
        self.productsLoaded = true
    }
    
    func purchase(product: Product) async throws {
        let result = try await product.purchase()
        
        switch result {
        case let .success(.verified(transaction)):
            // Successful purhcase
            await transaction.finish()
            await self.updatePurchasedProducts()
        case let .success(.unverified(_, error)):
            // Successful purchase but transaction/receipt can't be verified
            // Could be a jailbroken phone
        print(error)
            break
        case .pending:
            // Transaction waiting on SCA (Strong Customer Authentication) or
            // approval from Ask to Buy
            break
        case .userCancelled:
            // ^^^
            break
        @unknown default:
            break
        }
    }
    
    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }

            if transaction.revocationDate == nil {
                self.purchasedProductIDs.insert(transaction.productID)
            } else {
                self.purchasedProductIDs.remove(transaction.productID)
            }
        }
    }
    
    private func observeTransactionUpdates() -> Task<Void, Never> {
            Task(priority: .background) {
                for await verificationResult in Transaction.updates {
                    // Using verificationResult directly would be better
                    // but this way works for this tutorial
                    await self.updatePurchasedProducts()
                }
            }
        }

    func calculateWeeklyPrice(subscriptionLength: String, price: Decimal) -> String {
        
        let priceInDouble = NSDecimalNumber(decimal: price).doubleValue
        
        switch subscriptionLength {
        case ProductName.oneMonth.rawValue:
            return "\(floor(priceInDouble / 4 * 100) / 100)"
        case ProductName.oneYear.rawValue:
            return "\(floor(priceInDouble / 12 / 4 * 100) / 100)"
        case ProductName.threeMonth.rawValue:
            return "\(floor(priceInDouble / 3 / 4 * 100) / 100)"
        default:
            return "Error"
        }
    }
}


struct ProductDAO: Codable {
    let href: String
    let id: String
    let type: String
    let attributes: Attributes
}

struct Attributes: Codable {
    let subscriptionFamilyRank: Int
}
