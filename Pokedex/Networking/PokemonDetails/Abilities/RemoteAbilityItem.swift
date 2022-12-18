//
//  RemoteAbilityItem.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 18/12/22.
//

import Foundation

struct RemoteAbilityItem: Codable {
    let effectEntries: [Effect]
    
    enum CodingKeys: String, CodingKey {
        case effectEntries = "effect_entries"
    }
}

struct Effect: Codable {
    let effect: String
    let language: EffectLanguage
}

struct EffectLanguage: Codable {
    let name: String
}
