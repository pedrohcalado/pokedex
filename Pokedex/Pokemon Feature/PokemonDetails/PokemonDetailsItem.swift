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
    let types: [PokemonDetailsType]
    
    init(id: Int, name: String, images: [String?], stats: [String: Int], abilities: [PokemonDetailsAbility], types: [PokemonDetailsType]) {
        self.id = id
        self.name = name
        self.images = images
        self.stats = stats
        self.abilities = abilities
        self.types = types
    }
}

struct PokemonDetailsAbility: Codable {
    let name: String
    let url: String
    let id: Int
    
    init(name: String, url: String) {
        self.name = name
        self.url = url
        self.id = Int(url.split(separator: "/").last ?? "") ?? 0
    }
}

struct PokemonDetailsType: Codable {
    let id: Int
    let name: String
    let url: String
    
    init(name: String, url: String) {
        self.id = Int(url.split(separator: "/").last ?? "") ?? 0
        self.name = name
        self.url = url
    }
}
