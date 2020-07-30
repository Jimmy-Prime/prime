import Photos
import UIKit

class PhotoItem: UIView, GridItemView {
    var area: GridArea = .init(origin: .init(x: 0, y: 2), size: .init(x: 4, y: 2))

    var settings: Settings.Section {
        .init(
            title: "PhotoItem",
            items: [
                .text(title: "Photos", detail: "PhotoItem Detail")
            ]
        )
    }

    // TODO: check photo permission

    private let imageView = UIImageView()

    private var fetchResult: PHFetchResult<PHAsset>!
    private var index: Int = 0
    private var timer: Timer!

    func initialize() {
        clipsToBounds = true

        imageView.contentMode = .scaleAspectFill

        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func fetchPhotos() {
        let options = PHFetchOptions()
        options.fetchLimit = 3
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

        fetchResult = PHAsset.fetchAssets(with: .image, options: options)

        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { (_) in
            self.setPhoto(index: self.index)
            self.index = (self.index + 1) % self.fetchResult.count
        }
    }

    func setPhoto(index: Int) {
        let asset = fetchResult.object(at: index)

        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.isNetworkAccessAllowed = true

        PHImageManager.default().requestImage(for: asset, targetSize: bounds.size, contentMode: .aspectFill, options: options) { (image, info) in
            self.imageView.image = image
        }
    }
}
