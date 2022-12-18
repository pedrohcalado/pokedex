//
//  AbilityDescriptionLoader.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 18/12/22.
//

import Foundation

protocol AbilityDescriptionLoader {
    typealias Result = Swift.Result<AbilityItem, Error>
    func getAbilityDescription(by id: Int, completion: @escaping (Result) -> Void)
}
