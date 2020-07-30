import Foundation

struct Settings {
    struct Section {
        let title: String?
        let items: [Item]
    }

    enum Item {
        case text(title: String?, detail: String?, hasNextPage: Bool = false)
    }

    let sections: [Section]
}
