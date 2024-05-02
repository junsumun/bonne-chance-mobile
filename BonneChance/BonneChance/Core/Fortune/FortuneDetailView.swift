//
//  FortuneDetailView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-04-14.
//

import SwiftUI

struct FortuneDetailView: View {
    @State var fortuneData: FortuneData? = nil
    @State var lineLimit: Int = 3
    @State var hideReadMoreButton: Bool = false
    @State private var animatedText: String = ""
    
    @Binding var showPaywall: Bool
    
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    
    var fortune: Fortune
    
    private var user: DBUser? {
        return profileViewModel.user
    }
    
    var body: some View {
        VStack {
            ZStack(alignment: .centerLastTextBaseline) {
                Rectangle()
                    .frame(height: 200)
                    .opacity(0)
                Image(fortune.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                    .blur(radius: 3)
                    .opacity(0.8)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Today's")
                            .font(.system(size: 20))
                            .fontDesign(.serif)
                            .foregroundColor(.gray)
                            .bold()
                        Text("\(fortune.name)")
                            .font(.title)
                            .fontDesign(.serif)
                            .bold()
                    }
                    Spacer()
                }
                .padding()
            }
            
            
            VStack(alignment: .leading) {
                Text("Readings")
                    .font(.system(size: 20))
                    .foregroundColor(Color("MainColor"))
                    .bold()
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Text(animatedText)
                            .multilineTextAlignment(.leading)
                            .lineLimit(lineLimit)
                            .font(.body)
                            .foregroundColor(Color("TextColor"))
                        if !hideReadMoreButton {
                            Button {
                                if (user?.premiumType != Premium.basic || fortune.type == FortuneType.overall) {
                                    showPaywall = false
                                    lineLimit = 200
                                    hideReadMoreButton = true
                                }
                                else {
                                    showPaywall = true
                                }
                            } label: {
                                Text("Continue reading")
                                    .padding(16)
                                    .frame(maxWidth: .infinity)
                                    .background(Color("MainColor"))
                                    .cornerRadius(27)
                                    .padding(.horizontal, 15)
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            }
                            .padding(.top, 5)
                        }
                    }
                    
                }
                
                Rectangle()
                    .hidden()
                Spacer()
            }
            
            .padding()
            
        }
        .task {
            fortuneData = try? await FortuneManager.shared.getFortune()
            guard let content = fortuneData?.content else {
                return
            }
            typeWriter(content: content)
        }
    }
    
    func typeWriter(content: String, at position: Int = 0) {
        if position == 0 {
            animatedText = ""
        }
        if position < content.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                animatedText.append(Array(content)[position])
                typeWriter(content: content, at: position + 1)
            }
        }
    }
}

#Preview {
    FortuneDetailView(showPaywall: .constant(false),
                      fortune: Fortune(name: "Overall Fortune",
                                       type: FortuneType.overall,
                                       image: "overall_fortune",
                                       color: Color.white))
    .environmentObject(ProfileViewModel())
}
