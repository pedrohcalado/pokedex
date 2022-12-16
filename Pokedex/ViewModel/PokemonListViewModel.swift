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
    
    private var pokemonsRelay = BehaviorRelay<[PokemonListItem]>(value: [])
    var pokemonsList: Driver<[PokemonListItem]> {
        return pokemonsRelay.asDriver(onErrorJustReturn: [])
    }
    
    init(coordinator: RootCoordinator?, service: PokemonListLoader) {
        self.coordinator = coordinator
        self.service = service
    }
    
    func loadPokemons() {
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
}
