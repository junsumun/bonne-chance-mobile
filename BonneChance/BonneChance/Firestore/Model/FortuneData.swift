//
//  FortuneData.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-04-23.
//

import Foundation

struct FortuneData: Codable {
    let overallFortune: FortuneContent
    let loveFortune: FortuneContent
    let moneyFortune: FortuneContent
    let careerFortune: FortuneContent
    let studyFortune: FortuneContent
    
    
    enum CodingKeys: String, CodingKey {
        case overallFortune = "overall_fortune"
        case loveFortune = "love_fortune"
        case moneyFortune = "money_fortune"
        case careerFortune = "career_fortune"
        case studyFortune = "study_fortune"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.overallFortune = try container.decode(FortuneContent.self, forKey: .overallFortune)
        self.loveFortune = try container.decode(FortuneContent.self, forKey: .loveFortune)
        self.moneyFortune = try container.decode(FortuneContent.self, forKey: .moneyFortune)
        self.careerFortune = try container.decode(FortuneContent.self, forKey: .careerFortune)
        self.studyFortune = try container.decode(FortuneContent.self, forKey: .studyFortune)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.overallFortune, forKey: .overallFortune)
        try container.encode(self.loveFortune, forKey: .loveFortune)
        try container.encode(self.moneyFortune, forKey: .moneyFortune)
        try container.encode(self.careerFortune, forKey: .careerFortune)
        try container.encode(self.studyFortune, forKey: .studyFortune)
    }
}


struct FortuneContent: Codable {
    let content: String
    let level: Int
    
    
    enum CodingKeys: String, CodingKey {
        case content = "content"
        case level = "level"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.content = try container.decode(String.self, forKey: .content)
        self.level = try container.decode(Int.self, forKey: .level)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.content, forKey: .content)
        try container.encode(self.level, forKey: .level)
    }
}
