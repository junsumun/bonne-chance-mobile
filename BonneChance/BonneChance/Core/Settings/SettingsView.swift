//
//  SettingsView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-03-12.
//

import SwiftUI

struct SettingsView: View {
    
    
    var body: some View {
        List {
            Button("Placeholder") {
                Task {
                }
            }
        }
        .navigationBarTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
