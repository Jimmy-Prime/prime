import UIKit

class PaddedLabel: UILabel {
    var inset: UIEdgeInsets = .zero

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: inset))
    }

    override var intrinsicContentSize: CGSize {
        CGSize(
            width: super.intrinsicContentSize.width + inset.left + inset.right,
            height: super.intrinsicContentSize.height + inset.top + inset.bottom
        )
    }
}
