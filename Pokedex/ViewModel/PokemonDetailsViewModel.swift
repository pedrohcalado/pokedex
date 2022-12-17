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
    
    func loadPokemonDetails() {
        guard let id = pokemonListItem?.id else { return }
        detailsLoader?.getPokemonDetails(by: String(id)) { [weak self] result in
            switch result {
            case let .success(pokemon):
                guard let self = self else { return }
                self.pokemonImagesRelay.accept(self.imagesList(from: pokemon.images))
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
    
    private func imagesList(from images: [String?]) -> [String] {
        return images.compactMap { $0 }
    }
}
