//
//  PaywallViewModel.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-04-16.
//

import Foundation
import StoreKit

enum PurchaseManagerError: LocalizedError {
    case failedVerification
    case system(Error)
    
    var errorDescription: String? {
        switch self {
        case .failedVerification:
            return "User transaction verification failed"
        case .system(let err):
            return err.localizedDescription
        }
    }
}

enum PurchaseManagerAction: Equatable {
    case successful
    case failed(PurchaseManagerError)
    
    static func == (lhs: PurchaseManagerAction, rhs: PurchaseManagerAction) -> Bool {
        switch (lhs, rhs) {
        case (.successful, .successful):
            return true
        case (let .failed(lhsErr), let .failed(rhsErr)):
            return lhsErr.localizedDescription == rhsErr.localizedDescription
        default:
            return false
        }
    }
}

typealias PurchaseResult = Product.PurchaseResult
typealias TransactionListener = Task<Void, Error>

@MainActor
final class PurchaseManager: ObservableObject {
    
    @Published private(set) var products = [Product]()
    @Published private(set) var action: PurchaseManagerAction? {
        didSet {
            switch action {
            case .failed:
                hasError = true
            default:
                hasError = false
            }
        }
    }
    
    @Published private(set) var purchasedProductIDs = Set<String>()
    
    @Published var hasError = false
    
    var error: PurchaseManagerError? {
        switch action {
        case .failed(let err):
            return err
        default:
            return nil
        }
    }
    
    private var transactionListener: TransactionListener?
    
    init() {
        
        transactionListener = configureTransactionListener()
        
        Task { [weak self] in
            await self?.retrieveProducts()
        }
        
        Task {
            await self.loadPurchasedProducts()
        }
        
    }
    
    deinit {
        transactionListener?.cancel()
    }
    
    var hasUnlockedGold: Bool {
        return !self.purchasedProductIDs.isEmpty
    }
    
    func purchase(_ product: Product) async {
        
        do {
            let result = try await product.purchase()
            
            try await handlePurchase(from: result)
            
        } catch {
            action = .failed(.system(error))
            print(error)
        }
    }
    
    func reset() {
        action = nil
    }
    
    func update() async {
        await loadPurchasedProducts()
    }
}

private extension PurchaseManager {
    
    func retrieveProducts() async {
        
        do {
            let decoder = JSONDecoder()
            let products = try await Product.products(for: productIdentifiers).sorted { p1, p2 in
                let p1DAO = try decoder.decode(ProductDAO.self, from: p1.jsonRepresentation)
                let p2DAO = try decoder.decode(ProductDAO.self, from: p2.jsonRepresentation)
                
                return p1DAO.attributes.subscriptionFamilyRank < p2DAO.attributes.subscriptionFamilyRank
            }
            
            self.products = products
        
        } catch {
            action = .failed(.system(error))
            print(error)
        }
    }
    
    func handlePurchase(from result: PurchaseResult) async throws {
        
        switch result {
        case .success(let verification):
            print("Purchase was a success, verifying their purchase")
            
            let transaction = try checkVerified(verification)
            
            await loadPurchasedProducts()
            
            action = .successful
            
            await transaction.finish()
            
        case .pending:
            print("The user needs to complete some action on their account before they can complete purchase")
            
        case .userCancelled:
            print("The user canceled before their transaction started")
            
        default:
            break
        }
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            print("The verification of the user failed")
            throw PurchaseManagerError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
    
    func configureTransactionListener() -> TransactionListener {
        
        Task.detached(priority: .background) { @MainActor [weak self] in
            do {
                for await result in Transaction.updates {
                    
                    let transaction = try self?.checkVerified(result)
                    
                    self?.action = .successful
                    
                    await self?.loadPurchasedProducts()
                    
                    await transaction?.finish()
                }
            } catch {
                self?.action = .failed(.system(error))
                print(error)
            }
        }
    }
    
    func loadPurchasedProducts() async {
        
        purchasedProductIDs.removeAll()
        
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }
            if transaction.revocationDate == nil && transaction.expirationDate! > Date() {
                self.purchasedProductIDs.insert(transaction.productID)
                await updateSubscription(transaction: transaction)
            } else {
                self.purchasedProductIDs.remove(transaction.productID)
            }
        }
        if purchasedProductIDs.isEmpty {
            await removeSubscription()
        }
    }
    
    func removeSubscription() async {
        do {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            let user = try await UserManager.shared.getUser(userId: authDataResult.uid)
            
            let subscription = Subscription(
                id: UInt64(),
                subscriptionFamily: Premium.basic
            )
            
            try await UserManager.shared.updateUserSubscription(userId: user.userId, subscription: subscription)
        } catch {
            print(error)
        }
    }
    func updateSubscription(transaction: Transaction) async {
        do {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            let user = try await UserManager.shared.getUser(userId: authDataResult.uid)
            
            let subscription = Subscription(
                id: transaction.id,
                purchaseDate: transaction.purchaseDate,
                originalPurchaseDate: transaction.originalPurchaseDate,
                expirationDate: transaction.expirationDate,
                productId: transaction.productID,
                subscriptionFamily: getSubscriptionFamily(productId: transaction.productID)
            )
            
            try await UserManager.shared.updateUserSubscription(userId: user.userId, subscription: subscription)
        } catch {
            print(error)
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
