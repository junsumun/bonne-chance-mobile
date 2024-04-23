//
//  Product.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-04-17.
//

import Foundation

enum ProductIdentifier: String, Codable {
    case gold1Month = "bonnechance_gold_1month_9.99"
    case gold1Year = "bonnechance_gold_1year_59.99"
    case gold3Month = "bonnechance_gold_3month_19.99"
}

let productIdentifiers = [
    ProductIdentifier.gold1Month.rawValue,
    ProductIdentifier.gold1Year.rawValue,
    ProductIdentifier.gold3Month.rawValue
]

enum SubscriptionFamily: String, Codable {
    case gold = "gold"
}

func getSubscriptionFamily(productId: String) -> Premium {
    switch productId {
        
    case ProductIdentifier.gold1Month.rawValue:
        return Premium.gold
        
    case ProductIdentifier.gold1Year.rawValue:
        return Premium.gold
        
    case ProductIdentifier.gold3Month.rawValue:
        return Premium.gold
        
    default:
        return Premium.gold
    }
    
}
