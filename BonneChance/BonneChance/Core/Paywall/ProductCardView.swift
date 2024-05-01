//
//  ProductCardView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-04-22.
//

import SwiftUI
import StoreKit

struct ProductCardView: View {
    
    @EnvironmentObject private var purchaseManager: PurchaseManager
    
    let product: Product?
    
    @Binding var selectedProduct: Product?
    
    var body: some View {
        VStack(alignment: .center) {
            Text("\(product?.displayName.dropLast(5) ?? "")")
                .font(.title2)
                .bold()
            Text("\(product?.displayName.dropFirst(1) ?? "")")
                .font(.title2)
                .bold()
            Text("\(product?.displayPrice ?? "")")
                .font(.caption)
            Text("per\(product?.displayName.dropFirst(1).lowercased() ?? "")")
                .font(.caption)
            Divider()
            Text("$\(calculateWeeklyPrice(subscriptionLength: product?.displayName, price: product?.price))")
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
                .stroke(selectedProduct?.displayName == product?.displayName ? Color("MainColor") : .gray, lineWidth: selectedProduct?.displayName == product?.displayName ? 2 : 1)
        )
        .overlay {
            if product?.displayName == ProductName.oneYear.rawValue {
                HStack {
                    Text("BEST VALUE")
                        .font(.system(size: 15))
                        .bold()
                        .foregroundColor(.white)
                }
                .padding(7)
                .background(Color("MainColor"))
                .cornerRadius(20)
                .offset(x: 0, y: -90)
            }
            
        }
    }
    
    func calculateWeeklyPrice(subscriptionLength: String?, price: Decimal?) -> String {
        
        guard let price = price else {
            return ""
        }
        
        guard let subscriptionLength = subscriptionLength else {
            return ""
        }
        
        let priceInDouble = NSDecimalNumber(decimal: price).doubleValue
        
        switch subscriptionLength {
        case ProductName.oneMonth.rawValue:
            return "\(floor(priceInDouble / 4 * 100) / 100)"
        case ProductName.oneYear.rawValue:
            return "\(floor(priceInDouble / 12 / 4 * 100) / 100)"
        case ProductName.threeMonth.rawValue:
            return "\(floor(priceInDouble / 3 / 4 * 100) / 100)"
        default:
            return "Error"
        }
    }
}



#Preview {
    ProductCardView(product: nil, selectedProduct: .constant(nil))
}
