import UIKit

struct GridIndex {
    var x: UInt
    var y: UInt
}

struct GridArea {
    var origin: GridIndex
    var size: GridIndex
}

protocol GridItem {
    var area: GridArea { get set }
    var settings: Settings.Section { get }
}

protocol GridItemView: UIView, GridItem {}

class GridView: UIView {
    // MARK: - items

    private var items: [GridItemView] = []

    func add(item: GridItemView) {
        guard !items.contains(where: { $0 === item }) else { return }

        items.append(item)
        addSubview(item)
        // triggers layoutsubviews
    }

    func remove(item: GridItemView) {
        guard items.contains(where: { $0 === item }) else { return }

        items.removeAll(where: { $0 === item })
        item.removeFromSuperview()
        // triggers layoutsubviews
    }

    // MARK: - layout

    var index: GridIndex = .init(x: 0, y: 0)
    var itemInset: UIEdgeInsets = .zero

    override func layoutSubviews() {
        items.forEach { $0.frame = frame(of: $0.area) }
    }

    private func frame(of area: GridArea) -> CGRect {
        guard area.origin.x + area.size.x <= index.x,
              area.origin.y + area.size.y <= index.y else {
            fatalError("area index out of bound")
        }

        let widthUnit = bounds.size.width / CGFloat(index.x)
        let heightUnit = bounds.size.height / CGFloat(index.y)

        return CGRect(
            x: widthUnit * CGFloat(area.origin.x),
            y: heightUnit * CGFloat(area.origin.y),
            width: widthUnit * CGFloat(area.size.x),
            height: heightUnit * CGFloat(area.size.y)
        )
            .inset(by: itemInset)
    }

    // MARK: - settings

    private var settings: Settings.Section {
        .init(title: "Grid", items: [.text(title: "Grid Layout", detail: "7 x 4", hasNextPage: true)])
    }

    func generateSettings() -> Settings {
        Settings(sections: [settings] + items.map { $0.settings })
    }
}
