//
//  FortuneSelectionView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-03-18.
//

import SwiftUI

struct FortuneSelectionView: View {
    @Binding var showSignInView: Bool

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        NavigationStack {
            NavigationLink(destination: SettingsView(showSignInView: $showSignInView)) {
                Text("test")
            }
        }
        
    }
}

#Preview {
    FortuneSelectionView(showSignInView: .constant(true))
}
