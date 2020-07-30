import UIKit

class UserPreviewViewController: UIViewController {
    private let imageView = UIImageView()
    private let nameCell = UICollectionViewListCell()
    private let emailCell = UICollectionViewListCell()
    private let descriptionCell = UICollectionViewListCell()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemPink
        imageView.backgroundColor = .systemTeal

        imageView.setContentCompressionResistancePriority(.defaultHigh - 1, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.defaultHigh - 1, for: .vertical)
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        var topView: UIView = imageView
        for cell in [nameCell, emailCell, descriptionCell] {
            view.addSubview(cell)
            cell.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                cell.topAnchor.constraint(equalTo: topView.bottomAnchor),
                cell.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                cell.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
            topView = cell
        }
        topView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    func configure(name: String, email: String, description: String) {
        var configuration = UIListContentConfiguration.cell()

        configuration.text = "Name"
        configuration.secondaryText = name
        nameCell.contentConfiguration = configuration
        nameCell.setNeedsUpdateConfiguration()

        configuration.text = "Email"
        configuration.secondaryText = email
        emailCell.contentConfiguration = configuration
        emailCell.setNeedsUpdateConfiguration()

        configuration.text = "Description"
        configuration.secondaryText = description
        descriptionCell.contentConfiguration = configuration
        descriptionCell.setNeedsUpdateConfiguration()
    }
}
