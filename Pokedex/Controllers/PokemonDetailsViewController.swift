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
    
    private lazy var baseStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [statsView])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var statsView: PokemonStatsView = {
        let statsView = PokemonStatsView()
        return statsView
    }()
    
}

// MARK: - Extensions

extension PokemonDetailsViewController: ViewCode {
    func buildHierarchy() {
        view.addSubview(carouselView)
        view.addSubview(baseStackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            carouselView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            carouselView.bottomAnchor.constraint(equalTo: baseStackView.topAnchor),
            carouselView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            carouselView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            carouselView.heightAnchor.constraint(equalToConstant: 300),
            
            baseStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            baseStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            baseStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
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
        
        viewModel?
            .pokemonStats
            .asObservable()
            .bind(onNext: { [weak self] stats in
                self?.statsView.setStats(to: stats)
            }).disposed(by: disposeBag)
    }
}
