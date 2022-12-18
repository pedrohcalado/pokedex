//
//  HTTPClient.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 14/12/22.
//

import Foundation

protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func getPokemonList(limit: Int, offset: Int, completion: @escaping (Result) -> Void)
    func getPokemonDetails(by text: String, completion: @escaping (Result) -> Void)
    func getAbilityDescription(by id: Int, completion: @escaping (Result) -> Void)
    func getEquivalentPokemons(by typeId: Int, completion: @escaping (Result) -> Void)
}
