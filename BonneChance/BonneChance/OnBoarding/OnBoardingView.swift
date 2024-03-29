//
//  OnBoardingView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-03-19.
//

import SwiftUI

struct OnBoardingStep {
    let image: String
    let title: String
    let description: String
}

private let onBoardingSteps = [
    OnBoardingStep(image: "onboarding1", title: "Tarot, Horoscope, Saju, Palmistry & More!", description: "A whole assortment of free fortunes right in the palm of your hands!"),
    OnBoardingStep(image: "onboarding1", title: "Purchase-Free Experience", description: "A whole assortment of free fortunes right in the palm of your hands!"),
    OnBoardingStep(image: "onboarding1", title: "Tarot, Horoscope, Saju, Palmistry & More!", description: "A whole assortment of free fortunes right in the palm of your hands!")
]
struct OnBoardingView: View {
    
    @State private var currentStep = 0
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                TabView(selection: $currentStep) {
                    ForEach(0..<onBoardingSteps.count, id: \.self) { index in
                        VStack {
                            Image(onBoardingSteps[index].image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 250, height: 250)
                            
                            
                            Text(onBoardingSteps[index].title)
                                .font(.title)
                                .bold()
                    
                            Text(onBoardingSteps[index].description)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                                .padding(.top, 16)
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                HStack {
                    ForEach(0..<onBoardingSteps.count, id: \.self) { index in
                        if index == currentStep {
                            Rectangle()
                                .frame(width: 20, height: 10)
                                .cornerRadius(10)
                                .foregroundColor(.purple)
                        } else {
                            Circle()
                                .frame(width: 10, height: 10)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.bottom, 24)
            
                NavigationLink {
                    OnBoardingSignupView()
                } label: {
                    Text("Get Started!")
                        .padding(16)
                        .frame(maxWidth: .infinity)
                        .background(Color.purple)
                        .cornerRadius(10)
                        .padding(.horizontal, 16)
                        .foregroundColor(.white)
                }
                .padding(.bottom, 15)
                
                HStack {
                    Text("Already have an account?")
                    NavigationLink {
                        AuthenticationView()
                            
                    } label: {
                        Text("Log in")
                            .foregroundStyle(Color.purple)
                            .bold()
                    }
                }
                .padding(.bottom, 10)
                
            }
        }
        .tint(Color.purple)
    }
}

#Preview {
    OnBoardingView()
}
