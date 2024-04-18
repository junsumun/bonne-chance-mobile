//
//  HomeView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-04-10.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var paywallViewModel: PaywallViewModel = PaywallViewModel()
    @StateObject private var profileViewModel = ProfileViewModel()
    
    @State var showMenu = false
    @State var showPaywall = false
    @State var userPremiumType: Premium? = nil
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    FortuneHomeView(showMenu: self.$showMenu, showPaywall: self.$showPaywall)
                        .environmentObject(profileViewModel)
                    
                    if self.showMenu {
                        SideMenuView()
                            .frame(width: geometry.size.width * 0.7)
                            .transition(.move(edge: .leading))
                            .environmentObject(profileViewModel)
                    }
                }
                .animation(.easeInOut, value: self.showMenu)
                .task {
                    try? await profileViewModel.loadCurrentUser()
                    userPremiumType = profileViewModel.user?.premiumType
                }
                .navigationBarItems(leading: (
                    Button(action: {
                        self.showMenu.toggle()
                    }) {
                        Image(systemName: self.showMenu ? "xmark" : "line.horizontal.3")
                            .imageScale(.large)
                            .foregroundColor(.purple)
                    }
                ))
            }
        }
        .tint(.purple)
        .fullScreenCover(isPresented: $showPaywall) {
            PaywallView(showPaywall: $showPaywall)
                .environmentObject(paywallViewModel)
        }
    }
}

#Preview {
    HomeView()
}
