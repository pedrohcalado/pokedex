//
//  AbilityDescription.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 18/12/22.
//

import Foundation
import UIKit

class AbilityDescriptionViewController: UIViewController, ViewCode {
    func buildHierarchy() {
        view.addSubview(containerView)
        containerView.addSubview(abilityDescription)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            abilityDescription.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor, constant: 20),
            abilityDescription.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor),
            abilityDescription.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func applyAdditionalChanges() {
        view.backgroundColor = .white
    }
    
    private var viewModel: PokemonDetailsViewModelProtocol?
    
    init(abilityId: Int, viewModel: PokemonDetailsViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel?.loadAbilityDescription()
    }
    
    private lazy var containerView: UIView = {
       let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var abilityDescription: UILabel = {
        let description = UILabel()
        description.text = NSLocalizedString("ability-description-title", comment: "")
        description.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        description.textColor = .black
        description.textAlignment = .center
        description.translatesAutoresizingMaskIntoConstraints = false
        return description
    }()
    
}
