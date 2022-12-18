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
    func getPokemonName() -> String
    func getPokemonNumber() -> String
    var pokemonImages: Driver<[String]> { get }
    var pokemonStats: Driver<[String: Int]> { get }
    var errorDriver: Driver<Bool> { get }
}

final class PokemonDetailsViewModel: PokemonDetailsViewModelProtocol {
    
    private var detailsLoader: PokemonDetailsLoader?
    private var pokemonListItem: PokemonListItem?
    
    init(detailsLoader: PokemonDetailsLoader, pokemonListItem: PokemonListItem) {
        self.detailsLoader = detailsLoader
        self.pokemonListItem = pokemonListItem
    }
    
    private var pokemonImagesRelay = BehaviorRelay<[String]>(value: [])
    var pokemonImages: Driver<[String]> {
        return pokemonImagesRelay.asDriver(onErrorJustReturn: [])
    }
    
    private var pokemonStatsRelay = BehaviorRelay<[String: Int]>(value: ["": 0])
    var pokemonStats: Driver<[String: Int]> {
        return pokemonStatsRelay.asDriver(onErrorJustReturn: ["": 0])
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
                self.pokemonImagesRelay.accept(self.imagesList(from: pokemon.images))
                self.pokemonStatsRelay.accept(pokemon.stats)
            case .failure:
                self?.errorRelay.accept(true)
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
    
    private func imagesList(from images: [String?]) -> [String] {
        return images.compactMap { $0 }
    }
}
