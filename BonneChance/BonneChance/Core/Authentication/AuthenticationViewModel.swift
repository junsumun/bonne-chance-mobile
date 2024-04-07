//
//  AuthenticationViewModel.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-03-30.
//

import Foundation

@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    @Published var didSignInWithApple: Bool = false
    @Published var showSignInFailAlert: Bool = false
    
    let signInAppleHelper = SignInAppleHelper()
    
    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        
        let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        do {
            try await UserManager.shared.getUser(userId: authDataResult.uid)
        } catch {
            try AuthenticationManager.shared.signOut()
            self.showSignInFailAlert = true
            throw error
        }
    }
    
    func signUpGoogle(firstName: String?, lastName: String?, gender: Gender?, birthdate: String?) async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        
        let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        
        let userExists = try await UserManager.shared.userExists(userId: authDataResult.uid)
        if !userExists {
            try await UserManager.shared.createNewUser(user: DBUser(
                userId: authDataResult.uid,
                email: authDataResult.email,
                firstName: firstName,
                lastName: lastName,
                gender: gender,
                birthdate: birthdate
            ))
        }
    }
    
    func signInApple() async throws {
        signInAppleHelper.startSignInWithAppleFlow { result in
            switch result {
            case .success(let signInAppleResult):
                Task {
                    do {
                        let authDataResult = try await AuthenticationManager.shared.signInWithApple(tokens: signInAppleResult)
                        
                        let userExists = try await UserManager.shared.userExists(userId: authDataResult.uid)
                        if !userExists {
                            try AuthenticationManager.shared.signOut()
                            self.showSignInFailAlert = true
                            self.didSignInWithApple = false
                        } else {
                            self.didSignInWithApple = true
                        }
                        
                        
                    } catch {
                        
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func signUpApple(firstName: String?, lastName: String?, gender: Gender?, birthdate: String?) async throws {
        signInAppleHelper.startSignInWithAppleFlow { result in
            switch result {
            case.success(let signInAppleResult):
                Task {
                    do {
                        let authDataResult = try await AuthenticationManager.shared.signInWithApple(tokens: signInAppleResult)
                        
                        let userExists = try await UserManager.shared.userExists(userId: authDataResult.uid)
                        if !userExists {
                            try await UserManager.shared.createNewUser(user: DBUser(
                                userId: authDataResult.uid,
                                email: authDataResult.email,
                                firstName: firstName,
                                lastName: lastName,
                                gender: gender,
                                birthdate: birthdate
                            ))
                        }
                        self.didSignInWithApple = true
                    } catch {
                
                    }
                }
            case.failure(let error):
                print(error)
            }
        }
    }
}
