import SwiftUI

struct GradientBackground: View {
    var colors: [Color]

    var body: some View {
        LinearGradient(gradient: Gradient(colors: colors), startPoint: .top, endPoint: .bottom)
    }
}

extension Array where Element == Color {
    static var widgetFill: Self {
        [
            Color(UIColor(hexRGB: 0x202020)),
            Color(UIColor(hexRGB: 0x000000))
        ]
    }

    static var widgetRedFill: Self {
        [
            Color(UIColor(hexRGB: 0x202020)),
            Color(UIColor(hexRGB: 0x200200))
        ]
    }

    static var widgetGreenFill: Self {
        [
            Color(UIColor(hexRGB: 0x202020)),
            Color(UIColor(hexRGB: 0x002008))
        ]
    }
}
