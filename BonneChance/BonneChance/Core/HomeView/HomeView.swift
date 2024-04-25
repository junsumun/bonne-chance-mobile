//
//  HomeView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-04-10.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var purchaseManager: PurchaseManager
    @StateObject private var profileViewModel = ProfileViewModel()
    
    @State var showMenu = false
    @State var showPaywall = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    FortuneHomeView(showMenu: self.$showMenu, showPaywall: self.$showPaywall)
                        .environmentObject(profileViewModel)
                    
                    if self.showMenu {
                        SideMenuView(showPaywall: $showPaywall)
                            .frame(width: geometry.size.width * 0.7)
                            .transition(.move(edge: .leading))
                            .environmentObject(profileViewModel)
                            .environmentObject(purchaseManager)
                    }
                }
                .animation(.easeInOut, value: self.showMenu)
                .navigationBarItems(leading: (
                    Button(action: {
                        self.showMenu.toggle()
                    }) {
                        Image(systemName: self.showMenu ? "xmark" : "line.horizontal.3")
                            .imageScale(.large)
                            .foregroundColor(.accentColor)
                    }
                ))
            }
        }
        .tint(.purple)
        .sheet(isPresented: $showPaywall) {
            PaywallView(selectedProduct: purchaseManager.products[1]) {
                showPaywall.toggle()
            }
            .alert(isPresented: $purchaseManager.hasError, error: purchaseManager.error) {}
            .environmentObject(purchaseManager)
        }
        .onChange(of: purchaseManager.action) {
            if purchaseManager.action == .successful {
                Task {
                    await profileViewModel.loadCurrentUser()
                }
                showPaywall = false
                
                purchaseManager.reset()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification), perform: { _ in
            Task {
                await purchaseManager.update()
                await profileViewModel.loadCurrentUser()
            }
        })
    }
}

#Preview {
    HomeView()
        .environmentObject(PurchaseManager())
}
