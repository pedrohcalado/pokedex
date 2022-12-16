//
//  PokemonListLoader.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 14/12/22.
//

import Foundation

protocol PokemonListLoader {
    typealias Result = Swift.Result<[PokemonListItem], Error>
    func loadPokemonList(offset: Int, limit: Int, completion: @escaping (Result) -> Void)
}
