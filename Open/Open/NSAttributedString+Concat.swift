import Foundation

extension NSAttributedString {
    class func combining(_ components: [NSAttributedString]) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        components.forEach { attributedString.append($0) }
        return attributedString
    }
}
