//
//  SpannableCollectionViewLayout.swift
//  CollectionViewLayoutExample
//
//  Created by Fernando Moya de Rivas on 05/04/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import UIKit

protocol GridCollectionViewLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, columnSpanForItemAt index: GridIndex, indexPath: IndexPath) -> Int
    func collectionView(_ collectionView: UICollectionView, heightForItemAt index: GridIndex, indexPath: IndexPath) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, heightForRow row: Int) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, heightForSupplementaryView kind: GridCollectionViewLayout.ElementKind, at section: Int) -> CGFloat?
    func collectionView(_ collectionView: UICollectionView, alignmentForSection section: Int) -> GridCollectionViewLayout.Alignment
}

class GridLayoutAttributes: UICollectionViewLayoutAttributes {
    var index: GridIndex?
}

struct GridIndex {
    let row: Int
    let column: Int
}

class GridCollectionViewLayout: UICollectionViewLayout {

    enum Alignment: String {
        case top, bottom, center
    }

    enum ElementKind: String {
        case header = "elementKindHeader"
        case footer = "elementKindFooter"
        case cell = "elementKindCell"
    }

    weak var delegate: GridCollectionViewLayoutDelegate?

    var cellAlignment: Alignment = .center
    var columnSpacing: CGFloat = 8
    var rowSpacing: CGFloat = 16
    var sectionSpacing: CGFloat = 32

    var estimatedColumnSpan = 1
    var estimatedCellHeight: CGFloat = 60

    private(set) var numberOfColumns: Int
    private var attributes: [ElementKind: [IndexPath: GridLayoutAttributes]] = [:]

    init(numberOfColumns: Int) {
        self.numberOfColumns = numberOfColumns
        super.init()
    }

    required init?(coder: NSCoder) {
        self.numberOfColumns = coder.value(forKey: "numberOfColumns") as? Int ?? 3
        super.init(coder: coder)
    }

    private var collectionViewWidth: CGFloat {
        guard let collectionView = collectionView else { return .zero }
        return collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right)
    }

    private var collectionViewHeight: CGFloat = 0

    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionViewWidth, height: collectionViewHeight)
    }

    private func reset() {
        self.attributes = [.cell: [:], .header: [:], .footer: [:]]
    }

    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }
        guard attributes.isEmpty else { return }
        guard numberOfColumns > 0 else { return }

        reset()

        let numberOfSections = collectionView.numberOfSections
        (0..<numberOfSections).forEach { section in
            prepareSuplementaryView(kind: .header, at: section)
            prepareCells(at: section)
            prepareSuplementaryView(kind: .footer, at: section)

            if section < numberOfSections - 1 {
                collectionViewHeight += sectionSpacing
            }
        }
    }

    private func prepareCells(at section: Int) {
        guard let collectionView = collectionView else { return }
        let itemsCount = collectionView.numberOfItems(inSection: section)

        var row = 0
        var itemIndex = 0
        let alignment = delegate?.collectionView(collectionView, alignmentForSection: section) ?? cellAlignment

        while (itemsCount - itemIndex) > 0 {
            let columnWidth = (collectionViewWidth - CGFloat(numberOfColumns - 1) * columnSpacing) / CGFloat(numberOfColumns)
            let columnHeight = delegate?.collectionView(collectionView, heightForRow: row) ?? estimatedCellHeight

            var availableSpan = numberOfColumns
            (0..<numberOfColumns).forEach { column in
                guard itemIndex < itemsCount else { return }
                guard availableSpan > 0, availableSpan + column == numberOfColumns else { return }
                let indexPath = IndexPath(item: itemIndex, section: section)
                let index = GridIndex(row: row, column: column)

                let cellSpan = min(availableSpan, delegate?.collectionView(collectionView, columnSpanForItemAt: index, indexPath: indexPath) ?? estimatedColumnSpan)

                let cellWidth = columnWidth * CGFloat(cellSpan) + CGFloat(cellSpan - 1) * columnSpacing
                let cellHeight = min(columnHeight, delegate?.collectionView(collectionView, heightForItemAt: index, indexPath: indexPath) ?? estimatedCellHeight)

                let cellXPosition = CGFloat(column) * (columnWidth + columnSpacing)
                let cellYPosition: CGFloat
                switch alignment {
                case .top:
                    cellYPosition = collectionViewHeight
                case .bottom:
                    cellYPosition = collectionViewHeight + (columnHeight - cellHeight)
                case .center:
                    cellYPosition = collectionViewHeight + (columnHeight - cellHeight) / 2
                }

                let cellOrigin = CGPoint(x: cellXPosition, y: cellYPosition)
                let cellSize = CGSize(width: cellWidth, height: cellHeight)

                let attributes = GridLayoutAttributes(forCellWith: indexPath)
                attributes.index = index
                attributes.frame = CGRect(origin: cellOrigin, size: cellSize)

                self.attributes[.cell]?[indexPath] = attributes

                itemIndex += 1
                availableSpan -= cellSpan
            }

            row += 1
            collectionViewHeight += columnHeight

            guard itemIndex < itemsCount else { continue }
            collectionViewHeight += rowSpacing
        }
    }

    private func prepareSuplementaryView(kind: ElementKind, at section: Int) {
        guard let collectionView = collectionView else { return }
        guard let height = delegate?.collectionView(collectionView, heightForSupplementaryView: kind, at: section) else { return }

        let indexPath = IndexPath(row: 0, section: section)
        let attributes = GridLayoutAttributes(forSupplementaryViewOfKind: kind.rawValue, with: indexPath)
        attributes.frame = CGRect(x: 0, y: collectionViewHeight, width: collectionViewWidth, height: height)
        self.attributes[kind]?[indexPath] = attributes

        collectionViewHeight += height
    }

    override func invalidateLayout() {
        super.invalidateLayout()
        collectionViewHeight = 0
        attributes.removeAll()
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes.values.flatMap { $0.values }.filter { $0.frame.intersects(rect) }
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let kind = ElementKind(rawValue: elementKind) else { return nil }
        return attributes[kind]?[indexPath]
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributes[.cell]?[indexPath]
    }

    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let oldBounds = collectionView?.bounds else { return false }
        return oldBounds.size != newBounds.size
    }

}
