//
//  AbilitiesDescriptionMapper.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 18/12/22.
//

import Foundation

final class AbilitiesDescriptionMapper {
    private static var OK_200: Int { return 200 }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> RemoteAbilityItem {
        guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(RemoteAbilityItem.self, from: data) else {
            throw RemotePokemonDetailsLoader.Error.invalidData
        }
        
        return root
    }
}
