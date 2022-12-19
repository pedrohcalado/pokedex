//
//  PokemonSpeciesLoader.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 19/12/22.
//

import Foundation

protocol PokemonSpeciesLoader {
    typealias Result = Swift.Result<[PokemonSpeciesItem], Error>
    func getPokemonVarieties(by pokemonId: Int, completion: @escaping (Result) -> Void)
}
