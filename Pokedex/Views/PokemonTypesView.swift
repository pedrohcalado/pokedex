//
//  PokemonTypesView.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 18/12/22.
//

import Foundation

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol PokemonTypesDelegate {
    func showPokemons(with type: PokemonDetailsType)
}

final class PokemonTypesView: UIView {
    var delegate: PokemonTypesDelegate?
    let disposeBag = DisposeBag()
    
    init(delegate: PokemonTypesDelegate?) {
        super.init(frame: .zero)
        self.delegate = delegate
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var baseTypesStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [typesSectionTitle, typesStackView])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 5
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var typesSectionTitle: UILabel = {
        let title = UILabel()
        title.text = NSLocalizedString("types-title", comment: "")
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private lazy var typesStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    func setTypes(to types: [PokemonDetailsType]) {
        typesStackView.removeAllArrangedSubviews()
        types.forEach { type in
            
            let typeButton: UIButton = {
                let button = UIButton(type: .system)
                button.setTitle(type.name, for: .normal)
                button.backgroundColor = .lightGray
                button.layer.cornerRadius = 10
                button.translatesAutoresizingMaskIntoConstraints = false
                return button
            }()
            
            bindButton(typeButton, type: type)
            
            typesStackView.addArrangedSubview(typeButton)
        }
    }
    
    private func bindButton(_ button: UIButton, type: PokemonDetailsType) {
        button
            .rx
            .tap
            .subscribe(onNext: { [weak self] _ in
                self?.delegate?.showPokemons(with: type)
            }).disposed(by: disposeBag)
    }
}

extension PokemonTypesView: ViewCode {
    func buildHierarchy() {
        addSubview(baseTypesStackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            baseTypesStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            baseTypesStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            baseTypesStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            baseTypesStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func applyAdditionalChanges() {
        
    }
    
}
