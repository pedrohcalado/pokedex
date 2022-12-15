//
//  PokemonListItem.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 14/12/22.
//

import Foundation

struct PokemonListItem: Codable {
    let name: String
    let url: String
    
    init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}
