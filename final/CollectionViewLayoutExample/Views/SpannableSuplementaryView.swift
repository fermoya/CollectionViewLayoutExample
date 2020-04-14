//
//  SectionTitleView.swift
//  CollectionViewLayoutExample
//
//  Created by Fernando Moya de Rivas on 05/04/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import UIKit

class SpannableSuplementaryView: UICollectionReusableView {

    var title: String? {
        set {
            titleLabel.text = newValue
        }
        get { titleLabel.text }
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 25, weight: .medium)
        return label
    }()

    override func didMoveToWindow() {
        super.didMoveToWindow()

        guard subviews.isEmpty else { return }

        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
    }

}
