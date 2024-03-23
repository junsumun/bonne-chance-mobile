//
//  RootView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-03-12.
//

import SwiftUI

struct RootView: View {
    
    @State private var showSignInView: Bool = true
    
    var body: some View {
        ZStack {
            if !showSignInView {
                NavigationStack {
                    FortuneSelectionView(showSignInView: $showSignInView)
                }
            }
            
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil ? true : false
        }
        .fullScreenCover(isPresented: $showSignInView) {
            OnBoardingView(showSignInView: $showSignInView)
        }
        
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
