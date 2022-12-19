//
//  PokemonStatsView.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 18/12/22.
//

import Foundation
import UIKit

final class PokemonStatsView: UIView {
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    func setStats(to stats: [String: Int]) {
        statsValuesStackView.removeAllArrangedSubviews()
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

extension PokemonStatsView: ViewCode {
    func buildHierarchy() {
        addSubview(baseStatsStackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            statsValuesStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            statsValuesStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
    
    func applyAdditionalChanges() {
        
    }
    
}
