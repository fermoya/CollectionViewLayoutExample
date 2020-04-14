//
//  MattrixColletionViewCell.swift
//  CollectionViewLayoutExample
//
//  Created by Fernando Moya de Rivas on 13/04/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import UIKit

class SpannableColletionViewCell: UICollectionViewCell {

    var text: String = "" {
        didSet {
            titlelLabel.text = text
        }
    }

    private var titlelLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 11)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    override func didMoveToWindow() {
        super.didMoveToWindow()
        if contentView.subviews.isEmpty { contentView.addSubview(titlelLabel) }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        titlelLabel.frame = contentView.bounds
    }

}

