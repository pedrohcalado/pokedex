//
//  PokemonListViewController.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 15/12/22.
//

import UIKit
import RxSwift
import RxCocoa

class PokemonListViewController: UIViewController {
    private var viewModel: PokemonListViewModelProtocol?
    private let disposeBag = DisposeBag()
    
    init(viewModel: PokemonListViewModelProtocol) {
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
        bindCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel?.loadPokemons()
    }
    
    private lazy var searchBar: UISearchController = {
        let sb = UISearchController()
        sb.searchBar.placeholder = "Enter pokemon name or id"
        sb.searchBar.searchBarStyle = .minimal
        return sb
    }()
    
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
    
}

// MARK: - Extensions

extension PokemonListViewController: ViewCode {
    func buildHierarchy() {
        view.addSubview(collectionView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func applyAdditionalChanges() {
        navigationItem.title  = "Pokedex"
        view.backgroundColor = .systemBackground
        searchBar.searchResultsUpdater = self
        navigationItem.searchController = searchBar
    }
}

extension PokemonListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //        guard let query = searchController.searchBar.text else { return }
        
        
        
        //        let service = RemotePokemonListLoader(client: AlamofireHTTPClient())
        //
        //        service.loadPokemonList { [weak self] result in
        //            switch result {
        //            case let .success(pokemons):
        //                self?.pokemonsList = pokemons
        //                DispatchQueue.main.async {
        //                    self?.pokemonListCollectionView.reloadData()
        //                }
        //            case .failure:
        //                return
        //            }
        //        }
    }
}

extension PokemonListViewController {
    func bindCollectionView() {
        viewModel?
            .pokemonsList
            .asObservable()
            .bind(to: collectionView.rx.items(cellIdentifier: PokemonListCell.identifier, cellType: PokemonListCell.self)) { index, model, cell in
                cell.bind(data: model)
            }.disposed(by: disposeBag)
        
        //        viewModel?
        //            .pokemonsList
        //            .asObservable()
        //            .subscribe(onNext: { [weak self] list in
        //                pokemonListCollectionView.rx.
        //            }).dispose()
    }
    
    
    //    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //        return pokemonsList.count
    //    }
    //
    //    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonListCell.ID, for: indexPath) as? PokemonListCell {
    //            cell.backgroundColor = .darkGray
    //
    //            cell.updateCell(imageURL: pokemonsList[indexPath.row].url)
    //            return cell
    //        }
    //        return UICollectionViewCell()
    //    }
}

extension PokemonListViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.isDragging else { return }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if (offsetY > contentHeight - scrollView.frame.height) {
            viewModel?.loadPokemonsOnScrolling()
        }
    }
}


