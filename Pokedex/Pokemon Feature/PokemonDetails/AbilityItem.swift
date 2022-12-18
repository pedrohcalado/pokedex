//
//  AbilityItem.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 18/12/22.
//

import Foundation

struct AbilityItem {
    let descriptions: [AbilityDescription]
    
    init(description: [AbilityDescription]) {
        self.descriptions = description
    }
}

struct AbilityDescription {
    let effect: String
    let language: String
}
