//
//  PokemonDetailsViewModel.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 16/12/22.
//

import Foundation

protocol PokemonDetailsViewModelProtocol {
    func loadPokemonDetails()
    func getPokemonName() -> String
    func getPokemonNumber() -> String
}

final class PokemonDetailsViewModel: PokemonDetailsViewModelProtocol {
    
    private var detailsLoader: PokemonDetailsLoader?
    private var pokemonListItem: PokemonListItem?
    
    init(detailsLoader: PokemonDetailsLoader, pokemonListItem: PokemonListItem) {
        self.detailsLoader = detailsLoader
        self.pokemonListItem = pokemonListItem
    }
    
    func loadPokemonDetails() {
        guard let id = pokemonListItem?.id else { return }
        detailsLoader?.getPokemonDetails(by: String(id)) { result in
            switch result {
            case let .success(pokemon):
                
                print(pokemon.images)
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func getPokemonName() -> String {
        return pokemonListItem?.name ?? ""
    }
    
    func getPokemonNumber() -> String {
        guard let id = pokemonListItem?.id else { return "" }
        return "#\(id)"
    }
}
