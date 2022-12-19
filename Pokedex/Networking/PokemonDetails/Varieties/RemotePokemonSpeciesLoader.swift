//
//  RemotePokemonSpeciesLoader.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 19/12/22.
//

import Foundation

final class RemotePokemonSpeciesLoader: PokemonSpeciesLoader {
    private let client: HTTPClient

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    typealias Result = PokemonSpeciesLoader.Result

    init(client: HTTPClient) {
        self.client = client
    }
    
    func getPokemonVarieties(by pokemonId: Int, completion: @escaping (Result) -> Void) {
        client.getPokemonSpecies(by: pokemonId) { result in
            switch result {
            case let .success((data, response)):
                completion(RemotePokemonSpeciesLoader.map(data, from: response))
            case .failure:
                completion(.failure(RemotePokemonDetailsLoader.Error.connectivity))
            }
        }
    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try PokemonSpeciesMapper.map(data, from: response)
            
            let varieties = items.varieties.compactMap { PokemonSpeciesItem(isDefault: $0.isDefault, pokemon: PokemonListItem(name: $0.pokemon.name, url: $0.pokemon.url)) }
            
            return .success(varieties)
        } catch {
            return .failure(error)
        }
    }
}
