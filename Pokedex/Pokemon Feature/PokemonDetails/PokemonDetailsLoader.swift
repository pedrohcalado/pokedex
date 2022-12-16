//
//  PokemonDetailsLoader.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 16/12/22.
//

import Foundation

protocol PokemonDetailsLoader {
    typealias Result = Swift.Result<PokemonDetailsItem, Error>
    func getPokemonDetails(by text: String, completion: @escaping (Result) -> Void)
}
