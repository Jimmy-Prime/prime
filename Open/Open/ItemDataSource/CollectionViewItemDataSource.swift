import UIKit

class CollectionViewItemDataSource<T: Hashable>: UICollectionViewDiffableDataSource<Int, T> {
    func fetcher(completion: @escaping (Result<[T], Error>) -> Void) {
        completion(.failure(NSError(domain: "Subclass Should Override", code: 0)))
    }

    func fetch() {
        fetcher { result in
            guard case let .success(items) = result else { return }

            DispatchQueue.main.async {
                self.update(items: items)
            }
        }
    }

    func update(items: [T]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, T>()
        snapshot.appendSections([0])
        snapshot.appendItems(items, toSection: 0)
        apply(snapshot)
    }
}
