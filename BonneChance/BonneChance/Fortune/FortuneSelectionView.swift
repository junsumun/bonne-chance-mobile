//
//  FortuneSelectionView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-03-18.
//

import SwiftUI

struct FortuneSelectionView: View {

    @AppStorage("firstName") var currentUserFirstName: String?
    @AppStorage("lastName") var currentUserLastName: String?
    @AppStorage("gender") var currentUserGender: Gender?
    @AppStorage("birthdate") var currentUserBirthdate: String?
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("User profile")
                HStack {
                    Text("First name:")
                    Text(currentUserFirstName ?? "User first name")
                }
                HStack {
                    Text("Last name:")
                    Text(currentUserLastName ?? "User last name")
                }
                HStack {
                    Text("Gender:")
                    Text(currentUserGender?.rawValue ?? Gender.male.rawValue)
                }
                HStack {
                    Text("Birthdate:")
                    Text(currentUserBirthdate ?? "1234")
                }
                
                NavigationLink(destination: SettingsView()) {
                    Text("test")
                }
            }
        }
        
        
    }
}

#Preview {
    FortuneSelectionView()
}
