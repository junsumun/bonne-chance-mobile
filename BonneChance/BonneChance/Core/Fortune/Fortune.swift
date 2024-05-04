//
//  Fortune.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-05-03.
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
