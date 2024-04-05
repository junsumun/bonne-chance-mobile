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
    
    @AppStorage("signed_in") var currentUserSignedIn: Bool?
    
    var body: some View {
        List {
            if let user = viewModel.user {
                Text("UserId: \(user.userId)")
                Text("Email: \(user.email ?? "email address")")
                Text("First name: \(user.firstName ?? "first name")")
                Text("Last name: \(user.lastName ?? "last name")")
                Text("Gender: \(user.gender?.rawValue ?? "gender")")
                Text("Birthdate: \(user.birthdate ?? "birthdate")")
                Button {
                 viewModel.togglePremiumStatus()
                    
                } label: {
                    Text("User is premium: \((user.isPremium ?? false).description.capitalized)")
                }
            }
        }
        .task {
            try? await viewModel.loadCurrentUser()
        }
        .navigationTitle("Profile")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    SettingsView()
                } label: {
                    Image(systemName: "gear")
                        .font(.headline)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
}
