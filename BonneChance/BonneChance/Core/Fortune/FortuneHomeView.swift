//
//  MainView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-04-10.
//

import SwiftUI

struct FortuneHomeView: View {
    
    @Binding var showMenu: Bool
    @Binding var showPaywall: Bool
    
    @State var currentFortuneSlider: Int = 0
    @State private var scrollPosition: CGPoint = .zero
    
    @EnvironmentObject var purchaseManager: PurchaseManager
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    private var user: DBUser? {
        return profileViewModel.user
    }
    
    var fortuneList = [
        Fortune(name: "Overall Fortune", type: FortuneType.overall, image: "overall_fortune", color: Color(red: 188 / 255, green: 188 / 255, blue: 226 / 255)),
        Fortune(name: "Love Fortune", type: FortuneType.love, image: "love_fortune", color: Color(red: 239 / 255, green: 176 / 255, blue: 187 / 255)),
        Fortune(name: "Money Fortune", type: FortuneType.money, image: "money_fortune", color: Color(red: 239 / 255, green: 223 / 255, blue: 162 / 255)),
        Fortune(name: "Career Fortune", type: FortuneType.career, image: "career_fortune", color: Color(red: 211 / 255, green: 202 / 255, blue: 190 / 255)),
        Fortune(name: "Study Fortune", type: FortuneType.study, image: "career_fortune", color: Color(red: 163 / 255, green: 199 / 255, blue: 239 / 255))
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(fortuneList, id: \.id) { fortune in
                            NavigationLink {
                                FortuneDetailView()
                            } label: {
                                FortuneCardView(fortune: fortune)
                                    .padding(.top, 20)
                                    .padding(.bottom, 20)
                            }
                            .disabled(user?.premiumType == Premium.basic && fortune.type != FortuneType.overall)
                            .onTapGesture {
                                if (user?.premiumType != Premium.basic || fortune.type == FortuneType.overall) {
                                    showPaywall = false
                                }
                                else {
                                    showPaywall = true
                                }
                            }
                            
                        }
                    }
                    .background(GeometryReader { geometry in
                        Color.clear
                            .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).origin)
                    })
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                        self.scrollPosition = value
                        self.currentFortuneSlider = Int(round(abs(self.scrollPosition.x) / 350))
                    }
                    
                }
                
                HStack(spacing: 10) {
                    ForEach(fortuneList.indices, id: \.self) { index in
                        Circle()
                            .fill(Color.black)
                            .opacity(currentFortuneSlider == index ? 1 : 0.1)
                            .frame(width: 7, height: 8)
                            .scaleEffect(currentFortuneSlider == index ? 1.4 : 1)
                            .animation(.spring(), value: currentFortuneSlider == index)
                    }
                }
                Spacer()
            }
            .background(self.showMenu ? .gray : .white)
            .disabled(self.showMenu)
            
        }
    }
}

#Preview {
    FortuneHomeView(showMenu: .constant(false), showPaywall: .constant(false))
        .environmentObject(ProfileViewModel())
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero

    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
    }
}


