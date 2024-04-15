//
//  MainView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-04-10.
//

import SwiftUI

struct FortuneHomeView: View {
    
    @Binding var showMenu: Bool
    
    @State var currentFortuneSlider: Int = 0
    @State private var scrollPosition: CGPoint = .zero
    
    var fortuneList = [
        Fortune(name: "Overall Fortune", type: "overall", image: "overall_fortune", color: .indigo),
        Fortune(name: "Love Fortune", type: "love", image: "love_fortune", color: .pink),
        Fortune(name: "Money Fortune", type: "money", image: "money_fortune", color: .yellow),
        Fortune(name: "Career Fortune", type: "career", image: "career_fortune", color: .brown),
        Fortune(name: "Study Fortune", type: "study", image: "career_fortune", color: .blue)
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
    FortuneHomeView(showMenu: .constant(false))
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero

    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
    }
}


