//
//  PaywallViewModel.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-04-16.
//

import Foundation
import StoreKit

@MainActor
final class PaywallViewModel: ObservableObject {
    
    @Published var products: [Product] = []
    @Published var selectedProduct: Product? = nil
    
    let productIdentifiers = [ProductIdentifier.gold1Month.rawValue, ProductIdentifier.gold1Year.rawValue, ProductIdentifier.gold3Month.rawValue]
    
    
    func loadProducts() async throws {
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
        self.selectedProduct = self.products[1]
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
