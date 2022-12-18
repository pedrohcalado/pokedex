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
    func navigateToDetails(with model: PokemonListItem)
    func filterPokemonsBy(_ text: String)
    var pokemonsList: Driver<[PokemonListItem]> { get }
    var errorDriver: Driver<Bool> { get }
    var isLoadingDriver: Driver<Bool> { get }
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
    
    private var errorRelay = BehaviorRelay<Bool>(value: false)
    var errorDriver: Driver<Bool> {
        return errorRelay.asDriver(onErrorJustReturn: false)
    }
    
    private var isLoadingRelay = BehaviorRelay<Bool>(value: false)
    var isLoadingDriver: Driver<Bool> {
        return isLoadingRelay.asDriver(onErrorJustReturn: false)
    }
    
    init(coordinator: RootCoordinator, listLoader: PokemonListLoader, detailsLoader: PokemonDetailsLoader) {
        self.coordinator = coordinator
        self.listLoader = listLoader
        self.detailsLoader = detailsLoader
    }
    
    func loadPokemons() {
        offset = 0
        loadedPokemons = []
        isLoadingRelay.accept(true)
        listLoader?.loadPokemonList(offset: offset, limit: 20, completion: { [weak self] result in
            switch result {
            case let .success(pokemons):
                self?.loadedPokemons.append(contentsOf: pokemons)
            case .failure:
                self?.errorRelay.accept(true)
            }
            self?.isLoadingRelay.accept(false)
        })
    }
    
    func loadPokemonsOnScrolling() {
        offset += 20
        isLoadingRelay.accept(true)
        listLoader?.loadPokemonList(offset: offset, limit: 20, completion: { [weak self] result in
            switch result {
            case let .success(pokemons):
                self?.loadedPokemons.append(contentsOf: pokemons)
            case .failure:
                self?.errorRelay.accept(true)
            }
            self?.isLoadingRelay.accept(false)
        })
    }
    
    func filterPokemonsBy(_ text: String) {
        if text.isEmpty {
            filteredPokemons = loadedPokemons
            return
        }
        
        filteredPokemons = loadedPokemons.filter {
            $0.name.contains(text.lowercased()) ||
            String($0.id).contains(text) }
        
        if filteredPokemons.isEmpty {
            detailsLoader?.getPokemonDetails(by: text) { result in
                switch result {
                case let .success(pokemon):
                    let url = Endpoints.pokemonDetails(by: String(pokemon.id)).url.absoluteString
                    self.filteredPokemons = [PokemonListItem(name: pokemon.name, url: url)]
                case .failure:
                    return
                }
            }
        }
    
    }
}

extension PokemonListViewModel {
    func navigateToDetails(with model: PokemonListItem) {
        coordinator?.navigateToDetails(with: model)
    }
}
