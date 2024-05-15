//
//  ProfileButtonView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-04-11.
//

import SwiftUI

struct ProfileButtonView: View {
    
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    
    var body: some View {
        NavigationLink {
            UpdateProfileView()
                .environmentObject(profileViewModel)
        } label: {
            HStack(alignment: .center) {
                Image(systemName: "person")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundColor(.black)
                Text("Update profile")
                    .font(.subheadline)
                    .foregroundColor(.black)
//                Spacer()
//                Image(systemName: "chevron.forward")
//                    .imageScale(.small)
//                    .foregroundColor(.gray)
            }
        }
//        Button {
//            Task {
//            }
//        } label: {
//            HStack(alignment: .center) {
//                Image(systemName: "person")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 20, height: 20)
//                    .foregroundColor(.black)
//                Text("Update profile")
//                    .font(.subheadline)
//                    .foregroundColor(.black)
//                Spacer()
//                Image(systemName: "chevron.forward")
//                    .imageScale(.small)
//                    .foregroundColor(.gray)
//            }
//        }
    }
}

#Preview {
    ProfileButtonView()
        .environmentObject(ProfileViewModel())
}
