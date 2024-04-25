//
//  CommonButtonView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-03-22.
//

import SwiftUI

struct CommonBackButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            self.action()
        }) {
            HStack {
                Image(systemName: "chevron.backward")
                    .resizable()
                    .frame(width: 12, height: 20)
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.black)
                    .fontWeight(.semibold)
                Text("Back")
                    .foregroundColor(.black)
            }
        }
        .padding(.horizontal, 10)
    }
}

#Preview {
    CommonBackButton(action: {})
}
