//
//  RemotePokemonListLoader.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 15/12/22.
//

import Foundation

final class RemotePokemonListLoader: PokemonListLoader {
    private let client: HTTPClient

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    typealias Result = PokemonListLoader.Result

    init(client: HTTPClient) {
        self.client = client
    }

    func loadPokemonList(offset: Int = 0, limit: Int = 20, completion: @escaping (Result) -> Void) {
        client.getPokemonList(limit: limit, offset: offset) { result in
            switch result {
            case let .success((data, response)):
                completion(RemotePokemonListLoader.map(data, from: response))
            case .failure:
                completion(.failure(RemotePokemonListLoader.Error.connectivity))
            }
        }
    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try PokemonListMapper.map(data, from: response)
            return .success(items.toModels())
        } catch {
            return .failure(error)
        }
    }
}

fileprivate extension Array where Element == RemotePokemonItem {
    func toModels() -> [PokemonListItem] {
        return map { PokemonListItem(name: $0.name, url: $0.url) }
    }
}
