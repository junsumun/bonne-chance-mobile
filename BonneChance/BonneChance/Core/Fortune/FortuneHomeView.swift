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
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(productList, id: \.id) { product in
                            ProductCard(product: product)
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
                    ForEach(productList.indices, id: \.self) { index in
                        Circle()
                            .fill(Color.black)
                            .opacity(currentFortuneSlider == index ? 1 : 0.1)
                            .frame(width: 7, height: 8)
                            .scaleEffect(currentFortuneSlider == index ? 1.4 : 1)
                            .animation(.spring(), value: currentFortuneSlider == index)
                    }
                }
                .padding(.top, 20)
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

struct ProductCard: View {
    var product: Product
    
    var body: some View {
        ZStack {
            Image(product.image)
                .resizable()
                .scaledToFit()
            ZStack {
                VStack(alignment: .leading, content: {
                    HStack {
                        VStack(alignment: .center) {
                            Text("Today's")
                                .font(.system(size: 20, weight: .medium))
                                .frame(width: 200)
                            Text("\(product.name)")
                                .font(.system(size: 30, weight: .medium))
                                .frame(width: 250)
                            
                        }
                        
                        
//                        Spacer()
                    }
                    Spacer()
                })
            }
        }
        .padding(30)
        .frame(width: 336, height: 422)
        .background(product.color.opacity(0.13))
        .clipShape(.rect(cornerRadius: 57))
        .padding(.leading, 20)
    }
}

struct Product: Identifiable {
    var id: UUID = .init()
    var name: String
    var category: String
    var image: String
    var color: Color
    var price: Int
}

var productList = [
    Product(name: "Overall Fortune", category: "Choco", image: "overall_fortune", color: .green, price: 8),
    Product(name: "Love Fortune", category: "Choco", image: "love_fortune", color: .pink, price: 8),
    Product(name: "Money Fortune", category: "Choco", image: "money_fortune", color: .yellow, price: 8),
    Product(name: "Career Fortune", category: "Choco", image: "career_fortune", color: .brown, price: 8),
    Product(name: "Study Fortune", category: "Choco", image: "onboarding1", color: .blue, price: 8),
]
