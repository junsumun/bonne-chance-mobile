//
//  PaywallDescriptionView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-04-22.
//

import SwiftUI

struct PaywallDescription {
    let title: String
    let content: String
}

private let paywallDescriptions = [
    PaywallDescription(title: "Love, Money & More!", content: "In addition to your daily overall fortune, subscribers gain exclusive access to specialized readings for love, money, career, and more. Subscribe now and uncover a world of insights waiting to be explored."),
    PaywallDescription(title: "Upgrade Your Destiny", content: "Your future is too important to leave to chance. With advanced features and personalized guidance, you'll be on the path to success in no time."),
    PaywallDescription(title: "Stay Ahead of the Curve", content: "Don't miss out on what lies ahead. Our premium subscription offers advanced forecasts and detailed analysis to help you navigate life's twists and turns with confidence. Subscribe today and stay ahead of the curve.")
]

struct PaywallDescriptionView: View {
    
    @State private var currentStep = 0
    
    var body: some View {
        VStack {
            TabView(selection: $currentStep) {
                ForEach(0..<paywallDescriptions.count, id: \.self) { index in
                    VStack {
                        Text(paywallDescriptions[index].title)
                            .font(.title)
                            .foregroundColor(Color("MainColor"))
                            .bold()
                            .fontDesign(.serif)
                
                        Text(paywallDescriptions[index].content)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 15)
                            .padding(.top, 5)
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            HStack {
                ForEach(0..<paywallDescriptions.count, id: \.self) { index in
                    if index == currentStep {
                        Rectangle()
                            .frame(width: 20, height: 10)
                            .cornerRadius(10)
                            .foregroundColor(Color("MainColor"))
                    } else {
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        
    }
}

#Preview {
    PaywallDescriptionView()
}
