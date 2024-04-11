//
//  UserManager.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-03-30.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBUser: Codable {
    let userId: String
    let email: String?
    let firstName: String?
    let lastName: String?
    let gender: Gender?
    let birthdate: String?
    let photoUrl: String?
    let dateCreated: Date?
    let isPremium: Bool?
    
    init(userId: String,
         email: String? = nil,
         firstName: String? = nil,
         lastName: String? = nil,
         gender: Gender? = nil,
         birthdate: String? = nil,
         photoUrl: String? = nil) {
        self.userId = userId
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.gender = gender
        self.birthdate = birthdate
        self.photoUrl = photoUrl
        self.dateCreated = Date()
        self.isPremium = false
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
        case isPremium = "is_premium"
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
        self.isPremium = try container.decodeIfPresent(Bool.self, forKey: .isPremium)
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
        try container.encodeIfPresent(self.isPremium, forKey: .isPremium)
    }
}

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
    
    func updateUserPremiumStatus(userId: String, isPremium: Bool) async throws {
        let data: [String: Any] = [
            DBUser.CodingKeys.isPremium.rawValue : isPremium
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
}
