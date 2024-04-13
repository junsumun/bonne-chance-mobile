//
//  DeleteAccountButtonView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-04-11.
//

import SwiftUI

struct DeleteAccountButtonView: View {
    
    var body: some View {
        Button {
            Task {
            }
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
    }
}

#Preview {
    DeleteAccountButtonView()
}
