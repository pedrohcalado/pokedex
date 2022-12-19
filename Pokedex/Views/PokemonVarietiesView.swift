//
//  PokemonVarietiesView.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 19/12/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol PokemonVaietiesViewDelegate {
    func reloadDetails(with pokemonId: Int)
    func getPokemonSpeciesDriver() -> Driver<[PokemonSpeciesItem]>
}

final class PokemonVarietiesView: UIView {
    var delegate: PokemonVaietiesViewDelegate?
    let disposeBag = DisposeBag()
    
    var pokemonVarieties: [PokemonSpeciesItem]?
    
    init(pokemonVarieties: [PokemonSpeciesItem], delegate: PokemonVaietiesViewDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        self.pokemonVarieties = pokemonVarieties
        setupView()
        bindPicker()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var baseVarietiesStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [picker])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var varietiesSectionTitle: UILabel = {
        let title = UILabel()
        title.text = NSLocalizedString("varieties-title", comment: "")
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private lazy var picker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        return picker
    }()
    
    private func bindPicker() {
        delegate?
            .getPokemonSpeciesDriver()
            .asObservable()
            .bind(to: picker.rx.itemTitles) { (row, element) in
                return element.pokemon.name
            }.disposed(by: disposeBag)
        
        picker
            .rx
            .modelSelected(PokemonSpeciesItem.self)
            .subscribe(onNext: { [weak self] result in
                guard let pokemonId = result.first?.pokemon.id else { return }
                self?.delegate?.reloadDetails(with: pokemonId)
            }).disposed(by: disposeBag)
    }
}

extension PokemonVarietiesView: ViewCode {
    func buildHierarchy() {
        addSubview(baseVarietiesStackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            baseVarietiesStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            baseVarietiesStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            baseVarietiesStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            baseVarietiesStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
        
    }
    
    func applyAdditionalChanges() {
        
    }
    
    
}
