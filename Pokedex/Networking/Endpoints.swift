//
//  Endpoints.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 15/12/22.
//

import Foundation

struct Endpoints {
    private let path: String
    private let queryItems: [URLQueryItem]?
    private let version = "v2"
    private static let defaultLimit = 20
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "pokeapi.co"
        components.path = "/api/\(version)/\(path)"
        components.queryItems = queryItems
        
        return components.url!
    }
    
    static func pokemonList(limit: Int = defaultLimit, offset: Int = 0) -> Endpoints {
        return Endpoints(
            path: "pokemon",
            queryItems: [
                URLQueryItem(name: "offset", value: String(offset)),
                URLQueryItem(name: "limit", value: String(limit))
            ]
        )
    }
    
    static func pokemonDetails(by text: String) -> Endpoints {
        return Endpoints(
            path: "pokemon/\(text)",
            queryItems: nil
        )
    }
    
    static func abilityDescription(by id: Int) -> Endpoints {
        return Endpoints(
            path: "ability/\(id)",
            queryItems: nil)
    }
    
    static func equivalentPokemons(by typeId: Int) -> Endpoints {
        return Endpoints(
            path: "type/\(typeId)",
            queryItems: nil)
    }
    
}
