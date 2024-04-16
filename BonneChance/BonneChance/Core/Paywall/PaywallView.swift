//
//  PaywallView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-04-15.
//

import SwiftUI

struct PaywallView: View {
    @Binding var showPaywall: Bool;
    
    var body: some View {
        Button {
            showPaywall.toggle()
        } label: {
            Text("Close")
        }
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    PaywallView(showPaywall: .constant(true))
}
