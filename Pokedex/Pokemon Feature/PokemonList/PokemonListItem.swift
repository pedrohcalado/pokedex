//
//  PokemonListItem.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 14/12/22.
//

import Foundation

struct PokemonListItem: Codable {
    let id: Int
    let name: String
    let url: String
    
    init(name: String, url: String) {
        self.name = name
        self.url = url
        self.id = Int(url.split(separator: "/").last ?? "") ?? 0
    }
    
}
