//
//  AlamofireHTTPClient.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 15/12/22.
//

import Alamofire

class AlamofireHTTPClient: HTTPClient {
    private var session: Session
    
    public init(session: Session = .default) {
        self.session = session
    }
    
    private struct UnexpectedValuesRepresentation: Error {}
    
    func getPokemonList(limit: Int = 20, offset: Int = 0, completion: @escaping (HTTPClient.Result) -> Void) {
        let urlRequest = Endpoints.pokemonList(limit: limit, offset: offset).url
        
        AF.request(urlRequest)
            .validate()
            .response { result in
                completion(Result {
                    if let error = result.error {
                        throw error
                    } else if let data = result.data, let response = result.response {
                        return (data, response)
                    } else {
                        throw UnexpectedValuesRepresentation()
                    }
                })
            }
    }
    
    func getPokemonDetails(by text: String, completion: @escaping (HTTPClient.Result) -> Void) {
        let urlRequest = Endpoints.pokemonDetails(by: text).url
        
        AF.request(urlRequest)
            .validate()
            .response { result in
                completion(Result {
                    if let error = result.error {
                        throw error
                    } else if let data = result.data, let response = result.response {
                        return (data, response)
                    } else {
                        throw UnexpectedValuesRepresentation()
                    }
                })
            }
    }
    
    func getAbilityDescription(by id: Int, completion: @escaping (HTTPClient.Result) -> Void) {
        let urlRequest = Endpoints.abilityDescription(by: id).url
        
        AF.request(urlRequest)
            .validate()
            .response { result in
                completion(Result {
                    if let error = result.error {
                        throw error
                    } else if let data = result.data, let response = result.response {
                        return (data, response)
                    } else {
                        throw UnexpectedValuesRepresentation()
                    }
                })
            }
    }
    
    func getEquivalentPokemons(by typeId: Int, completion: @escaping (HTTPClient.Result) -> Void) {
        let urlRequest = Endpoints.equivalentPokemons(by: typeId).url
        
        AF.request(urlRequest)
            .validate()
            .response { result in
                completion(Result {
                    if let error = result.error {
                        throw error
                    } else if let data = result.data, let response = result.response {
                        return (data, response)
                    } else {
                        throw UnexpectedValuesRepresentation()
                    }
                })
            }
    }
    
}
