import UIKit

class LeftAlignedPaddedLabelLayout: UICollectionViewLayout {
    var items: [PaddedLabel] = []
    var spacing: CGPoint = .zero
    private(set) var calculatedItemFrames: [CGRect] = []
    private(set) var calculatedContentSize: CGSize = .zero

    override var collectionViewContentSize: CGSize {
        calculatedContentSize
    }

    override func prepare() {
        super.prepare()

        calculatedItemFrames = Array(repeating: .zero, count: items.count)

        var currentHeight: CGFloat = 0
        var currentRowHeight: CGFloat = 0
        var currentX: CGFloat = 0
        for (index, item) in items.enumerated() {
            let itemWidth = item.intrinsicContentSize.width

            // lays out in current row
            if currentX + (currentX == 0 ? 0 : spacing.x) + itemWidth <= calculatedContentSize.width {
                calculatedItemFrames[index] = CGRect(origin: CGPoint(x: currentX, y: currentHeight), size: item.intrinsicContentSize)

                currentX += itemWidth + spacing.x
                currentRowHeight = max(currentRowHeight, item.intrinsicContentSize.height)
            }
            // lays out in next row
            else {
                currentHeight += spacing.y + currentRowHeight

                // item fits in one row
                if itemWidth <= calculatedContentSize.width {
                    calculatedItemFrames[index] = CGRect(origin: CGPoint(x: 0, y: currentHeight), size: item.intrinsicContentSize)

                    currentX = itemWidth + spacing.x
                    currentRowHeight = item.intrinsicContentSize.height
                }
                // item spans multiple row
                else {
                    // calculate adaptive item size
                    let adaptiveSize = item.systemLayoutSizeFitting(
                        CGSize(width: calculatedContentSize.width, height: 0),
                        withHorizontalFittingPriority: .required,
                        verticalFittingPriority: .init(rawValue: 0)
                    )

                    calculatedItemFrames[index] = CGRect(x: 0, y: currentHeight, width: calculatedContentSize.width, height: adaptiveSize.height + item.inset.top + item.inset.bottom)

                    currentHeight += spacing.y + adaptiveSize.height + item.inset.top + item.inset.bottom
                    currentX = 0
                    currentRowHeight = 0
                }
            }
        }

        calculatedContentSize.height = currentHeight + currentRowHeight
        if currentRowHeight == 0 {
            calculatedContentSize.height -= spacing.y
        }
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        let oldWidth = calculatedContentSize.width
        calculatedContentSize.width = newBounds.width
        return oldWidth != newBounds.width
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = calculatedItemFrames[indexPath.item]
        return attributes
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var result: [UICollectionViewLayoutAttributes] = []
        for (index, frame) in calculatedItemFrames.enumerated() {
            let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: index, section: 0))
            attributes.frame = frame
            result.append(attributes)
        }

        return result.isEmpty ? nil : result
    }
}
