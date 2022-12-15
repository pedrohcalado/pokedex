//
//  PokemonListViewModel.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 15/12/22.
//

import Foundation
import RxSwift
import RxCocoa

protocol PokemonListViewModelProtocol {
    func loadPokemons()
    var pokemonsList: Driver<[PokemonListItem]> { get }
}

final class PokemonListViewModel: PokemonListViewModelProtocol {
    private weak var coordinator: RootCoordinator?
    private var service: PokemonListLoader?
    
    private var pokemonsRelay = BehaviorRelay<[PokemonListItem]>(value: [])
    var pokemonsList: Driver<[PokemonListItem]> {
        return pokemonsRelay.asDriver(onErrorJustReturn: [])
    }
    
    init(coordinator: RootCoordinator?, service: PokemonListLoader) {
        self.coordinator = coordinator
        self.service = service
    }
    
    func loadPokemons() {
        service?.loadPokemonList(completion: { [weak self] result in
            switch result {
            case let .success(pokemons):
                print(pokemons)
                self?.pokemonsRelay.accept(pokemons)
            case .failure:
                // FIX HERE
                break
            }
        })
    }
}
