//
//  ViewController.swift
//  CollectionViewLayoutExample
//
//  Created by Fernando Moya de Rivas on 05/04/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import UIKit

class MainViewController: UICollectionViewController {

    private let numberOfSections = 4
    private let numberOfItemsInSection = [13, 10, 9, 16]
    private let cellIdentifier = "SpannableCollectionViewExampleCell"
    private let headerIdentifier = "SpannableCollectionViewExampleHeader"
    private let footerIdentifier = "SpannableCollectionViewExampleFooter"

    private let columnSpans = [[1, 1, 1, 1], [2, 2], [3, 1], [1, 2, 1]]

    init() {
        let layout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: layout)
        layout.headerReferenceSize = CGSize(width: view.bounds.size.width, height: 40)
        layout.footerReferenceSize = CGSize(width: view.bounds.size.width, height: 40)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(SpannableColletionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(SpannableSuplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectionView.register(SpannableSuplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerIdentifier)
    }

    private func colorForCell(at indexPath: IndexPath) -> UIColor {
        let colors: [UIColor] = [.blue, .brown, .green, .red]
        return colors[indexPath.row % colors.count]
    }

}

// MARK: UICollectionViewDataSource

extension MainViewController {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItemsInSection[section]
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SpannableColletionViewCell
        cell.text = "(\(indexPath.section),\(indexPath.row))"
        cell.backgroundColor = colorForCell(at: indexPath)
        return cell
    }

}

// MARK: UICollectionViewDelegate

extension MainViewController {

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let identifier = kind == UICollectionView.elementKindSectionHeader ? headerIdentifier : footerIdentifier
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath) as? SpannableSuplementaryView else { fatalError("Couldn't dequeue UICollectionView header") }

        let title = kind == UICollectionView.elementKindSectionHeader ? "Header" : "Footer"

        view.title = title
        return view
    }

}
