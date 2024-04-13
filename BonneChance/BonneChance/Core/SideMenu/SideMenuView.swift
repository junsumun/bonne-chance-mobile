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
                Spacer()
                VStack {
                    Image(profileViewModel.user?.gender == Gender.male ? "profile_picture_man" : "profile_picture_woman")
                        .resizable()
                        .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                        .frame(width: 95, height: 95)
                        .foregroundColor(.purple)
                        // purple Hex code: #7E499D
                    HStack {
                        Text(profileViewModel.user?.firstName ?? "Full")
                        Text(profileViewModel.user?.lastName ?? "Name")
                    }
                    .font(.title2.bold())
                    
                    HStack {
                        Image(systemName: "birthday.cake")
                            .foregroundColor(.gray)
                            .imageScale(.small)
                        HStack {
                            Text(profileViewModel.user?.birthdate ?? "Birthdate")
                        }
                        .font(.subheadline)
                    }
                }
                Spacer()
            }
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
        .task {
            try? await profileViewModel.loadCurrentUser()
        }
        
    }
}

#Preview {
    NavigationView {
        SideMenuView()
    }
    .tint(.purple)
}
