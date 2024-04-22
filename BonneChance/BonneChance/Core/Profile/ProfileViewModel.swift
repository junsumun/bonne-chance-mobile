//
//  ProfileViewModel.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-04-12.
//

import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    
    init() {
        Task { [weak self] in
            await self?.loadCurrentUser()
        }
        
    }
    
    func loadCurrentUser() async {
        do {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
        } catch {
            print(error)
        }
        
    }
    
    func togglePremiumStatus() {
        guard let user else { return }
        let currentValue = user.premiumType ?? Premium.basic
        Task {
            try await UserManager.shared.updateUserPremiumStatus(userId: user.userId, premiumType: currentValue == Premium.basic ? Premium.gold : Premium.basic)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
}
