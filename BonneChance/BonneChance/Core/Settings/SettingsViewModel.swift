//
//  SettingsViewModel.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-03-30.
//

import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    
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
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
}
