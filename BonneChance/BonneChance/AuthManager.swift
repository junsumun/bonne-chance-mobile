//
//  AuthManager.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-03-11.
//

import AuthenticationServices
import FirebaseAuth
import FirebaseCore

enum AuthState {
    case authenticated
    case signedIn
    case signedOut
}

@MainActor
class AuthManager: ObservableObject {
    @Published var user: User?
    @Published var authState = AuthState.signedOut
}
