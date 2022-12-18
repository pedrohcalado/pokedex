//
//  AbilityDescriptionViewModel.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 18/12/22.
//

import Foundation
import RxSwift
import RxCocoa

protocol AbilityDescriptionViewModelProtocol {
    func loadAbilityDescription()
    var errorDriver: Driver<Bool> { get }
    var descriptionsDriver: Driver<String> { get }
}

final class AbilityDescriptionViewModel: AbilityDescriptionViewModelProtocol {
    
    var abilitiesLoader: RemoteAbilitiesLoader?
    var abilityId: Int?
    
    init(id: Int, abilitiesLoader: RemoteAbilitiesLoader) {
        self.abilitiesLoader = abilitiesLoader
        self.abilityId = id
    }
    
    private var errorRelay = BehaviorRelay<Bool>(value: false)
    var errorDriver: Driver<Bool> {
        return errorRelay.asDriver(onErrorJustReturn: false)
    }
    
    private var descriptionsRelay = BehaviorRelay<String>(value: "")
    var descriptionsDriver: Driver<String> {
        return descriptionsRelay.asDriver(onErrorJustReturn: "")
    }
    
    func loadAbilityDescription() {
        guard let id = abilityId else { return }
        abilitiesLoader?.getAbilityDescription(by: id) { [weak self] result in
            switch result {
            case let .success(ability):
                self?.descriptionsRelay.accept(self?.getDescriptionInEnglish(ability.descriptions) ?? "")
            case .failure:
                self?.errorRelay.accept(true)
            }
        }
    }
    
    private func getDescriptionInEnglish(_ descriptions: [AbilityDescription]) -> String {
        return descriptions.filter { $0.language == "en" }.first?.effect ?? ""
    }
}
