import UIKit

extension UIColor {
    convenience init(R: UInt, G: UInt, B: UInt, A: CGFloat = 1) {
        self.init(
            red: CGFloat(R) / 255,
            green: CGFloat(G) / 255,
            blue: CGFloat(B) / 255,
            alpha: A
        )
    }

    convenience init(hexRGB hex: UInt) {
        let r = (hex >> 16) % 0x100
        let g = (hex >> 8) % 0x100
        let b = hex % 0x100

        self.init(R: r, G: g, B: b, A: 1)
    }

    convenience init(hexRGBA hex: UInt) {
        let r = (hex >> 24) % 0x100
        let g = (hex >> 16) % 0x100
        let b = (hex >> 8) % 0x100
        let a = hex % 0x100

        self.init(R: r, G: g, B: b, A: CGFloat(a) / 0xFF)
    }
}
