//
//  PokemonListViewController.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 15/12/22.
//

import UIKit

class PokemonListViewController: UIViewController {
    
    private var viewModel: PokemonListViewModelProtocol?
    
    init(viewModel: PokemonListViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
