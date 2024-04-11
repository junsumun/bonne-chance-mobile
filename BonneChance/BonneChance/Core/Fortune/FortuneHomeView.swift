//
//  MainView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-04-10.
//

import SwiftUI

struct FortuneHomeView: View {
    
    @Binding var showMenu: Bool
    
    var body: some View {
        VStack {
            Spacer()
            Text("Fortune Carousel View Placeholder")
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(self.showMenu ? .gray : .white)
        .disabled(self.showMenu)
    }
}

#Preview {
    FortuneHomeView(showMenu: .constant(false))
}
