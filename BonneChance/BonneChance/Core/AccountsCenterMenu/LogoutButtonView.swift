//
//  LogoutButtonView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-04-11.
//

import SwiftUI

struct LogoutButtonView: View {
    
    @StateObject private var accountsCenterViewModel = AccountsCenterViewModel()
    
    @AppStorage("signed_in") var currentUserSignedIn: Bool?
    
    var body: some View {
        Button {
            Task {
                do {
                    try accountsCenterViewModel.signOut()
                    currentUserSignedIn = false
                    print("Completed signout \(currentUserSignedIn)")
                } catch {
                    print(error)
                }
            }
        } label: {
            HStack(alignment: .center) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundColor(.black)
                Text("Log out")
                    .font(.subheadline)
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: "chevron.forward")
                    .imageScale(.small)
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    LogoutButtonView()
}
