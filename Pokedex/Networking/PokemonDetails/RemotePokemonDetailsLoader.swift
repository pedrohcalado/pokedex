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
            let stats = items.stats.reduce(into: [String: Int]()) { $0[$1.stat.name] = $1.baseStat }
            let abilities = items.abilities.compactMap { PokemonDetailsAbility(name: $0.ability.name, url: $0.ability.url) }
            let types = items.types.compactMap { PokemonDetailsType(name: $0.type.name, url: $0.type.url) }
            
            return .success(PokemonDetailsItem(id: items.id, name: items.name, images: images, stats: stats, abilities: abilities, types: types))
        } catch {
            return .failure(error)
        }
    }
}
