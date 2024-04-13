//
//  AccountView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-04-11.
//

import SwiftUI

struct AccountsCenterView: View {
    
    @StateObject private var viewModel = AccountsCenterViewModel()
    
    var body: some View {
        List {
            Section("PROFILE") {
                ProfileButtonView()
            }
            
            Section("MANAGE ACCOUNT") {
                LogoutButtonView()
                
                if viewModel.authProviders.contains(.email) {
                    ResetPasswordButtonView()
                }
                DeleteAccountButtonView()
            }
        }
        .onAppear {
            viewModel.loadAuthProviders()
        }
        .navigationBarTitle("Accounts Center")
    }
}

#Preview {
    NavigationView {
        AccountsCenterView()
    }
}
