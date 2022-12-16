//
//  PokemonListViewModel.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 15/12/22.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

protocol PokemonListViewModelProtocol {
    func loadPokemons()
    func loadPokemonsOnScrolling()
    func filterPokemonsBy(_ text: String)
    var pokemonsList: Driver<[PokemonListItem]> { get }
}

final class PokemonListViewModel: PokemonListViewModelProtocol {
    private weak var coordinator: RootCoordinator?
    private var listLoader: PokemonListLoader?
    private var detailsLoader: PokemonDetailsLoader?
    
    private var offset = 0
    
    private var loadedPokemons: [PokemonListItem] = [] {
        didSet {
            pokemonsRelay.accept(loadedPokemons)
        }
    }
    
    private var filteredPokemons: [PokemonListItem] = [] {
        didSet {
            pokemonsRelay.accept(filteredPokemons)
        }
    }
    
    private var pokemonsRelay = BehaviorRelay<[PokemonListItem]>(value: [])
    var pokemonsList: Driver<[PokemonListItem]> {
        return pokemonsRelay.asDriver(onErrorJustReturn: [])
    }
    
    init(coordinator: RootCoordinator?, listLoader: PokemonListLoader, detailsLoader: PokemonDetailsLoader) {
        self.coordinator = coordinator
        self.listLoader = listLoader
        self.detailsLoader = detailsLoader
    }
    
    func loadPokemons() {
        offset = 0
        loadedPokemons = []
        listLoader?.loadPokemonList(offset: offset, limit: 20, completion: { [weak self] result in
            switch result {
            case let .success(pokemons):
                self?.loadedPokemons.append(contentsOf: pokemons)
            case .failure:
                // FIX HERE
                break
            }
        })
    }
    
    func loadPokemonsOnScrolling() {
        offset += 20
        listLoader?.loadPokemonList(offset: offset, limit: 20, completion: { [weak self] result in
            switch result {
            case let .success(pokemons):
                self?.loadedPokemons.append(contentsOf: pokemons)
            case .failure:
                // FIX HERE
                break
            }
        })
    }
    
    func filterPokemonsBy(_ text: String) {
        if text.isEmpty {
            filteredPokemons = loadedPokemons
            return
        }
        
        let pokemons = loadedPokemons.filter {
            $0.name.contains(text.lowercased()) ||
            String($0.id).contains(text) }
        
        if pokemons.isEmpty {
            detailsLoader?.getPokemonDetails(by: text) { result in
                switch result {
                case let .success(pokemon):
                    self.filteredPokemons = [PokemonListItem(name: pokemon.name, url: "https://pokeapi.co/api/v2/pokemon/\(pokemon.id)")]
                case .failure:
                    return
                }
            }
        } else {
            filteredPokemons = pokemons
        }
    
    }
}
