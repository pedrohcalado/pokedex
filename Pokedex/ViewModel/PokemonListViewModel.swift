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
    private var service: PokemonListLoader?
    
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
    
    init(coordinator: RootCoordinator?, service: PokemonListLoader) {
        self.coordinator = coordinator
        self.service = service
    }
    
    func loadPokemons() {
        offset = 0
        loadedPokemons = []
        service?.loadPokemonList(offset: offset, limit: 20, completion: { [weak self] result in
            switch result {
            case let .success(pokemons):
                print(pokemons)
                self?.loadedPokemons.append(contentsOf: pokemons)
            case .failure:
                // FIX HERE
                break
            }
        })
    }
    
    func loadPokemonsOnScrolling() {
        offset += 20
        service?.loadPokemonList(offset: offset, limit: 20, completion: { [weak self] result in
            switch result {
            case let .success(pokemons):
                print(pokemons)
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
//            service?.getPokemon(by: text) { [weak self] result in
//                switch result {
//                case let .success(pokemon):
//                    self?.filteredPokemons = [pokemon]
//                case .failure:
//                    // fix here
//                    break
//                }
//            }
        } else {
            filteredPokemons = pokemons
        }
    
    }
}
