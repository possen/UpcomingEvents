//
//  CalendarCollectionViewLayout
//  UpcomingEvents
//
//  Created by Paul Ossenbruggen on 7/9/18.
//  Copyright © 2018 Paul Ossenbruggen. All rights reserved.
//

import UIKit

protocol CollectionViewLayoutAdaptorProtocol: class {
    func collectionView(_ collectionView: UICollectionView,
                        eventAtIndexPath indexPath: IndexPath) -> (Bool, Event)
}

class CalendarCollectionViewLayout: UICollectionViewLayout {
    var cellSize = CGSize(width: 50, height: 50)
    var cellLayoutAttributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    var headerLayoutAttributes: [Int: UICollectionViewLayoutAttributes] = [:]
    weak var delegate: CollectionViewLayoutAdaptorProtocol?
    private var frameCalculator: FixedColumnLayoutFrameCalculator?
    let numberOfColumns: Int
    let rowHeight: CGFloat

    init(numberOfColumns: Int, rowHeight: CGFloat) {
        self.numberOfColumns = numberOfColumns
        self.rowHeight = rowHeight
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func invalidateLayout() {
        if let bounds = collectionView?.bounds {
            frameCalculator = FixedColumnLayoutFrameCalculator(
                referenceBounds: bounds,
                numberOfColumns: numberOfColumns,
                rowHeight: rowHeight)
        }

        cellLayoutAttributes = [:]
        headerLayoutAttributes = [:]
        super.invalidateLayout()
    }

    override func prepare() {
        guard let collectionView = self.collectionView  else { return }

        let sections = [Int](0...collectionView.numberOfSections - 1)

        for section in sections {
            let itemCount = collectionView.numberOfItems(inSection: section)
            let indexPaths = [Int](0...itemCount - 1).map { IndexPath(item: $0, section: section) }
            indexPaths.forEach { indexPath in
                cellLayoutAttributes[indexPath] = layoutAttributesForItem(at: indexPath)
            }
        }

        for section in sections {
            headerLayoutAttributes[section] = layoutAttributesForSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                at: IndexPath(item: 0, section: section))
        }
    }

    override func layoutAttributesForElements(
            in rect: CGRect
        ) -> [UICollectionViewLayoutAttributes]? {

        return cellLayoutAttributes.values.filter { rect.intersects($0.frame) }
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }

        return newBounds.width != collectionView.bounds.width
    }

    private func frameForItem(at indexPath: IndexPath) -> CGRect {
        guard let frameCalculator = frameCalculator else { return .zero }

        let frameInSection = frameCalculator.rectForItem(at: indexPath)

        let rowInSection = indexPath.item / numberOfColumns
        let sectionHeightOffset = offset(for: indexPath.section)
        let yOffset = sectionHeightOffset + CGFloat(rowInSection) * rowHeight

        return CGRect(
            x: frameInSection.minX,
            y: yOffset,
            width: frameInSection.width,
            height: frameInSection.height)
    }

    private func offset(for section: Int) -> CGFloat {
        guard let collectionView = collectionView else { return 0 }
        guard let frameCalculator = frameCalculator else { return 0 }

        if section == 0 {
            return 0
        }

        let itemCount = collectionView.numberOfItems(inSection: section - 1)

        if let lastItemAttributes = layoutAttributesForItem(
                at: IndexPath(item: itemCount - 1, section: section - 1)
            ) {
            return lastItemAttributes.frame.maxY + frameCalculator.rowSpacing
        } else {
            return 0
        }
    }

    private func lastLayoutAttributes() -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else { return nil }

        let numberOfSections = collectionView.numberOfSections
        let lastSectionItemCount = collectionView.numberOfItems(inSection: numberOfSections - 1)

        return layoutAttributesForItem(
            at: IndexPath(item: lastSectionItemCount - 1,
                          section: numberOfSections - 1))
    }

    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return .zero }
        guard collectionView.frame != .zero else { return .zero }

        let width = collectionView.frame.width
        let height: CGFloat

        if let lastLayoutAttributes = lastLayoutAttributes() {
            height = lastLayoutAttributes.frame.maxY
        } else {
            height = 0
        }
        return CGSize(width: width, height: height)
    }

    override func layoutAttributesForItem(
            at indexPath: IndexPath
        ) -> UICollectionViewLayoutAttributes? {

        if cellLayoutAttributes[indexPath] != nil {
            return cellLayoutAttributes[indexPath]
        }

        let frame = frameForItem(at: indexPath)
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = frame

        return attributes
    }

}
