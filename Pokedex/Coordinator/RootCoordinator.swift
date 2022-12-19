//
//  RootCoordinator.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 15/12/22.
//

import Foundation

protocol RootCoordinator: AnyObject {
    func navigateToDetails(with pokemon: PokemonListItem)
    func navigateToEquivalentPokemons(with type: PokemonDetailsType)
    func showAbilityDescription(_ id: Int)
}
