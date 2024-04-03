//
//  SettingsView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-03-12.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    
    @AppStorage("signed_in") var currentUserSignedIn: Bool?
    
    var body: some View {
        List {
            Button("Sign out") {
                Task {
                    do {
                        try viewModel.signOut()
                        currentUserSignedIn = false
                    } catch {
                        print(error)
                    }
                }
            }
            
            if viewModel.authProviders.contains(.email) {
                emailSection
            }
        }
        .onAppear {
            viewModel.loadAuthProviders()
        }
        .navigationBarTitle("Settings")
    }
}

#Preview {
    SettingsView()
}


extension SettingsView {
    private var emailSection: some View {
        Section {
            Button("Reset password") {
                Task {
                    do {
                        try await viewModel.resetPassword()
                        print("Password reset")
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}
