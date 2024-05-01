//
//  FortuneManager.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-04-23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class FortuneManager {
    
    static let shared = FortuneManager()
    
    private init() { }
    
    private let fortuneCollection = Firestore.firestore().collection("fortunes_eng")
    
    
    func countFortunes() async throws -> Int {
        let countQuery = fortuneCollection.count
        do {
            let snapshot = try await countQuery.getAggregation(source: .server)
            return snapshot.count.intValue
        } catch {
            print(error)
            throw error
        }
    }
    
    func getFortune() async throws -> FortuneData {
        do {
            let document = try await fortuneCollection.document("0").getDocument()
            if document.exists {
                let fortuneData = try document.data(as: FortuneData.self)
                return fortuneData
            } else {
                throw URLError(.badServerResponse)
            }
        } catch {
            print(error)
            throw error
        }
        
    }
    
    
}
