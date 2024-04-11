//
//  RootView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-03-12.
//

import SwiftUI

struct ContentView: View {
    
    @State var showMenu = true
    
    @AppStorage("signed_in") var currentUserSignedIn: Bool = false
    
    var body: some View {
        ZStack {
            if currentUserSignedIn {
                HomeView()
            }
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            currentUserSignedIn = authUser == nil ? false : true
        }
        .fullScreenCover(isPresented: Binding<Bool>(get: { !currentUserSignedIn }, set: { _ in })) {
            OnBoardingView()
        }
        
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
