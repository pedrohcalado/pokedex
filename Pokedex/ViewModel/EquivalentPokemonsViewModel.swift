//
//  EquivalentPokemonsViewModel.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 18/12/22.
//

import Foundation
import RxSwift
import RxCocoa

protocol EquivalentPokemonsViewModelProtocol {
    func loadPokemons()
    func loadPokemonsOnScrolling()
    var pokemonsList: Driver<[PokemonListItem]> { get }
    var errorDriver: Driver<Bool> { get }
    var isLoadingDriver: Driver<Bool> { get }
}

final class EquivalentPokemonsViewModel: EquivalentPokemonsViewModelProtocol {
    private var listLoader: EquivalentPokemonsLoader?
    
    private var startIndex = 0
    private var offset = 20
    
    private var pokemons: [PokemonListItem] = []
    
    private var loadedPokemons: [PokemonListItem] = []
    
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
    
    private var typeId: Int?
    
    init(typeId: Int, listLoader: EquivalentPokemonsLoader) {
        self.listLoader = listLoader
        self.typeId = typeId
    }
    
    func loadPokemons() {
        resetConfig()
        isLoadingRelay.accept(true)
        
        guard let typeId = typeId else { return }
        
        listLoader?.getEquivalentPokemons(by: typeId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(pokemons):
                self.pokemons.append(contentsOf: pokemons)
                self.setPokemonsToLoad(from: self.startIndex, to: self.offset)
            case .failure:
                self.errorRelay.accept(true)
            }
            self.isLoadingRelay.accept(false)
        }
    }
    
    func loadPokemonsOnScrolling() {
        startIndex = offset
        offset += startIndex
        setPokemonsToLoad(from: startIndex, to: offset)
    }
    
    private func setPokemonsToLoad(from startIndex: Int, to endIndex: Int) {
        loadedPokemons.append(contentsOf: pokemons[startIndex..<endIndex])
        pokemonsRelay.accept(loadedPokemons)
    }
    
    private func resetConfig() {
        loadedPokemons = []
        pokemons = []
        startIndex = 0
        offset = 20
    }
}
