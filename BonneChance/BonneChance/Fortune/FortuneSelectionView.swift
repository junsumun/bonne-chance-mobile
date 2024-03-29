//
//  FortuneSelectionView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-03-18.
//

import SwiftUI

struct FortuneSelectionView: View {

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        NavigationStack {
            NavigationLink(destination: SettingsView()) {
                Text("test")
            }
        }
        
    }
}

#Preview {
    FortuneSelectionView()
}
