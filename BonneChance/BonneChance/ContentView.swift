//
//  RootView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-03-12.
//

import SwiftUI

struct ContentView: View {
    
    @State var showMenu = true
    
    @StateObject private var purchaseManager = PurchaseManager()
    
    @AppStorage("signed_in") var currentUserSignedIn: Bool = false
    
    var body: some View {
        ZStack {
            if currentUserSignedIn {
                HomeView()
                    .environmentObject(purchaseManager)
            }
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            currentUserSignedIn = authUser == nil ? false : true
            print("Checking auth user: \(currentUserSignedIn)")
        }
        .fullScreenCover(isPresented: Binding<Bool>(get: { !currentUserSignedIn }, set: { _ in })) {
            OnBoardingView()
            let _ = print("OnBoardingView should be displayed")
        }
        
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
