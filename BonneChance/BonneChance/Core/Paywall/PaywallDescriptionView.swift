//
//  PaywallDescriptionView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-04-22.
//

import SwiftUI

struct PaywallDescriptionView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Unlock more fortunes")
                    .font(.title)
                    .bold()
                    .foregroundColor(.purple)
                Spacer()
            }
            .padding(.bottom, 20)
            
            
            HStack {
                Image(systemName: "checkmark")
                    .foregroundColor(.purple)
                Text("Daily Overall Fortune")
                    .font(.title3)
                    .bold()
            }
            .padding(.bottom, 10)
            HStack {
                Image(systemName: "checkmark")
                    .foregroundColor(.purple)
                Text("Daily Love Fortune")
                    .font(.title3)
                    .bold()
                
            }
            .padding(.bottom, 10)
            HStack {
                Image(systemName: "checkmark")
                    .foregroundColor(.purple)
                Text("Daily Money Fortune")
                    .font(.title3)
                    .bold()
            }
            .padding(.bottom, 10)
            HStack {
                Image(systemName: "checkmark")
                    .foregroundColor(.purple)
                Text("Daily Career Fortune")
                    .font(.title3)
                    .bold()
            }
            .padding(.bottom, 10)
            HStack {
                Image(systemName: "checkmark")
                    .foregroundColor(.purple)
                Text("Daily Study Fortune")
                    .font(.title3)
                    .bold()
            }
            
        }
    }
}

#Preview {
    PaywallDescriptionView()
}
