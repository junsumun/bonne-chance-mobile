//
//  SideMenuView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-04-10.
//

import SwiftUI

struct SideMenuView: View {
    
    var body: some View {
        
        VStack (alignment: .leading) {
            
            ProfileView()
                .padding(.top, 30)
            
            
//            Button {
//                profileViewModel.togglePremiumStatus()
//            } label: {
//                Text("User is premium: \((profileViewModel.user?.isPremium ?? false).description.capitalized)")
//            }
            
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
            .padding(.top, 50)
            
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
            .padding(.top, 15)
            HStack(alignment: .center) {
                NavigationLink {
                    SettingsView()
                } label: {
                    Image(systemName: "questionmark.bubble")
                        .foregroundColor(.black)
                        .imageScale(.large)
                    Text("Help")
                        .font(.subheadline)
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: "chevron.forward")
                        .foregroundColor(.gray)
                        .imageScale(.small)
                }
            }
            .padding(.top, 15)
            .padding(.bottom, 30)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
    }
}

#Preview {
    NavigationView {
        SideMenuView()
    }
    .tint(.purple)
}
