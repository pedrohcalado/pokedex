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
    func showPokemons(with typeId: Int)
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
    
    private lazy var baseStatsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [typesSectionTitle, typesStackView])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var typesSectionTitle: UILabel = {
        let title = UILabel()
        title.text = NSLocalizedString("types-title", comment: "")
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: 20, weight: .bold)
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
        types.forEach { type in
            
            let typeButton: UIButton = {
                let button = UIButton(type: .system)
                button.setTitle(type.name, for: .normal)
                button.backgroundColor = .lightGray
                button.layer.cornerRadius = 10
                button.translatesAutoresizingMaskIntoConstraints = false
                return button
            }()
            
            bindButton(typeButton, typeId: type.id)
            
            typesStackView.addArrangedSubview(typeButton)
        }
    }
    
    private func bindButton(_ button: UIButton, typeId: Int) {
        button
            .rx
            .tap
            .subscribe(onNext: { [weak self] _ in
                self?.delegate?.showPokemons(with: typeId)
            }).disposed(by: disposeBag)
    }
}

extension PokemonTypesView: ViewCode {
    func buildHierarchy() {
        addSubview(baseStatsStackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            typesStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            typesStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
    
    func applyAdditionalChanges() {
        
    }
    
}
