//
//  PokemonsListViewControllerTests.swift
//  PokedexTests
//
//  Created by Pedro Henrique Calado on 19/12/22.
//

import XCTest
import RxSwift
import RxCocoa

//@testable import Pokedex
class PokemonsListViewControllerTests: XCTestCase {
    func test_init_doesNotLoadPokemons() {
        let (_, viewModel) = makeSUT()
        
        XCTAssertEqual(viewModel.loadPokemonsCount, 0, "Expect no load requests before view is loaded")
    }
    
    func test_init_requestLoadPokemonsWhenViewIsLoaded() {
        let (sut, viewModel) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(viewModel.loadPokemonsCount, 1, "Expect one load requests when the view is loaded, got \(viewModel.loadPokemonsCount)")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: PokemonListViewController, viewModel: PokemonsListViewModelSpy) {
            let viewModel = PokemonsListViewModelSpy()
            let sut = PokemonListViewController(viewModel: viewModel)
        
            return (sut, viewModel)
        }
    
    class PokemonsListViewModelSpy: PokemonListViewModelProtocol {
        
        var loadPokemonsCount = 0
        
        func loadPokemons() {
            loadPokemonsCount += 1
        }
        
        func loadPokemonsOnScrolling() {}
        
        func navigateToDetails(with model: PokemonListItem) {}
        
        func filterPokemonsBy(_ text: String) {}
        
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
        
    }
    
}
