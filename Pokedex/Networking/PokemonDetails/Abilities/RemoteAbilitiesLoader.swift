//
//  RemoteAbilitiesLoader.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 18/12/22.
//

import Foundation

final class RemoteAbilitiesLoader: AbilityDescriptionLoader {
    private let client: HTTPClient

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    typealias Result = AbilityDescriptionLoader.Result

    init(client: HTTPClient) {
        self.client = client
    }
    
    func getAbilityDescription(by id: Int, completion: @escaping (Result) -> Void) {
        client.getAbilityDescription(by: id) { result in
            switch result {
            case let .success((data, response)):
                completion(RemoteAbilitiesLoader.map(data, from: response))
            case .failure:
                completion(.failure(RemotePokemonDetailsLoader.Error.connectivity))
            }
        }
    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try AbilitiesDescriptionMapper.map(data, from: response)
            
            let abilityDescriptions = items.effectEntries.map { AbilityDescription(effect: $0.effect, language: $0.language.name) }
            
            return .success(AbilityItem(description: abilityDescriptions))
        } catch {
            return .failure(error)
        }
    }
}
