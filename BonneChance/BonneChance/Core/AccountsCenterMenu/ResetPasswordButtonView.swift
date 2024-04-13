//
//  ResetPasswordButtonView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-04-11.
//

import SwiftUI

struct ResetPasswordButtonView: View {
    
//    @StateObject private var accountsCenterViewModel = AccountsCenterViewModel()
//    
//    @AppStorage("signed_in") var currentUserSignedIn: Bool?
    
    var body: some View {
        Button {
            Task {
//                do {
//                    try await accountsCenterViewModel.resetPassword()
//                } catch {
//                    print(error)
//                }
            }
        } label: {
            HStack(alignment: .center) {
                Image(systemName: "key")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundColor(.black)
                Text("Reset password")
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
    ResetPasswordButtonView()
}
