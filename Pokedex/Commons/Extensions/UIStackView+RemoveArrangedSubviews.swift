//
//  UIStackView+RemoveArrangedSubviews.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 19/12/22.
//

import UIKit

extension UIStackView {
    
    func removeAllArrangedSubviews() {
        arrangedSubviews.forEach { (view) in
            removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    
}
