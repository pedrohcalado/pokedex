//
//  RemotePokemonSpeciesItem.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 19/12/22.
//

import Foundation

struct RemotePokemonSpeciesItem: Codable {
    let varieties: [PokemonVariety]
}

struct PokemonVariety: Codable {
    let isDefault: Bool
    let pokemon: RemotePokemonItem
    
    enum CodingKeys: String, CodingKey {
        case isDefault = "is_default"
        case pokemon
    }
}
