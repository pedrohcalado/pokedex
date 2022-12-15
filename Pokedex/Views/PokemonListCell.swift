//
//  PokemonListCell.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 15/12/22.
//

import UIKit

class PokemonListCell: UICollectionViewCell {
    
    func bind(data: PokemonListItem?) {
        if let pokemonData = data {
            let id = pokemonData.url.split(separator: "/").last ?? ""
            
            self.pokemonName.text = pokemonData.name
            self.pokemonId = String(id)
            
            loadPokemonImage()
        }
    }
    
    private var pokemonId: String?
    
    private lazy var containerView: UIView = {
       let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [pokemonImageView, pokemonName])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var pokemonName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(12)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    private lazy var pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func loadPokemonImage(){
        guard let pokemonId = pokemonId else {
            return
        }

        let imageURL = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(pokemonId).png"
        guard let url = URL(string: imageURL) else { return }
        self.pokemonImageView.sd_setImage(with: url)
            
    
    }
}

// MARK: - Extensions
extension PokemonListCell: ViewCode {
    func buildHierarchy() {
        contentView.addSubview(containerView)
        containerView.addSubview(stackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
//            pokemonImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
//            pokemonImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 80),
//            pokemonImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
//            pokemonImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            pokemonImageView.heightAnchor.constraint(equalToConstant: 80),
            
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    func applyAdditionalChanges() {
//        contentView.layer.borderWidth = 3
        contentView.layer.borderColor = UIColor.gray.cgColor
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
}

public extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
