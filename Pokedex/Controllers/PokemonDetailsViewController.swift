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
        viewModel?.loadPokemonDetails()
    }
    
    private lazy var pokemonNumber: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.isEnabled = false
        button.tintColor = .black
        return button
    }()
    
    private lazy var carouselView: CarouselView = {
        let carousel = CarouselView()
        carousel.translatesAutoresizingMaskIntoConstraints = false
        return carousel
    }()
    
    private lazy var baseStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [varietiesView, abilitiesView, typesView, statsView])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var statsView: PokemonStatsView = {
        let statsView = PokemonStatsView()
        return statsView
    }()
    
    private lazy var abilitiesView: PokemonAbilitiesView = {
        let abilitiesView = PokemonAbilitiesView(delegate: self)
        return abilitiesView
    }()
    
    private lazy var typesView: PokemonTypesView = {
        let typesView = PokemonTypesView(delegate: self)
        return typesView
    }()
    
    private lazy var varietiesView: PokemonVarietiesView = {
        let varietiesView = PokemonVarietiesView(pokemonVarieties: [], delegate: self)
        return varietiesView
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
            carouselView.bottomAnchor.constraint(equalTo: baseStackView.topAnchor, constant: 20),
            carouselView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            carouselView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            baseStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            baseStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            baseStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func applyAdditionalChanges() {
        navigationItem.setRightBarButton(pokemonNumber, animated: false)
        view.backgroundColor = UIColor(red: 239/255, green: 245/255, blue: 245/255, alpha: 1)
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
        
        viewModel?
            .pokemonAbilities
            .asObservable()
            .bind(onNext: { [weak self] abilities in
                self?.abilitiesView.setAbilities(to: abilities)
            }).disposed(by: disposeBag)
        
        viewModel?
            .pokemonTypes
            .asObservable()
            .bind(onNext: { [weak self] types in
                self?.typesView.setTypes(to: types)
            }).disposed(by: disposeBag)
        
        viewModel?
            .pokemonIdDriver
            .asObservable()
            .bind(onNext: { [weak self] pokemonId in
                self?.pokemonNumber.title = pokemonId
            }).disposed(by: disposeBag)
        
        viewModel?
            .pokemonNameDriver
            .asObservable()
            .bind(onNext: { [weak self] pokemonName in
                self?.navigationItem.title = pokemonName
            }).disposed(by: disposeBag)
        
        viewModel?
            .errorDriver
            .asObservable()
            .subscribe(onNext: { [weak self] showAlert in
                if showAlert {
                    self?.showAlert()
                }
            }).disposed(by: disposeBag)

    }
}

extension PokemonDetailsViewController {
    private func showAlert() {
        let alert = UIAlertController(
            title: NSLocalizedString("details-error-message", comment: ""),
            message: NSLocalizedString("try-again-message", comment: ""),
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .cancel)
        
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
}

// MARK: - Delegates

extension PokemonDetailsViewController: PokemonAbilitiesDelegate {
    func showAbilityDescription(_ abilityId: Int) {
        viewModel?.showAbilityDescription(abilityId)
    }
}

extension PokemonDetailsViewController: PokemonTypesDelegate {
    func showPokemons(with type: PokemonDetailsType) {
        viewModel?.navigateToEquivalentPokemons(with: type)
    }
}

extension PokemonDetailsViewController: PokemonVaietiesViewDelegate {
    func reloadDetails(with pokemonId: Int) {
        viewModel?.reloadPokemonFromPicker(with: pokemonId)
    }
    
    func getPokemonSpeciesDriver() -> Driver<[PokemonSpeciesItem]> {
        guard let viewModel = viewModel else {
            return BehaviorRelay<[PokemonSpeciesItem]>(value: []).asDriver()
        }
        return viewModel.pokemonSpecies
    }
}
