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
    
    @State var selectedProduct: Product?
    
    var close: () -> ()
    
    var body: some View {
        
        
        VStack {
            Button {
                close()
            } label: {
                HStack {
                    Spacer()
                    Text("Close")
                        .foregroundColor(.black)
                        .font(.title3)
                }
                .padding()
            }
            
            // PAYWALLDESCRIPTION VIEW
            PaywallDescriptionView()
            .padding()
            
            Spacer()
            
            // SUBSCRIPTIONS LIST
            HStack {
                ForEach(purchaseManager.products, id: \.id) { product in
                    Button {
                        selectedProduct = product
                    } label: {
                        ProductCardView(product: product, selectedProduct: $selectedProduct)
                            .environmentObject(purchaseManager)
                    }
                }
            }
            .padding()
            
            // SUBSCRIPTION TYPE MESSAGE
            Text(selectedProduct?.displayName == ProductName.oneYear.rawValue ? "Includes 3-day free trial. Cancel anytime." : "Auto-renewable subsription. Cancel anytime.")
                .padding(.bottom, 10)
            
            // PURCHASE BUTTON
            Button {
                if let selectedProduct = selectedProduct {
                    Task {
                        await purchaseManager.purchase(selectedProduct)
                    }
                }
            } label: {
                Text(selectedProduct?.displayName == ProductName.oneYear.rawValue ? "Continue for Free" : "Continue")
                    .padding(16)
                    .frame(maxWidth: .infinity)
                    .background(Color.purple)
                    .cornerRadius(10)
                    .padding(.horizontal, 16)
                    .foregroundColor(.white)
            }
            .padding(.bottom, 15)
            
            
        }
    }
}

#Preview {
    PaywallView(selectedProduct: nil) {}
        .environmentObject(PurchaseManager())
}
