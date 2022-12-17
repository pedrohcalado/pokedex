//
//  CarouselCell.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 17/12/22.
//

import Foundation
import UIKit
import SDWebImage

class CarouselCell: UICollectionViewCell {
    
    // MARK: - SubViews
    
    private lazy var imageView = UIImageView()
    
    // MARK: - Properties
    
    static let cellId = "CarouselCell"
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
}

// MARK: - Setups
private extension CarouselCell {
    func setupUI() {
        backgroundColor = .clear
        
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 24
    }
}

// MARK: - Public
extension CarouselCell {
    public func configure(imageURL: URL?) {
        imageView.sd_setImage(with: imageURL)
    }
}
