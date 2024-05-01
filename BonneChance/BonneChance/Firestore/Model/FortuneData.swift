//
//  FortuneData.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-04-23.
//

import Foundation

struct FortuneData: Codable {
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case content = "content"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.content = try container.decode(String.self, forKey: .content)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.content, forKey: .content)
    }
}

