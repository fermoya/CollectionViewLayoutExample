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
    private let alignments: [GridCollectionViewLayout.Alignment] = [.top, .bottom, .center, .top]

    init() {
        let layout = GridCollectionViewLayout(numberOfColumns: 4)
        super.init(collectionViewLayout: layout)
        layout.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(SpannableColletionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(SpannableSuplementaryView.self, forSupplementaryViewOfKind: GridCollectionViewLayout.ElementKind.header.rawValue, withReuseIdentifier: headerIdentifier)
        collectionView.register(SpannableSuplementaryView.self, forSupplementaryViewOfKind: GridCollectionViewLayout.ElementKind.footer.rawValue, withReuseIdentifier: footerIdentifier)
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
        guard let elementKind = GridCollectionViewLayout.ElementKind(rawValue: kind) else { fatalError("Unknown element kind") }
        guard elementKind != .cell else { fatalError("Suplementary cell can't be a cell") }

        let identifier = elementKind == .header ? headerIdentifier : footerIdentifier
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind.rawValue, withReuseIdentifier: identifier, for: indexPath) as? SpannableSuplementaryView else { fatalError("Couldn't dequeue UICollectionView header") }

        let alignment = self.collectionView(collectionView, alignmentForSection: indexPath.section)
        let title = elementKind == .header ? "Section \(indexPath.section + 1): \(columnSpans[indexPath.section])" : "alignment \(alignment.rawValue)"

        view.title = title
        return view
    }

}

// MARK: SpannableCollectionViewLayoutDelegate

extension MainViewController: GridCollectionViewLayoutDelegate {

    func collectionView(_ collectionView: UICollectionView, heightForItemAt index: GridIndex, indexPath: IndexPath) -> CGFloat {
        let columnHeight = self.collectionView(collectionView, heightForRow: index.row)
        return (index.column + index.row).isMultiple(of: 4) ? columnHeight : columnHeight - 20
    }

    func collectionView(_ collectionView: UICollectionView, heightForRow row: Int) -> CGFloat {
        return row.isMultiple(of: 2) ? 100 : 60
    }

    func collectionView(_ collectionView: UICollectionView, heightForSupplementaryView kind: GridCollectionViewLayout.ElementKind, at section: Int) -> CGFloat? {
        return 40
    }

    func collectionView(_ collectionView: UICollectionView, alignmentForSection section: Int) -> GridCollectionViewLayout.Alignment {
        return alignments[section]
    }


    func collectionView(_ collectionView: UICollectionView, columnSpanForItemAt index: GridIndex, indexPath: IndexPath) -> Int {
        let spans = columnSpans[indexPath.section]
        let span = spans[indexPath.row % spans.count]
        return span
    }

}
