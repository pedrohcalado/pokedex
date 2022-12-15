//
//  PokedexTests.swift
//  PokedexTests
//
//  Created by Pedro Henrique Calado on 14/12/22.
//

import XCTest

class PokedexListEndToEndTests: XCTestCase {

    func test_endToEndTestServerGETPokemonsList_returnSuccessfullResult() {
        let client = AlamofireHTTPClient()
        client.getPokemonList(limit: 20, offset: 1) { result in
            switch result {
            case let .success((data, response)):
                XCTAssertEqual(response.statusCode, 200, "Expected response status code to be 200.")
                XCTAssertEqual(data.count, 20, "Expected 20 pokemons in the list.")
            case let .failure(error):
                XCTFail("Expected successfull pokemon list result, got \(error) instead.")
            }
        }
    }
    
    func test_remotePokemonLoader_returnTwentyPokemonsInTheList() {
        let client = AlamofireHTTPClient()
        let remoteLoader = RemotePokemonListLoader(client: client)
        remoteLoader.loadPokemonList { result in
            switch result {
            case let .success(result):
                XCTAssertEqual(result.count, 20, "Expected 20 pokemons in the list.")
            case let .failure(error):
                XCTFail("Expected successfull pokemon list result, got \(error) instead.")
            }
        }
    }

}
