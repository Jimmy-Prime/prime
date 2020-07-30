import UIKit

enum SidebarSection: Hashable, CaseIterable {
    case favorite
    case channel
    case conversation
    case bot

    var displayName: String {
        switch self {
        case .favorite:
            return NSLocalizedString("Favorite", comment: "")
        case .channel:
            return "Channel"
        case .conversation:
            return "Conversation"
        case .bot:
            return "Bot"
        }
    }
}

struct SidebarChannel: Hashable {
    var name: String
    var description: String
}

enum SidebarItem: Hashable {
    case header(SidebarSection)
    case channel(SidebarChannel)
}

class SidebarViewController: UIViewController {
    typealias Section = SidebarSection
    typealias Item = SidebarItem

    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!

    private func makeCollectionView() {
        var configuration = UICollectionLayoutListConfiguration(appearance: .sidebar)
        configuration.headerMode = .firstItemInSection
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.alwaysBounceVertical = true
    }

    private func makeDataSource() {
        let headerRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SidebarSection> { (cell, indexPath, item) in
            var configuration = cell.defaultContentConfiguration()
            configuration.text = item.displayName
            cell.contentConfiguration = configuration
            cell.accessories = [.outlineDisclosure()]
        }

        let channelRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SidebarChannel> { (cell, indexPath, item) in
            var configuration = cell.defaultContentConfiguration()
            configuration.text = item.name
            configuration.secondaryText = item.description
            cell.contentConfiguration = configuration
        }

        dataSource = .init(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            switch item {
            case .header(let header):
                return collectionView.dequeueConfiguredReusableCell(using: headerRegistration, for: indexPath, item: header)
            case .channel(let channel):
                return collectionView.dequeueConfiguredReusableCell(using: channelRegistration, for: indexPath, item: channel)
            }
        })
    }

    private func makeInitialData() {
        let favoriteSection = Section.favorite

        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(Section.allCases)
//        for section in Section.allCases {
//            snapshot.appendItems([.header(section)], toSection: section)
//        }
        dataSource.apply(snapshot)

        var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
        let headerItem = Item.header(favoriteSection)
        sectionSnapshot.append([headerItem])
        sectionSnapshot.append((1...10).map { Item.channel(.init(name: "Channel ID: \($0)", description: "Some very long channel description.")) }, to: headerItem)
        dataSource.apply(sectionSnapshot, to: favoriteSection)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: nil, action: nil)

        makeCollectionView()

        makeDataSource()

        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        makeInitialData()

        let searchController = UISearchController(searchResultsController: SidebarViewController())
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
}

extension SidebarViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
    }
}
