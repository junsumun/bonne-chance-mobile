//
//  PremiumStatusView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-04-12.
//

import SwiftUI

struct PremiumStatusView: View {
    
    @StateObject private var viewModel = PremiumStatusViewModel()
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Current Plan:")
                .font(.subheadline)
            HStack(alignment: .center) {
                Image(systemName: "star.fill")
                    .imageScale(.small)
                    .foregroundColor(viewModel.getColorForPremiumType(premiumType: profileViewModel.user?.premiumType))
                Text("\(profileViewModel.user?.premiumType?.rawValue.capitalized ?? "Basic" )")
                    .font(.title2)
            }
            Button(action: {
                profileViewModel.togglePremiumStatus()
            }, label: {
                Text("Upgrade Plan")
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(Color.purple)
                    .cornerRadius(10)
                    .padding(.horizontal, 10)
                    .foregroundColor(.white)
            })
        }
        .padding()
        .background(Color(Color(.systemGray6)))
        .cornerRadius(10)
    }
}

#Preview {
    PremiumStatusView()
}
