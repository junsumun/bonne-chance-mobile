//
//  Fortune.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-04-15.
//

import Foundation
import SwiftUI

struct Fortune: Identifiable {
    var id: UUID = UUID()
    var name: String
    var type: FortuneType
    var image: String
    var color: Color
}
