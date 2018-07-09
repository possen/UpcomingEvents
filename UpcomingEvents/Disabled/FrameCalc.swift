import Foundation
import CoreGraphics

class FixedColumnLayoutFrameCalculator {
    var columnSpacing: CGFloat = 5
    var rowSpacing: CGFloat = 5

    let referenceBounds: CGRect
    let numberOfColumns: Int
    let rowHeight: CGFloat

    init(referenceBounds: CGRect, numberOfColumns: Int, rowHeight: CGFloat) {
        self.referenceBounds = referenceBounds
        self.numberOfColumns = numberOfColumns
        self.rowHeight = rowHeight
    }

    // Cell Frame

    public func rectForItem(at indexPath: IndexPath) -> CGRect {
        let origin = originForItemInSection(at: indexPath.item)
        let size = sizeForItem()

        return CGRect(origin: origin, size: size)
    }

    private func originForItemInSection(at index: Int) -> CGPoint {
        let column = CGFloat(index % numberOfColumns)
        let xorigin = column * sizeForItem().width + column * columnSpacing
        let yorigin = rowHeight * CGFloat(index / numberOfColumns)

        return CGPoint(x: xorigin, y: yorigin)
    }

    private func itemWidth() -> CGFloat {
        let numberOfColumns = CGFloat(self.numberOfColumns)
        let fullWidth = referenceBounds.width
        let workingWidth = fullWidth - (columnSpacing * (numberOfColumns - 1))
        return workingWidth / numberOfColumns
    }

    private func sizeForItem() -> CGSize {
        return CGSize(width: itemWidth(), height: rowHeight - rowSpacing)
    }
}
