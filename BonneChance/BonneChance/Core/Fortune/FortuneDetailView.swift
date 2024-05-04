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
    
    @AppStorage("lastCheckedDate") var lastCheckedDate: String?
    @AppStorage("fortuneIndex") var fortuneIndex: Int?
    
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
                    HStack {
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
                        Spacer()
                    }
                }
                
                Spacer()
            }
            
            .padding()
            
        }
        .task {
//            if fortuneData == nil || lastCheckedDate == nil || fortuneIndex == nil || lastCheckedDate != "May 4, 2024" {
            if fortuneData == nil || lastCheckedDate == nil || fortuneIndex == nil || lastCheckedDate != DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none) {
                let totalFortunes = try? await FortuneManager.shared.countFortunes()
                print("Total fortunes: \(totalFortunes ?? -1)")
                fortuneIndex = Int.random(in: 0..<totalFortunes!)
                print("Random fortune index: \(fortuneIndex ?? -11)")
                
                
                lastCheckedDate = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none)
                print("New checked date: \(String(describing: lastCheckedDate))")
                
                fortuneData = try? await FortuneManager.shared.getFortune(index: fortuneIndex!)
            } else {
                print("Last checked date: \(String(describing: lastCheckedDate))")
            }
            
            guard let fortuneData = fortuneData else {
                return
            }
            let fortuneContent = getFortuneContent(fortue: fortune, fortuneData: fortuneData)
            
            typeWriter(content: fortuneContent.content)
            
        }
    }
    
    
}

extension FortuneDetailView {
    
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
    
    func getFortuneContent(fortue: Fortune, fortuneData: FortuneData) -> FortuneContent {
        
        switch fortune.type {
        case FortuneType.overall:
            return fortuneData.overallFortune
        case FortuneType.love:
            return fortuneData.loveFortune
        case FortuneType.money:
            return fortuneData.moneyFortune
        case FortuneType.career:
            return fortuneData.careerFortune
        case FortuneType.study:
            return fortuneData.studyFortune
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
