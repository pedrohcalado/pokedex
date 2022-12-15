//
//  ViewCode.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 15/12/22.
//

import Foundation

protocol ViewCode {
    func buildHierarchy()
    func setupConstraints()
    func applyAdditionalChanges()
}

extension ViewCode {
    func setupView() {
        buildHierarchy()
        setupConstraints()
        applyAdditionalChanges()
    }
    
//    func buildHierarchy() {}
//    func setupConstraints() {}
//    func applyAdditionalChanges() {}
}
