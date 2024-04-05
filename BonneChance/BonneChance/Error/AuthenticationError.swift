//
//  AuthenticationError.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-04-04.
//

import Foundation

enum AuthenticationError: Error {
    case invalidUserInput
    case invalidaCredential
    case weakPassword
    case emailAlreadyInUse
    case invalidEmail
    
    var errorDescription: String {
        switch self {
        case .invalidUserInput:
            return "No email or password provided"
        case .invalidaCredential:
            return "There is no existing account found for the provided email address"
        case .weakPassword:
            return "The password must be 6 characters long or more"
        case .emailAlreadyInUse:
            return "The email address is already in use by another account"
        case .invalidEmail:
            return "The email address is badly formatted"
        }
    }
}

