//
//  ProfileView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-03-30.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var viewModel: ProfileViewModel
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 70, height: 70)
                    .foregroundColor(Color("MainColor"))
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
    }
}

#Preview {
    ProfileView()
        .environmentObject(ProfileViewModel())
}
