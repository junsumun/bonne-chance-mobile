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
            ZStack {
                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .center) {
                            Text("Today's")
                                .font(.system(size: 20, weight: .medium))
                                .frame(width: 200)
                            Text("\(fortune.name)")
                                .font(.system(size: 30, weight: .medium))
                                .frame(width: 250)
                            
                        }
                    }
                    Spacer()
                }
            }
        }
        .padding(30)
        .frame(width: 336, height: 422)
        .background(fortune.color.opacity(0.13))
        .clipShape(.rect(cornerRadius: 57))
        .padding(.leading, 20)
    }
}

#Preview {
    FortuneCardView(fortune: Fortune(name: "Overall Fortune", type: "overall", image: "overall_fortune", color: .green))
}
