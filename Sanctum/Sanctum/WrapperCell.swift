import UIKit

extension UICellConfigurationState {
    func getItemOfType<T: Hashable>(_ type: T.Type = T.self) -> T? {
        let key = UIConfigurationStateCustomKey(String(describing: type))
        return self[key] as? T
    }

    fileprivate mutating func set<T: Hashable>(_ type: T.Type = T.self, item: T) {
        let key = UIConfigurationStateCustomKey(String(describing: type))
        self[key] = item
    }
}

class WrapperCell<T: Hashable>: UICollectionViewCell {
    private var item: T?

    func update(with item: T) {
        guard self.item != item else { return }
        self.item = item
        setNeedsUpdateConfiguration()
    }

    override var configurationState: UICellConfigurationState {
        var state = super.configurationState
        if let item = item {
            // even though set(item:) can accept optional item,
            // we should unwrap item because UIConfigurationStateCustomKey is string based api
            state.set(item: item)
        }
        return state
    }

    static func registration<Cell: WrapperCell<T>>(of type: Cell.Type) -> UICollectionView.CellRegistration<Cell, T> {
        .init() { (cell, indexPath, item) in
            cell.update(with: item)
        }
    }
}
