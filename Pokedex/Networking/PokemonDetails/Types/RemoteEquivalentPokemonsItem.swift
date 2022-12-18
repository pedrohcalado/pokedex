//
//  RemoteSameTypePokemons.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 18/12/22.
//

import Foundation

struct RemoteEquivalentPokemonsItem: Codable {
    let pokemons: [EquivalentPokemon]
    
    enum CodingKeys: String, CodingKey {
        case pokemons = "pokemon"
    }
}

struct EquivalentPokemon: Codable {
    let pokemon: EquivalentPokemonDetails
    
    struct EquivalentPokemonDetails: Codable {
        let name: String
        let url: String
    }
}
