//
//  SettingsViewModel.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-03-30.
//

import Foundation

@MainActor
final class AccountsCenterViewModel: ObservableObject {
    
    @Published var authProviders: [AuthProviderOption] = []
    
    func loadAuthProviders() {
        do {
            let providers = try AuthenticationManager.shared.getProviders()
            authProviders = providers
        } catch {
            print("Error occured while getting providers \(error)")
        }
    }
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func deleteAccount() async throws {
        try await AuthenticationManager.shared.delete()
    }
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
}
