//
//  PokemonListViewController.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 15/12/22.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

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
        
        navigationItem.title  = "Pokedex"
        view.backgroundColor = .systemBackground
        searchBar.searchResultsUpdater = self
        navigationItem.searchController = searchBar
        view.addSubview(pokemonListCollectionView)
        configureUI()
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
        
    private lazy var pokemonListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3 - 10, height: 200)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(PokemonListCell.self, forCellWithReuseIdentifier: PokemonListCell.ID)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    func configureUI(){
        NSLayoutConstraint.activate([
            pokemonListCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pokemonListCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pokemonListCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            pokemonListCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
    }
}

// MARK: - Extensions

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
            .bind(to: pokemonListCollectionView.rx.items(cellIdentifier: PokemonListCell.ID, cellType: PokemonListCell.self)) { index, model, cell in
                cell.bind(data: model, delegate: self)
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

// MARK: - Delegate

extension PokemonListViewController: PokemonListCellDelegate {
    func fetchImage(by id: Int, completion: @escaping (UIImage?) -> Void) {
        
    }
}
