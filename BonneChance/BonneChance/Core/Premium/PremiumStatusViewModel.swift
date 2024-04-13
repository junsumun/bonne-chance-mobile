//
//  PremiumStatusViewModel.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-04-12.
//

import Foundation
import SwiftUI

@MainActor
final class PremiumStatusViewModel: ObservableObject {
    
    func getColorForPremiumType(premiumType: Premium?) -> Color {
        guard let premiumType = premiumType else {
            return Color.gray
        }
        
        switch premiumType {
        case Premium.basic:
            return Color.gray
        case Premium.gold:
            return Color.yellow
        default:
            return Color.gray
        }
    }
}
