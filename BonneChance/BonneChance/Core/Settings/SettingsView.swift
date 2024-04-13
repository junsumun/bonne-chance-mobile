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
            Button("Sign out") {
                Task {
                }
            }
        }
        .navigationBarTitle("Settings")
    }
}

#Preview {
    NavigationView {
        SettingsView()
    }
}
