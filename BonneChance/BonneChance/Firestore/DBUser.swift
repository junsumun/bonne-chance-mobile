//
//  DBUser.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-04-12.
//

import Foundation


struct Subscription: Codable {
    let id: UInt64
    let purchaseDate: Date?
    let expirationDate: Date?
    let productId: String?
    let subscriptionFamily: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case purchaseDate = "purchase_date"
        case expirationDate = "expiration_date"
        case productId = "product_id"
        case subscriptionFamily = "subscription_family"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UInt64.self, forKey: .id)
        self.purchaseDate = try container.decodeIfPresent(Date.self, forKey: .purchaseDate)
        self.expirationDate = try container.decodeIfPresent(Date.self, forKey: .expirationDate)
        self.productId = try container.decodeIfPresent(String.self, forKey: .productId)
        self.subscriptionFamily = try container.decodeIfPresent(String.self, forKey: .subscriptionFamily)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encodeIfPresent(self.purchaseDate, forKey: .purchaseDate)
        try container.encodeIfPresent(self.expirationDate, forKey: .expirationDate)
        try container.encodeIfPresent(self.productId, forKey: .productId)
        try container.encodeIfPresent(self.subscriptionFamily, forKey: .subscriptionFamily)
    }
}

struct DBUser: Codable {
    let userId: String
    let email: String?
    let firstName: String?
    let lastName: String?
    let gender: Gender?
    let birthdate: String?
    let photoUrl: String?
    let dateCreated: Date?
    let premiumType: Premium?
    let subscription: Subscription?
    
    init(userId: String,
         email: String? = nil,
         firstName: String? = nil,
         lastName: String? = nil,
         gender: Gender? = nil,
         birthdate: String? = nil,
         photoUrl: String? = nil,
         premiumType: Premium? = nil,
         subscription: Subscription? = nil
    ) {
        self.userId = userId
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.gender = gender
        self.birthdate = birthdate
        self.photoUrl = photoUrl
        self.dateCreated = Date()
        self.premiumType = Premium.basic
        self.subscription = subscription
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email = "email"
        case firstName = "first_name"
        case lastName = "last_name"
        case gender = "gender"
        case birthdate = "birthdate"
        case photoUrl = "photo_url"
        case dateCreated = "date_created"
        case premiumType = "premium_type"
        case transaction = "transaction"
        case subscription = "subscription"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        self.gender = try container.decodeIfPresent(Gender.self, forKey: .gender)
        self.birthdate = try container.decodeIfPresent(String.self, forKey: .birthdate)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.premiumType = try container.decodeIfPresent(Premium.self, forKey: .premiumType)
        self.subscription = try container.decodeIfPresent(Subscription.self, forKey: .subscription)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.firstName, forKey: .firstName)
        try container.encodeIfPresent(self.lastName, forKey: .lastName)
        try container.encodeIfPresent(self.gender, forKey: .gender)
        try container.encodeIfPresent(self.birthdate, forKey: .birthdate)
        try container.encodeIfPresent(self.photoUrl, forKey: .photoUrl)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.premiumType, forKey: .premiumType)
        try container.encodeIfPresent(self.subscription, forKey: .subscription)
    }
}
