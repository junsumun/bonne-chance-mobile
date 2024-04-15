//
//  FortuneCardView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-04-15.
//

import SwiftUI

struct FortuneCardView: View {
    
    var fortune: Fortune
    
    var body: some View {
        ZStack {
            Image(fortune.image)
                .resizable()
                .scaledToFit()
            VStack(alignment: .center) {
                Text("Today's")
                    .font(.system(size: 20, weight: .medium))
                    .frame(width: 200)
                Text("\(fortune.name)")
                    .font(.system(size: 30, weight: .medium))
                    .frame(width: 250)
            }
            .offset(x: 0, y: -140)
            .foregroundColor(.white)
        }
        .padding(30)
        .frame(width: 336, height: 422)
        .background(fortune.color)
        .cornerRadius(57)
        .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0.0, y: 5)
        .padding(.leading, 20)
    }
}

#Preview {
    FortuneCardView(fortune: Fortune(name: "Overall Fortune", type: "overall", image: "overall_fortune", color: .blue))
}
