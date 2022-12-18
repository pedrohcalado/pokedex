//
//  PokemonDetailsItem.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 16/12/22.
//

import Foundation

struct PokemonDetailsItem: Codable {
    let id: Int
    let name: String
    let images: [String?]
    let stats: [String: Int]
    let abilities: [PokemonDetailsAbility]
    
    init(id: Int, name: String, images: [String?], stats: [String: Int], abilities: [PokemonDetailsAbility]) {
        self.id = id
        self.name = name
        self.images = images
        self.stats = stats
        self.abilities = abilities
    }
}

struct PokemonDetailsAbility: Codable {
    let name: String
    let url: String
    
    init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}
