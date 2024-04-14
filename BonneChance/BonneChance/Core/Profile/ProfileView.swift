//
//  ProfileView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-03-30.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Image(viewModel.user?.gender == Gender.male ? "man_profile" : "woman_profile")
                    .resizable()
                    .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                    .frame(width: 95, height: 95)
                    .foregroundColor(.purple)
                    // purple Hex code: #7E499D
                HStack {
                    Text(viewModel.user?.firstName ?? "Full")
                    Text(viewModel.user?.lastName ?? "Name")
                }
                .font(.title2.bold())
                
                HStack {
                    Image(systemName: "birthday.cake")
                        .foregroundColor(.gray)
                        .imageScale(.small)
                    HStack {
                        Text(viewModel.user?.birthdate ?? "Birthdate")
                    }
                    .font(.subheadline)
                }
            }
            Spacer()
        }
        .task {
            try? await viewModel.loadCurrentUser()
        }
    }
}

#Preview {
    ProfileView()
}
