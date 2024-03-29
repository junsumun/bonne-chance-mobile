//
//  RootView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-03-12.
//

import SwiftUI

struct RootView: View {
    
    @AppStorage("signed_in") var currentUserSignedIn: Bool = false
    
    var body: some View {
        ZStack {
            if currentUserSignedIn {
                NavigationStack {
                    FortuneSelectionView()
                }
            } else {
                OnBoardingView()
            }
            
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            currentUserSignedIn = authUser == nil ? false : true
        }
//        .fullScreenCover(isPresented: $showSignInView) {
//            OnBoardingView(showSignInView: $showSignInView)
//        }
        
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
