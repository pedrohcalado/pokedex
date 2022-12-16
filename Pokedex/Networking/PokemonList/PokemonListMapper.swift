//
//  PokemonListMapper.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 15/12/22.
//

import Foundation

final class PokemonListMapper {
   private struct Root: Decodable {
       let results: [RemotePokemonItem]
   }
   
   private static var OK_200: Int { return 200 }
   
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemotePokemonItem] {
       guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(Root.self, from: data) else {
           throw RemotePokemonListLoader.Error.invalidData
       }
   
       return root.results
   }
}
