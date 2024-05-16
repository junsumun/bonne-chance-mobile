//
//  DeleteAccountButtonView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-04-11.
//

import SwiftUI

struct DeleteAccountButtonView: View {
    
    @EnvironmentObject private var accountsCenterViewModel: AccountsCenterViewModel
    
    @State private var showAlert = false
    
    @AppStorage("signed_in") var currentUserSignedIn: Bool?
    
    var body: some View {
        Button {
            showAlert = true
        } label: {
            HStack(alignment: .center) {
                Image(systemName: "trash")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundColor(.red)
                Text("Delete account")
                    .font(.subheadline)
                    .foregroundColor(.red)
                Spacer()
                Image(systemName: "chevron.forward")
                    .imageScale(.small)
                    .foregroundColor(.red)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Delete account"),
                message: Text("Are you sure you want to delete your account? This action is irreversible."),
                primaryButton: .destructive(Text("Delete")) {
                    Task {
                        do {
                            try await accountsCenterViewModel.deleteAccount()
                            currentUserSignedIn = false
                        } catch {
                            print(error)
                        }
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
}

#Preview {
    DeleteAccountButtonView()
}
