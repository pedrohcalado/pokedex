//
//  EquivalentPokemonViewController.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 18/12/22.
//

import Foundation

import UIKit
import RxSwift
import RxCocoa

final class EquivalentPokemonViewController: UIViewController {
    private var viewModel: EquivalentPokemonsViewModelProtocol?
    private let disposeBag = DisposeBag()
    
    init(viewModel: EquivalentPokemonsViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        setupView()
        bindViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel?.loadPokemons()
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3 - 5, height: 130)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(PokemonListCell.self, forCellWithReuseIdentifier: PokemonListCell.identifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        return view
    }()
    
    private lazy var reloadButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(systemName: "arrow.clockwise")
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [activityIndicatorView, collectionView])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
}

// MARK: - Extensions

extension EquivalentPokemonViewController: ViewCode {
    func buildHierarchy() {
        view.addSubview(stackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func applyAdditionalChanges() {
        navigationItem.title  = NSLocalizedString("list-controller-title", comment: "")
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = reloadButton
    }
}

extension EquivalentPokemonViewController {
    func bindViews() {
        viewModel?
            .pokemonsList
            .asObservable()
            .bind(to: collectionView.rx.items(cellIdentifier: PokemonListCell.identifier, cellType: PokemonListCell.self)) { index, model, cell in
                cell.bind(data: model)
            }.disposed(by: disposeBag)
        
        viewModel?
            .errorDriver
            .asObservable()
            .subscribe(onNext: { [weak self] showAlert in
                if showAlert {
                    self?.showAlert()
                }
            }).disposed(by: disposeBag)
            
        viewModel?
            .isLoadingDriver
            .asObservable()
            .subscribe(onNext: { [weak self] isLoading in
                isLoading ?
                self?.activityIndicatorView.startAnimating() :
                self?.activityIndicatorView.stopAnimating()
                
            }).disposed(by: disposeBag)
        
        reloadButton
            .rx
            .tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel?.loadPokemons()
            }).disposed(by: disposeBag)
    }
}

extension EquivalentPokemonViewController {
    private func showAlert() {
        let alert = UIAlertController(
            title: NSLocalizedString("list-error-message", comment: ""),
            message: NSLocalizedString("try-again-message", comment: ""),
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .cancel)
        
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
}

// MARK: - Delegates

extension EquivalentPokemonViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.isDragging else { return }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if (offsetY > contentHeight - scrollView.frame.height) {
            viewModel?.loadPokemonsOnScrolling()
        }
    }
}
