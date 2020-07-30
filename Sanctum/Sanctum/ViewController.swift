import UIKit

enum PostListItem: Hashable {
    case loadingPrevious
    case post(PostCell.Content)
//    case loadingNext
}

class ViewController: UIViewController {
    typealias Section = Int
    typealias Item = PostListItem

    private var refreshControl: UIRefreshControl!
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!

    private func makeCollectionView() {
        let configuration = UICollectionLayoutListConfiguration(appearance: .sidebar)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
    }

    private func makeDataSource() {
        dataSource = .init(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            switch item {
            case .post(let post):
                return collectionView.dequeueConfiguredReusableCell(using: WrapperCell.registration(of: PostCell.self), for: indexPath, item: post)
            case .loadingPrevious:
                return collectionView.dequeueConfiguredReusableCell(using: WrapperCell.registration(of: LoadingCell.self), for: indexPath, item: "Loading")
            }
        })
    }

    private func makeInitialData() {
        var items: [Item] = []
        items.append(.loadingPrevious)
        items.append(contentsOf: (1...30).map { Item.post(.init(name: "Name", time: "15:30", message: "Message Message Message Message Message Message Message Message Message Message Message Message Message \($0)")) })
//        items.append(.loadingNext)

        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([0])
        snapshot.appendItems(items, toSection: 0)
        dataSource.apply(snapshot)
    }

    private func makeRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(startRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }

    @objc private func startRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.refreshControl.endRefreshing()
        }
    }

    private func configureNavigationBar() {
        navigationItem.title = "Channel Name"

        let settingsItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: nil, action: nil)
        let collectionItem = UIBarButtonItem(image: UIImage(systemName: "shippingbox"), style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItems = [settingsItem, collectionItem]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()

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

        makeRefreshControl()
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard dataSource.itemIdentifier(for: indexPath) != .loadingPrevious else { return nil }

        return UIContextMenuConfiguration(
            identifier: nil, // TODO: is identifier required?
            previewProvider: nil,
            actionProvider: { _ in
                let addHashtag = UIAction(title: "Add hashtag") { _ in
                    print("add hashtag")
                }
                let addReaction = UIAction(title: "Add reaction", image: UIImage(systemName: "hand.thumbsup")) { _ in
                    print("add reaction")
                }
                let comment = UIAction(title: "Comment", image: UIImage(systemName: "text.bubble")) { _ in
                    print("comment")
                }
                let bookmark = UIAction(title: "Bookmark", image: UIImage(systemName: "bookmark")) { _ in
                    print("bookmark")
                }

                let forward = UIAction(title: "Forward to Channel", image: UIImage(systemName: "arrowshape.turn.up.right")) { _ in
                    print("forward")
                }

                let remind = UIAction(title: "Remind me", image: UIImage(systemName: "repeat")) { _ in
                    print("remind")
                }
                let pin = UIAction(title: "Pin to Channel", image: UIImage(systemName: "pin")) { _ in
                    print("pin")
                }

                return UIMenu(
                    title: "",
                    children: [
                        UIMenu(title: "", options: .displayInline, children: [addHashtag, addReaction, comment, bookmark]),
                        UIMenu(title: "", options: .displayInline, children: [forward, remind, pin])
                    ]
                )
            }
        )
    }
}
