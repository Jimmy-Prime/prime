import UIKit

class NewsItem: UITableView, GridItemView {
    var area: GridArea = .init(origin: .init(x: 4, y: 0), size: .init(x: 3, y: 4))

    var settings: Settings.Section {
        .init(
            title: "NewsItem",
            items: [
                .text(title: "News", detail: "NewsItem Detail")
            ]
        )
    }

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)

        delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NewsItem: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
