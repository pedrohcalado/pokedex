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
        let stack = UIStackView(arrangedSubviews: [baseStatsStackView])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var baseStatsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [statsSectionTitle, statsValuesStackView])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var statsSectionTitle: UILabel = {
        let title = UILabel()
        title.text = NSLocalizedString("stats-title", comment: "")
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private lazy var statsValuesStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
            
            baseStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            baseStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            baseStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            carouselView.heightAnchor.constraint(equalToConstant: 300),

            
            statsValuesStackView.leadingAnchor.constraint(equalTo: baseStackView.leadingAnchor, constant: 16),
            statsValuesStackView.trailingAnchor.constraint(equalTo: baseStackView.trailingAnchor, constant: -16),
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
                self?.setUpStatsLabel(stats)
            }).disposed(by: disposeBag)
    }
    
    func setUpStatsLabel(_ stats: [String: Int]) {
        stats.forEach { stat, value in
            guard !stat.isEmpty else { return }
            
            let statsLabel: UILabel = {
                let label = UILabel()
                label.textAlignment = .center
                label.text = NSLocalizedString(stat, comment: "")
                label.font = UIFont.systemFont(ofSize: 14)
                label.translatesAutoresizingMaskIntoConstraints = false
                return label
            }()
            
            let valueLabel: UILabel = {
                let label = UILabel()
                label.textAlignment = .center
                label.text = "\(value)"
                label.font = UIFont.systemFont(ofSize: 14)
                label.translatesAutoresizingMaskIntoConstraints = false
                return label
            }()

            let singleStatStackView: UIStackView = {
                let stack = UIStackView(arrangedSubviews: [statsLabel, valueLabel])
                stack.axis = .horizontal
                stack.distribution = .equalSpacing
                stack.translatesAutoresizingMaskIntoConstraints = false
                return stack
            }()
            
            statsValuesStackView.addArrangedSubview(singleStatStackView)
        }
    }
}
