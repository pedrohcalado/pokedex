//
//  RemotePokemonDetailsLoader.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 16/12/22.
//

import Foundation

final class RemotePokemonDetailsLoader: PokemonDetailsLoader {
    private let client: HTTPClient

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    typealias Result = PokemonDetailsLoader.Result

    init(client: HTTPClient) {
        self.client = client
    }
    
    func getPokemonDetails(by text: String, completion: @escaping (Result) -> Void) {
        client.getPokemonDetails(by: text) { result in
            switch result {
            case let .success((data, response)):
                completion(RemotePokemonDetailsLoader.map(data, from: response))
            case .failure:
                completion(.failure(RemotePokemonDetailsLoader.Error.connectivity))
            }
        }
    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try PokemonDetailsMapper.map(data, from: response)
            let sprites = items.sprites
            let images = [sprites.backDefault, sprites.backFemale, sprites.backShiny, sprites.backShinyFemale, sprites.frontDefault, sprites.frontFemale, sprites.frontShiny, sprites.frontShinyFemale]
            return .success(PokemonDetailsItem(id: items.id, name: items.name, images: images))
        } catch {
            return .failure(error)
        }
    }
}
