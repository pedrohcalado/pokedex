//
//  PokemonListCell.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 15/12/22.
//

import UIKit

protocol PokemonListCellDelegate {
    func fetchImage(by id: Int, completion: @escaping (_ image: UIImage?) -> Void)
}

class PokemonListCell: UICollectionViewCell {
    static let ID = "PokemonCell"
    
    var delegate: PokemonListCellDelegate?
    
    func bind(data: PokemonListItem?, delegate: PokemonListCellDelegate?) {
        if let pokemonData = data, let delegate = delegate {
            self.pokemonName.text = pokemonData.name
            
            self.delegate = delegate
        }

    }
    
    private lazy var pokemonName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(12)
        label.textColor = .black
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
        addSubview(pokemonImageView)
        addSubview(pokemonName)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureUI(){
        NSLayoutConstraint.activate([
            pokemonImageView.topAnchor.constraint(equalTo: topAnchor),
            pokemonImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            pokemonImageView.leftAnchor.constraint(equalTo: leftAnchor),
            pokemonImageView.rightAnchor.constraint(equalTo: rightAnchor),
            
            pokemonName.topAnchor.constraint(equalTo: topAnchor),
            pokemonName.bottomAnchor.constraint(equalTo: bottomAnchor),
            pokemonName.leftAnchor.constraint(equalTo: leftAnchor),
            pokemonName.rightAnchor.constraint(equalTo: rightAnchor)
        ])
        
        contentView.layer.borderWidth = 3
        contentView.layer.borderColor = UIColor.gray.cgColor
    }
    
    func updateCell(imageURL: String){
        guard let url = URL(string: imageURL) else { return }
//        self.pokemonImageView.sd_setImage(with: url)
    }
}
