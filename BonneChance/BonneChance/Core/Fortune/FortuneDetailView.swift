//
//  FortuneDetailView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-04-14.
//

import SwiftUI

struct FortuneDetailView: View {
    @State var fortuneData: FortuneData? = nil
    
    @Binding var showPaywall: Bool
    
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    
    var fortune: Fortune
    
    private var user: DBUser? {
        return profileViewModel.user
    }
    
    var body: some View {
        VStack {
            Text("Today's fortune")
                .font(.title)
            Text(fortuneData?.content ?? "" )
            
            Button {
                if (user?.premiumType != Premium.basic || fortune.type == FortuneType.overall) {
                    showPaywall = false
                }
                else {
                    showPaywall = true
                }
            } label: {
                Text("Read more")
            }
        }
        .task {
                let fortune = try? await FortuneManager.shared.getFortune()
                fortuneData = fortune
            }
        
            
    }
    
}

#Preview {
    FortuneDetailView(showPaywall: .constant(false),
                      fortune: Fortune(name: "Overall Fortune",
                                       type: FortuneType.overall,
                                       image: "overall_fortune",
                                       color: Color.white))
    .environmentObject(ProfileViewModel())
}
