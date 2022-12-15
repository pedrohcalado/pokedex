//
//  PokemonListViewModel.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 15/12/22.
//

import Foundation

protocol PokemonListViewModelProtocol {
    
}

final class PokemonListViewModel: PokemonListViewModelProtocol {
    private weak var coordinator: RootCoordinator?
        
    init(coordinator: RootCoordinator?) {
        self.coordinator = coordinator
    }
}
