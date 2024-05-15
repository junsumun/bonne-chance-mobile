//
//  AccountView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-04-11.
//

import SwiftUI

struct AccountsCenterView: View {
    
    @StateObject private var viewModel = AccountsCenterViewModel()
    
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    
    var body: some View {
        List {
            Section("PROFILE") {
                ProfileButtonView()
                    .environmentObject(profileViewModel)
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
    NavigationStack {
        AccountsCenterView()
            .environmentObject(ProfileViewModel())
    }
}
