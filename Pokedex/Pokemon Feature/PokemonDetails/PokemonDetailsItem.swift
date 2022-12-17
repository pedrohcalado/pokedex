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
    
    init(id: Int, name: String, images: [String?], stats: [String: Int]) {
        self.id = id
        self.name = name
        self.images = images
        self.stats = stats
    }
}

