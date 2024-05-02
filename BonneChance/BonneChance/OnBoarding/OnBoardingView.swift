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
    OnBoardingStep(image: "onboarding1", title: "Foresight", description: "Gain a crystal-clear view of your day ahead, guiding you towards success and serenity!"),
    OnBoardingStep(image: "onboarding1", title: "Love, Money & More!", description: "Explore a universe of possibilities with our diverse fortune readings!"),
    OnBoardingStep(image: "onboarding1", title: "Purchase-Free Experience", description: "A whole assortment of free fortunes right in the palm of your hands!")
]

struct OnBoardingView: View {
    
    @State private var currentStep = 0
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            
            VStack {
                ZStack {
                    Image("onboarding1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 350, height: 350)
                        .offset(CGSize(width: 0, height: 50))
                    Image("bonne_chance_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .offset(CGSize(width: 0, height: -100))
                }
                .padding()
                TabView(selection: $currentStep) {
                    ForEach(0..<onBoardingSteps.count, id: \.self) { index in
                        VStack {
                            Text(onBoardingSteps[index].title)
                                .font(.title)
                                .foregroundColor(Color("MainColor"))
                                .bold()
                                .fontDesign(.serif)
                    
                            Text(onBoardingSteps[index].description)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                                .padding(.top, 5)
                                .foregroundColor(Color("MainColor"))
                                .bold()
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
                                .foregroundColor(Color("MainColor"))
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
                    Text("Get Started")
                        .padding(16)
                        .frame(maxWidth: .infinity)
                        .background(Color("MainColor"))
                        .cornerRadius(27)
                        .padding(.horizontal, 45)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
                .padding(.bottom, 15)
                
                HStack {
                    Text("Already have an account?")
                        .foregroundColor(.gray)
                        .fontWeight(.semibold)
                    NavigationLink {
                        AuthenticationView(hasAccount: .constant(true))
                            
                    } label: {
                        Text("Log in")
                            .foregroundStyle(Color("MainColor"))
                            .bold()
                    }
                }
                .padding(.bottom, 15)
                
                // TODO: Change below links to the landing page link
                Group {
                    Text("By continuing, you agree to our ")
                    + Text("[Terms. ](https://google.ca)").fontWeight(.bold)
                    + Text("You acknowledge receipt and understanding of our ")
                    + Text("[Privacy Policy ](https://google.ca)").fontWeight(.bold)
                    + Text("and ")
                    + Text("[Cookie Notice.](https://google.ca)").fontWeight(.bold)
                }
                .multilineTextAlignment(.center)
                .font(.system(size: 12))
                .fontWeight(.light)
                .foregroundColor(Color("FooterTextColor"))
                .padding(.horizontal, 45)
                .tint(Color("MainColor"))
            }
        }
    }
}

#Preview {
    OnBoardingView()
}
