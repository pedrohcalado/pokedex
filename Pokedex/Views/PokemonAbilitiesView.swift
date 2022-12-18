//
//  PokemonAbilitiesView.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 18/12/22.
//

import Foundation
import UIKit

final class PokemonAbilitiesView: UIView {
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var baseStatsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [abilitiesSectionTitle, abilitiesStackView])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var abilitiesSectionTitle: UILabel = {
        let title = UILabel()
        title.text = NSLocalizedString("abilities-title", comment: "")
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private lazy var abilitiesStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    func setAbilities(to abilities: [PokemonDetailsAbility]) {
        abilities.forEach { ability in
            
            let abilityButton: UIButton = {
                let button = UIButton(type: .system)
                button.setTitle(ability.name, for: .normal)
                button.backgroundColor = .lightGray
                button.layer.cornerRadius = 10
                button.translatesAutoresizingMaskIntoConstraints = false
                return button
            }()
            
            abilitiesStackView.addArrangedSubview(abilityButton)
        }
    }
}

extension PokemonAbilitiesView: ViewCode {
    func buildHierarchy() {
        addSubview(baseStatsStackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            abilitiesStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            abilitiesStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
    
    func applyAdditionalChanges() {
        
    }
    
}
