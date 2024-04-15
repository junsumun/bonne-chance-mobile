//
//  HomeView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-04-10.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var profileViewModel = ProfileViewModel()
    
    @State var showMenu = false
    @State var showPaywall = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    FortuneHomeView(showMenu: self.$showMenu, showPaywall: self.$showPaywall)
                    
                    if self.showMenu {
                        SideMenuView()
                            .frame(width: geometry.size.width * 0.7)
                            .transition(.move(edge: .leading))
                    }
                }
                .animation(.easeInOut, value: self.showMenu)
                .task {
                    try? await profileViewModel.loadCurrentUser()
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
            PaywallView()
            let _ = print("paywall displayed")
        }
    }
}

#Preview {
    HomeView()
}
