//
//  PokemonSpeciesMapper.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 19/12/22.
//

import Foundation

final class PokemonSpeciesMapper {
    private static var OK_200: Int { return 200 }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> RemotePokemonSpeciesItem {
        guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(RemotePokemonSpeciesItem.self, from: data) else {
            throw RemotePokemonDetailsLoader.Error.invalidData
        }
        
        return root
    }
}
