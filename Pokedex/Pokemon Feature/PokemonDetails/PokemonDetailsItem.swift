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
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
