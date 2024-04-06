//
//  AuthenticationManager.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-03-11.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoUrl: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}

enum AuthProviderOption: String {
    case email = "password"
    case google = "google.com"
    case apple = "apple.com"
}

final class AuthenticationManager {
    static let shared = AuthenticationManager()
    
    private init() { }
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        return AuthDataResultModel(user: user)
    }
    
    func getProviders() throws -> [AuthProviderOption] {
        guard let providerData = Auth.auth().currentUser?.providerData else {
            throw URLError(.badServerResponse)
        }
        
        var providers: [AuthProviderOption] = []
        
        for provider in providerData {
            if let option = AuthProviderOption(rawValue: provider.providerID) {
                providers.append(option)
            } else {
                assertionFailure("Provider option not found: \(provider.providerID)")
            }
        }
        
        return providers
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}


// MARK: SIGN IN EMAIL
extension AuthenticationManager {
    
    @discardableResult
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        do {
            let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
            return AuthDataResultModel(user: authDataResult.user)
        } catch let error as NSError {
            print("An error occurred while attempting to sign up the user")
            if let firebaseAuthError = AuthErrorCode(_bridgedNSError: error) {
                switch firebaseAuthError.code {
                case .emailAlreadyInUse:
                    print("Error: \(AuthenticationError.emailAlreadyInUse.errorDescription)")
                    throw AuthenticationError.emailAlreadyInUse
                case .weakPassword:
                    print("Error: \(AuthenticationError.weakPassword.errorDescription)")
                    throw AuthenticationError.weakPassword
                case .invalidEmail:
                    print("Error: \(AuthenticationError.invalidEmail.errorDescription)")
                    throw AuthenticationError.invalidEmail
                default:
                    print(firebaseAuthError)
                }
            }
            throw error
        }
        
    }
    
    @discardableResult
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
        do {
            let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
            return AuthDataResultModel(user: authDataResult.user)
        } catch let error as NSError {
            print("An error occurred while attempting to sign in the user")
            if let firebaseAuthError = AuthErrorCode(_bridgedNSError: error) {
                switch firebaseAuthError.code {
                case .invalidCredential:
                    print("Error: \(AuthenticationError.invalidCredential.errorDescription)")
                    throw AuthenticationError.invalidCredential
                case .invalidEmail:
                    print("Error: \(AuthenticationError.emailAlreadyInUse.errorDescription)")
                    throw AuthenticationError.emailAlreadyInUse
                default:
                    print(firebaseAuthError)
                }
            }
            throw error
        }
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
}

// MARK: SIGN IN SSO
extension AuthenticationManager {
    
    @discardableResult
    func signInWithGoogle(tokens: GoogleSignInResultModel) async throws -> AuthDataResultModel {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        
        return try await signIn(credential: credential)
    }
    
    @discardableResult
    func signInWithApple(tokens: SignInWithAppleResult) async throws -> AuthDataResultModel {
        let credential = OAuthProvider.appleCredential(withIDToken: tokens.token,
                                                       rawNonce: tokens.nonce,
                                                       fullName: tokens.appleIdCredential.fullName)
        return try await signIn(credential: credential)
    }
    
    func signIn(credential: AuthCredential) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }
}
