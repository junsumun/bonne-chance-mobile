//
//  LogoutButtonView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-04-11.
//

import SwiftUI

struct LogoutButtonView: View {
    
    @EnvironmentObject private var accountsCenterViewModel: AccountsCenterViewModel
    
    @State private var showAlert = false
    
    @AppStorage("signed_in") var currentUserSignedIn: Bool?
    
    var body: some View {
        Button {
            showAlert = true
        } label: {
            HStack(alignment: .center) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundColor(.red)
                Text("Sign out")
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
                title: Text("Sign out"),
                message: Text("Are you sure you want to sign out?"),
                primaryButton: .destructive(Text("Sign out")) {
                    Task {
                        do {
                            try accountsCenterViewModel.signOut()
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
    LogoutButtonView()
        .environmentObject(AccountsCenterViewModel())
}
