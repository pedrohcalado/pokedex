//
//  EquivalentPokemonItem.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 18/12/22.
//

import Foundation

struct EquivalentPokemonsItem: Codable {
    let id: Int
    let name: String
    let url: String
    
    init(name: String, url: String) {
        self.id = Int(url.split(separator: "/").last ?? "") ?? 0
        self.name = name
        self.url = url
    }
}
