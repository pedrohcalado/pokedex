//
//  PokemonDetailsViewController.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 16/12/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SDWebImage

final class PokemonDetailsViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private var viewModel: PokemonDetailsViewModelProtocol?
    
    init(viewModel: PokemonDetailsViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel?.loadPokemonDetails()
    }
    
    private lazy var baseStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [carouselView])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var pokemonNumber: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.isEnabled = false
        button.tintColor = .black
        button.title = viewModel?.getPokemonNumber()
        return button
    }()
    
    private lazy var carouselView: CarouselView = {
        let carousel = CarouselView()
        carousel.translatesAutoresizingMaskIntoConstraints = false
        return carousel
    }()
}

// MARK: - Extensions

extension PokemonDetailsViewController: ViewCode {
    func buildHierarchy() {
        view.addSubview(carouselView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
//            baseStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            baseStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            baseStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            baseStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            
            carouselView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            carouselView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            carouselView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            carouselView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func applyAdditionalChanges() {
        navigationItem.title = viewModel?.getPokemonName()
        navigationItem.setRightBarButton(pokemonNumber, animated: false)
        view.backgroundColor = .white
    }
    
}

extension PokemonDetailsViewController {
    func bindViews() {
        viewModel?
            .pokemonImages
            .asObservable()
            .bind(onNext: { [weak self] images in
                self?.carouselView.configureView(with: images)
            }).disposed(by: disposeBag)
    }
}
