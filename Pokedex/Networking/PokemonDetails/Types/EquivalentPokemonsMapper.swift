//
//  EquivalentPokemonsMapper.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 18/12/22.
//

import Foundation

final class EquivalentPokemonsMapper {
    private static var OK_200: Int { return 200 }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> RemoteEquivalentPokemonsItem {
        guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(RemoteEquivalentPokemonsItem.self, from: data) else {
            throw RemoteEquivalentPokemonsLoader.Error.invalidData
        }
        
        return root
    }
}
