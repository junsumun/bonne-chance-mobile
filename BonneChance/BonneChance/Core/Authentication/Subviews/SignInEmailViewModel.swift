//
//  SignInEmailViewModel.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-03-30.
//

import Foundation
import SwiftUI

@MainActor
final class SignInEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    @AppStorage("firstName") var currentUserFirstName: String?
    @AppStorage("lastName") var currentUserLastName: String?
    @AppStorage("gender") var currentUserGender: Gender?
    @AppStorage("birthdate") var currentUserBirthdate: String?
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("Error: \(AuthenticationError.invalidUserInput.errorDescription)")
            throw AuthenticationError.invalidUserInput
        }
        
        let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
        
        let user = DBUser(
            userId: authDataResult.uid,
            email: authDataResult.email,
            firstName: currentUserFirstName,
            lastName: currentUserLastName,
            gender: currentUserGender,
            birthdate: currentUserBirthdate,
            photoUrl: authDataResult.photoUrl
        )
        
        try await UserManager.shared.createNewUser(user: user)
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("Error: \(AuthenticationError.invalidUserInput.errorDescription)")
            throw AuthenticationError.invalidUserInput
        }
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }
}
