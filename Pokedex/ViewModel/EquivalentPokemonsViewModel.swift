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
    var typeNameDriver: Driver<String> { get }
}

final class EquivalentPokemonsViewModel: EquivalentPokemonsViewModelProtocol {
    private var listLoader: EquivalentPokemonsLoader?
    
    private var startIndex = 0
    private var endIndex = 20
    
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
    
    private var typeNameRelay = BehaviorRelay<String>(value: "")
    var typeNameDriver: Driver<String> {
        return typeNameRelay.asDriver(onErrorJustReturn: "")
    }
    
    private var typeModel: PokemonDetailsType?
    
    init(type: PokemonDetailsType, listLoader: EquivalentPokemonsLoader) {
        self.listLoader = listLoader
        self.typeModel = type
    }
    
    func loadPokemons() {
        resetConfig()
        isLoadingRelay.accept(true)
        typeNameRelay.accept(typeModel?.name ?? NSLocalizedString("list-controller-title", comment: ""))
        
        guard let typeId = typeModel?.id else { return }
        
        listLoader?.getEquivalentPokemons(by: typeId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(pokemons):
                self.pokemons.append(contentsOf: pokemons)
                self.setPokemonsToLoad(from: self.startIndex, to: self.endIndex)
            case .failure:
                self.errorRelay.accept(true)
            }
            self.isLoadingRelay.accept(false)
        }
    }
    
    func loadPokemonsOnScrolling() {
        if endIndex < pokemons.count {
            let doubledEndIndex = endIndex * 2
            startIndex = endIndex
            endIndex = doubledEndIndex < pokemons.count ? doubledEndIndex : pokemons.count - 1
            setPokemonsToLoad(from: startIndex, to: endIndex)
        }
    }
    
    private func setPokemonsToLoad(from startIndex: Int, to endIndex: Int) {
        loadedPokemons.append(contentsOf: pokemons[startIndex..<endIndex])
        pokemonsRelay.accept(loadedPokemons)
    }
    
    private func resetConfig() {
        loadedPokemons = []
        pokemons = []
        startIndex = 0
        endIndex = 20
    }
}
