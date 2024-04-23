//
//  UserManager.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-03-30.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class UserManager {

    static let shared = UserManager()
    
    private init() { }
    
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) async throws -> DocumentReference {
        userCollection.document(userId)
    }
    
    func createNewUser(user: DBUser) async throws {
        try await userDocument(userId: user.userId).setData(from: user, merge: false)
    }
    
    @discardableResult
    func getUser(userId: String) async throws -> DBUser {
        do {
            let document = try await userDocument(userId: userId).getDocument()
            if document.exists {
                let dbUser = try document.data(as: DBUser.self)
                return dbUser
            } else {
                throw AuthenticationError.invalidCredential
            }
        } catch {
            throw error
        }
    }
    
    func userExists(userId: String) async throws -> Bool {
        do {
            let document = try await userDocument(userId: userId).getDocument()
            if !document.exists {
                return false;
            } else {
                return true;
            }
        } catch {
            throw error
        }
    }
    
    func updateUserPremiumStatus(user: DBUser) async throws {
        try await userDocument(userId: user.userId).setData(from: user, merge: true)
    }
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        return encoder
    }()
    
    func updateUserSubscription(userId: String, subscription: Subscription) async throws {
        guard let data = try? encoder.encode(subscription) else {
            throw URLError(.badURL)
        }
        
        let dict: [String: Any] = [
            DBUser.CodingKeys.subscription.rawValue : data
        ]
        
        try await userDocument(userId: userId).updateData(dict)
        try await updateUserPremiumStatus(userId: userId, premiumType: subscription.subscriptionFamily ?? Premium.basic)
    }
    
    func updateUserPremiumStatus(userId: String, premiumType: Premium) async throws {
        let data: [String: Any] = [
            DBUser.CodingKeys.premiumType.rawValue : premiumType.rawValue
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
}
