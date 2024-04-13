//
//  ProfileView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-03-30.
//

import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    func togglePremiumStatus() {
        guard let user else { return }
        let currentValue = user.isPremium ?? false
        Task {
            try await UserManager.shared.updateUserPremiumStatus(userId: user.userId, isPremium: !currentValue)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    
    }
}

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Image(viewModel.user?.gender == Gender.male ? "profile_picture_man" : "profile_picture_woman")
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
