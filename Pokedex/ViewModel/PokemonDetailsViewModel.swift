//
//  PokemonDetailsViewModel.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 16/12/22.
//

import Foundation
import RxSwift
import RxCocoa

protocol PokemonDetailsViewModelProtocol {
    func loadPokemonDetails()
    func reloadPokemonFromPicker(with id: Int)
    func showAbilityDescription(_ abilityId: Int)
    func navigateToEquivalentPokemons(with type: PokemonDetailsType)
    var pokemonImages: Driver<[String]> { get }
    var pokemonStats: Driver<[String: Int]> { get }
    var errorDriver: Driver<Bool> { get }
    var pokemonAbilities: Driver<[PokemonDetailsAbility]> { get }
    var pokemonTypes: Driver<[PokemonDetailsType]> { get }
    var pokemonSpecies: Driver<[PokemonSpeciesItem]> { get }
    var pokemonIdDriver: Driver<String> { get }
    var pokemonNameDriver: Driver<String> { get }
}

final class PokemonDetailsViewModel: PokemonDetailsViewModelProtocol {
    private weak var coordinator: RootCoordinator?
    private var pokemonListItem: PokemonListItem?
    private var detailsLoader: PokemonDetailsLoader?
    private var speciesLoader: PokemonSpeciesLoader?
    
    init(pokemonListItem: PokemonListItem, coordinator: RootCoordinator, detailsLoader: PokemonDetailsLoader, speciesLoader: PokemonSpeciesLoader) {
        self.pokemonListItem = pokemonListItem
        self.coordinator = coordinator
        self.detailsLoader = detailsLoader
        self.speciesLoader = speciesLoader
    }
    
    private var pokemonImagesRelay = BehaviorRelay<[String]>(value: [])
    var pokemonImages: Driver<[String]> {
        return pokemonImagesRelay.asDriver(onErrorJustReturn: [])
    }
    
    private var pokemonStatsRelay = BehaviorRelay<[String: Int]>(value: ["": 0])
    var pokemonStats: Driver<[String: Int]> {
        return pokemonStatsRelay.asDriver(onErrorJustReturn: ["": 0])
    }
    
    private var pokemonAbilitiesRelay = BehaviorRelay<[PokemonDetailsAbility]>(value: [])
    var pokemonAbilities: Driver<[PokemonDetailsAbility]> {
        return pokemonAbilitiesRelay.asDriver(onErrorJustReturn: [])
    }
    
    private var pokemonTypesRelay = BehaviorRelay<[PokemonDetailsType]>(value: [])
    var pokemonTypes: Driver<[PokemonDetailsType]> {
        return pokemonTypesRelay.asDriver(onErrorJustReturn: [])
    }
    
    private var pokemonSpeciesRelay = BehaviorRelay<[PokemonSpeciesItem]>(value: [])
    var pokemonSpecies: Driver<[PokemonSpeciesItem]> {
        return pokemonSpeciesRelay.asDriver(onErrorJustReturn: [])
    }
    
    private var pokemonIdRelay = BehaviorRelay<String>(value: "")
    var pokemonIdDriver: Driver<String> {
        return pokemonIdRelay.asDriver(onErrorJustReturn: "")
    }
    
    private var pokemonNameRelay = BehaviorRelay<String>(value: "")
    var pokemonNameDriver: Driver<String> {
        return pokemonNameRelay.asDriver(onErrorJustReturn: "")
    }
    
    private var errorRelay = BehaviorRelay<Bool>(value: false)
    var errorDriver: Driver<Bool> {
        return errorRelay.asDriver(onErrorJustReturn: false)
    }
    
    func loadPokemonDetails() {
        guard let id = pokemonListItem?.id else { return }
        
        detailsLoader?.getPokemonDetails(by: String(id)) { [weak self] result in
            switch result {
            case let .success(pokemon):
                guard let self = self else { return }
                self.updateRelays(with: pokemon)
            case .failure:
                self?.errorRelay.accept(true)
            }
        }
        
        speciesLoader?.getPokemonVarieties(by: id) { [weak self] result in
            switch result {
            case let .success(speciesList):
                self?.pokemonSpeciesRelay.accept(speciesList)
            case .failure:
                self?.errorRelay.accept(true)
            }
        }
    }
    
    func reloadPokemonFromPicker(with id: Int) {
        detailsLoader?.getPokemonDetails(by: String(id)) { [weak self] result in
            switch result {
            case let .success(pokemon):
                guard let self = self else { return }
                self.updateRelays(with: pokemon)
            case .failure:
                self?.errorRelay.accept(true)
            }
        }
    }
    
    func showAbilityDescription(_ abilityId: Int) {
        coordinator?.showAbilityDescription(abilityId)
    }
    
    func navigateToEquivalentPokemons(with type: PokemonDetailsType) {
        coordinator?.navigateToEquivalentPokemons(with: type)
    }
    
    func getPokemonSpeciesDriver() -> Driver<[PokemonSpeciesItem]> {
        return pokemonSpecies
    }
    
    private func imagesList(from images: [String?]) -> [String] {
        return images.compactMap { $0 }
    }
    
    private func formattedId(_ id: Int) -> String {
        return "#\(id)"
    }
    
    private func updateRelays(with pokemon: PokemonDetailsItem) {
        self.pokemonImagesRelay.accept(self.imagesList(from: pokemon.images))
        self.pokemonStatsRelay.accept(pokemon.stats)
        self.pokemonAbilitiesRelay.accept(pokemon.abilities)
        self.pokemonTypesRelay.accept(pokemon.types)
        self.pokemonIdRelay.accept(self.formattedId(pokemon.id))
        self.pokemonNameRelay.accept(pokemon.name)
    }
}
