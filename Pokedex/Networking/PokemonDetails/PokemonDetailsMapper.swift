//
//  PokemonDetailsMapper.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 16/12/22.
//

import Foundation

final class PokemonDetailsMapper {
    private static var OK_200: Int { return 200 }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> RemotePokemonDetails {
        guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(RemotePokemonDetails.self, from: data) else {
            throw RemotePokemonDetailsLoader.Error.invalidData
        }
        
        return root
    }
}
