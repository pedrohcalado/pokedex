//
//  PokemonAbilitiesView.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 18/12/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol PokemonAbilitiesDelegate {
    func showAbilityDescription(_ abilityId: Int)
}

final class PokemonAbilitiesView: UIView {
    var delegate: PokemonAbilitiesDelegate?
    let disposeBag = DisposeBag()
    
    init(delegate: PokemonAbilitiesDelegate?) {
        super.init(frame: .zero)
        self.delegate = delegate
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var baseAbilitiesStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [abilitiesSectionTitle, abilitiesStackView])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var abilitiesSectionTitle: UILabel = {
        let title = UILabel()
        title.text = NSLocalizedString("abilities-title", comment: "")
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: 18, weight: .bold)
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
        abilitiesStackView.removeAllArrangedSubviews()
        abilities.forEach { ability in
            
            let abilityButton: UIButton = {
                let button = UIButton(type: .system)
                button.setTitle(ability.name, for: .normal)
                button.backgroundColor = .lightGray
                button.layer.cornerRadius = 10
                button.translatesAutoresizingMaskIntoConstraints = false
                return button
            }()
            
            bindButton(abilityButton, id: ability.id)
            
            abilitiesStackView.addArrangedSubview(abilityButton)
        }
    }
    
    private func bindButton(_ button: UIButton, id: Int) {
        button
            .rx
            .tap
            .subscribe(onNext: { [weak self] _ in
                self?.delegate?.showAbilityDescription(id)
            }).disposed(by: disposeBag)
    }
}

extension PokemonAbilitiesView: ViewCode {
    func buildHierarchy() {
        addSubview(baseAbilitiesStackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            baseAbilitiesStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            baseAbilitiesStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            baseAbilitiesStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            baseAbilitiesStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func applyAdditionalChanges() {
        
    }
    
}
