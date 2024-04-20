//
//  PaywallView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-04-15.
//

import SwiftUI
import StoreKit
struct PaywallView: View {
    
    @EnvironmentObject private var purchaseManager: PurchaseManager
    
    @Binding var showPaywall: Bool;
    
    var body: some View {
        
        
        VStack {
            Button {
                showPaywall.toggle()
            } label: {
                HStack {
                    Spacer()
                    Text("Close")
                        .foregroundColor(.black)
                        .font(.title3)
                }
                .padding()
            }
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Unlock more fortunes")
                        .font(.title)
                        .bold()
                        .foregroundColor(.purple)
                    Spacer()
                }
                .padding(.bottom, 20)
                
                
                HStack {
                    Image(systemName: "checkmark")
                        .foregroundColor(.purple)
                    Text("Daily Overall Fortune")
                        .font(.title3)
                        .bold()
                }
                .padding(.bottom, 10)
                HStack {
                    Image(systemName: "checkmark")
                        .foregroundColor(.purple)
                    Text("Daily Love Fortune")
                        .font(.title3)
                        .bold()
                    
                }
                .padding(.bottom, 10)
                HStack {
                    Image(systemName: "checkmark")
                        .foregroundColor(.purple)
                    Text("Daily Money Fortune")
                        .font(.title3)
                        .bold()
                }
                .padding(.bottom, 10)
                HStack {
                    Image(systemName: "checkmark")
                        .foregroundColor(.purple)
                    Text("Daily Career Fortune")
                        .font(.title3)
                        .bold()
                }
                .padding(.bottom, 10)
                HStack {
                    Image(systemName: "checkmark")
                        .foregroundColor(.purple)
                    Text("Daily Study Fortune")
                        .font(.title3)
                        .bold()
                }
                
            }
            .padding()
            
            Spacer()
            HStack {
                ForEach(purchaseManager.products, id: \.id) { product in
                    Button {
                        purchaseManager.selectedProduct = product
                    } label: {
                        ProductCardView(product: product)
                    }
                    
                }
                
            }
            .padding()
            
            Text(purchaseManager.selectedProduct?.displayName == ProductName.oneYear.rawValue ? "Includes 3-day free trial. Cancel anytime." : "Auto-renewable subsription. Cancel anytime.")
                .padding(.bottom, 10)
            Button {
                Task {
                    do {
                        try await purchaseManager.purchase(product: purchaseManager.selectedProduct!)
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text(purchaseManager.selectedProduct?.displayName == ProductName.oneYear.rawValue ? "Continue for Free" : "Continue")
                    .padding(16)
                    .frame(maxWidth: .infinity)
                    .background(Color.purple)
                    .cornerRadius(10)
                    .padding(.horizontal, 16)
                    .foregroundColor(.white)
            }
            .padding(.bottom, 15)
            
            
        }
        .task {
            _ = Task<Void, Never> {
                do {
                    try await purchaseManager.loadProducts()
                } catch {
                    print(error)
                }
            }
            
        }
    }
    
    @ViewBuilder
    func ProductCardView(product: Product) -> some View {
        VStack(alignment: .center) {
            Text("\(product.displayName.dropLast(5))")
                .font(.title2)
                .bold()
            Text("\(product.displayName.dropFirst(1))")
                .font(.title2)
                .bold()
            Text("\(product.displayPrice)")
                .font(.caption)
            Text("per\(product.displayName.dropFirst(1).lowercased())")
                .font(.caption)
            Divider()
            Text("$\(purchaseManager.calculateWeeklyPrice(subscriptionLength: product.displayName, price: product.price))")
                .font(.body)
                .fontWeight(.semibold)
            Text("per week")
                .font(.body)
                .fontWeight(.semibold)
        }
        .foregroundColor(.black)
        .padding(15)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(purchaseManager.selectedProduct?.displayName == product.displayName ? .purple : .gray, lineWidth: purchaseManager.selectedProduct?.displayName == product.displayName ? 2 : 1)
        )
        .overlay {
            if product.displayName == ProductName.oneYear.rawValue {
                HStack {
                    Text("BEST VALUE")
                        .font(.system(size: 15))
                        .bold()
                        .foregroundColor(.white)
                }
                .padding(7)
                .background(Color.purple)
                .cornerRadius(20)
                .offset(x: 0, y: -90)
            }
            
        }
    }
        
}

#Preview {
    PaywallView(showPaywall: .constant(true))
        .environmentObject(PurchaseManager())
}
