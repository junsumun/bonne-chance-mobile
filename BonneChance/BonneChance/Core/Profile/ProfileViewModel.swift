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
    
    func updateProfile(firstName: String, lastName: String, gender: Gender, birthdate: String) async {
        guard let user = user else {
            return
        }
        
        do {
            try await UserManager.shared.updateUserProfile(userId: user.userId,
                                                           firstName: firstName,
                                                           lastName: lastName,
                                                           gender: gender,
                                                           birthdate: birthdate)
        } catch {
            print(error)
        }
    }

}
