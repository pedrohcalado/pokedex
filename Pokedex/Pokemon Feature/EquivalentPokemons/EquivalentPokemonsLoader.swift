//
//  EquivalentPokemonsLoader.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 18/12/22.
//

import Foundation

protocol EquivalentPokemonsLoader {
    typealias Result = Swift.Result<[PokemonListItem], Error>
    func getEquivalentPokemons(by typeId: Int, completion: @escaping (Result) -> Void)
}
