//
//  AbilityDescription.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 18/12/22.
//

import Foundation
import UIKit
import RxSwift

class AbilityDescriptionViewController: UIViewController, ViewCode {
    let disposeBag = DisposeBag()
    
    func buildHierarchy() {
        view.addSubview(containerView)
        containerView.addSubview(abilityDescriptionTitle)
        containerView.addSubview(abilityDescription)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            abilityDescriptionTitle.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor, constant: 20),
            abilityDescriptionTitle.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor),
            abilityDescriptionTitle.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor),
            
            abilityDescription.topAnchor.constraint(equalTo: abilityDescriptionTitle.topAnchor, constant: 50),
            abilityDescription.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            abilityDescription.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
    
    func applyAdditionalChanges() {
        view.backgroundColor = .white
    }
    
    private var viewModel: AbilityDescriptionViewModelProtocol?
    
    init(abilityId: Int, viewModel: AbilityDescriptionViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViews()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel?.loadAbilityDescription()
    }
    
    private lazy var containerView: UIView = {
       let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var abilityDescriptionTitle: UILabel = {
        let title = UILabel()
        title.text = NSLocalizedString("ability-description-title", comment: "")
        title.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        title.textColor = .black
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private lazy var abilityDescription: UILabel = {
        let description = UILabel()
        description.numberOfLines = 0
        description.font = UIFont.systemFont(ofSize: 14)
        description.textColor = .black
        description.textAlignment = .natural
        description.translatesAutoresizingMaskIntoConstraints = false
        return description
    }()
    
    private func bindViews() {
        viewModel?
            .descriptionsDriver
            .asObservable()
            .subscribe(onNext: { [weak self] description in
                self?.abilityDescription.text = description
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

extension AbilityDescriptionViewController {
    private func showAlert() {
        let alert = UIAlertController(
            title: NSLocalizedString("ability-error-message", comment: ""),
            message: NSLocalizedString("try-again-message", comment: ""),
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .cancel)
        
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
}
