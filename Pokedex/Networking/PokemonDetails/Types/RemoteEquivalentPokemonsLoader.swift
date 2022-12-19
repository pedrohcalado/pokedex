//
//  RemoteEquivalentPokemonsLoader.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 18/12/22.
//

import Foundation

final class RemoteEquivalentPokemonsLoader: EquivalentPokemonsLoader {
    private let client: HTTPClient

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    typealias Result = EquivalentPokemonsLoader.Result

    init(client: HTTPClient) {
        self.client = client
    }
    
    func getEquivalentPokemons(by typeId: Int, completion: @escaping (Result) -> Void) {
        client.getEquivalentPokemons(by: typeId) { result in
            switch result {
            case let .success((data, response)):
                completion(RemoteEquivalentPokemonsLoader.map(data, from: response))
            case .failure:
                completion(.failure(RemoteEquivalentPokemonsLoader.Error.connectivity))
            }
        }
    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try EquivalentPokemonsMapper.map(data, from: response)
            
            let pokemons = items.pokemons.compactMap { PokemonListItem(name: $0.pokemon.name, url: $0.pokemon.url) }
            
            return .success(pokemons)
        } catch {
            return .failure(error)
        }
    }
}
