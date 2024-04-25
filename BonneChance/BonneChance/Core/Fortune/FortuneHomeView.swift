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
        Fortune(name: "Overall Fortune", type: FortuneType.overall, image: "overall_fortune", color: Color("FortuneCardColor")),
        Fortune(name: "Love Fortune", type: FortuneType.love, image: "love_fortune", color: Color("FortuneCardColor")),
        Fortune(name: "Money Fortune", type: FortuneType.money, image: "money_fortune", color: Color("FortuneCardColor")),
        Fortune(name: "Career Fortune", type: FortuneType.career, image: "career_fortune", color: Color("FortuneCardColor")),
        Fortune(name: "Study Fortune", type: FortuneType.study, image: "study_fortune", color: Color("FortuneCardColor"))
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(fortuneList, id: \.id) { fortune in
                            NavigationLink {
                                FortuneDetailView(showPaywall: $showPaywall, fortune: fortune)
                                    .environmentObject(profileViewModel)
                            } label: {
                                FortuneCardView(showMenu: $showMenu, fortune: fortune)
                                    .padding(.top, 20)
                                    .padding(.bottom, 20)
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
                            .fill(Color.accentColor)
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


