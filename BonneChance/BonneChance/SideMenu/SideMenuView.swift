//
//  SideMenuView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-04-10.
//

import SwiftUI

struct SideMenuView: View {
    
    @StateObject private var profileViewModel = ProfileViewModel()
    
    var body: some View {
        
        VStack (alignment: .leading) {
            HStack {
                Image(systemName: "person")
                    .foregroundColor(.gray)
                    .imageScale(.large)
                HStack {
                    Text(profileViewModel.user?.firstName ?? "First name")
                    Text(profileViewModel.user?.lastName ?? "Last name")
                }
                .font(.headline)
                .foregroundColor(.gray)
            }
            .padding(.top, 30)
            HStack {
                Image(systemName: "birthday.cake")
                    .foregroundColor(.gray)
                    .imageScale(.large)
                HStack {
                    Text(profileViewModel.user?.birthdate ?? "Birthdate")
                }
                .font(.headline)
                .foregroundColor(.gray)
            }
            .padding(.top, 30)
            HStack {
                NavigationLink {
                    SettingsView()
                } label: {
                    Image(systemName: "gear")
                        .foregroundColor(.gray)
                        .imageScale(.large)
                    Text("Settings")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
            }
            .padding(.top, 30)
            
            Button {
                profileViewModel.togglePremiumStatus()
            } label: {
                Text("User is premium: \((profileViewModel.user?.isPremium ?? false).description.capitalized)")
            }
            Spacer()
            
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .task {
            try? await profileViewModel.loadCurrentUser()
        }
        
    }
}

#Preview {
    SideMenuView()
}
