//
//  SideMenuView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-04-10.
//

import SwiftUI

struct SideMenuView: View {
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    
    @Binding var showPaywall: Bool
    
    var body: some View {
        
        VStack (alignment: .leading) {
            
            ProfileView()
                .padding(.top, 10)
                .environmentObject(profileViewModel)
            
            PremiumStatusView(showPaywall: $showPaywall)
                .padding(.top, 10)
                .environmentObject(profileViewModel)

            
            HStack(alignment: .center) {
                NavigationLink {
                    AccountsCenterView()
                } label: {
                    Image(systemName: "person")
                        .foregroundColor(.black)
                        .imageScale(.large)
                    Text("Accounts Center")
                        .font(.subheadline)
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: "chevron.forward")
                        .foregroundColor(.gray)
                        .imageScale(.small)
                }
            }
            .padding(.top, 20)
            
            Spacer()
            
            HStack(alignment: .center) {
                NavigationLink {
                    SettingsView()
                } label: {
                    Image(systemName: "gearshape")
                        .foregroundColor(.black)
                        .imageScale(.large)
                    Text("Settings")
                        .font(.subheadline)
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: "chevron.forward")
                        .foregroundColor(.gray)
                        .imageScale(.small)
                }
            }
            HStack(alignment: .center) {
                NavigationLink {
                } label: {
                    Image(systemName: "questionmark.bubble")
                        .foregroundColor(.black)
                        .imageScale(.large)
                    Text("Help and Feedback")
                        .font(.subheadline)
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: "chevron.forward")
                        .foregroundColor(.gray)
                        .imageScale(.small)
                }
            }
            .padding(.top, 10)
            .padding(.bottom, 20)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
    }
}

#Preview {
    NavigationView {
        SideMenuView(showPaywall: .constant(false))
            .environmentObject(ProfileViewModel())
    }
}
