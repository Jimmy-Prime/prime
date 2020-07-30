import UIKit

class PostCell: WrapperCell<PostCell.Content> {
    struct Content: Hashable {
        let name: String
        let time: String
        let message: String
    }

    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let timeLabel = UILabel()
    private let messageLabel = UILabel()

    private var nameLabelLeadingConstraint: NSLayoutConstraint!
    private var timeLabelLeadingConstraint: NSLayoutConstraint!

    private func setupViewsIfNeeded() {
        guard nameLabelLeadingConstraint == nil else { return }

        for view in [imageView, nameLabel] {
            let interaction = UIContextMenuInteraction(delegate: self)
            view.addInteraction(interaction)
            view.isUserInteractionEnabled = true
        }

        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor)
        ])

        nameLabel.font = .preferredFont(forTextStyle: .headline)
        nameLabel.adjustsFontSizeToFitWidth = true
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabelLeadingConstraint = nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor)
        NSLayoutConstraint.activate([
            nameLabel.firstBaselineAnchor.constraint(equalToSystemSpacingBelow: contentView.readableContentGuide.topAnchor, multiplier: 1),
            imageView.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            nameLabelLeadingConstraint
        ])

        timeLabel.font = .preferredFont(forTextStyle: .footnote)
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.textColor = .secondaryLabel
        contentView.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabelLeadingConstraint = timeLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor)
        NSLayoutConstraint.activate([
            timeLabel.firstBaselineAnchor.constraint(equalTo: nameLabel.firstBaselineAnchor),
            timeLabelLeadingConstraint,
            timeLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.readableContentGuide.trailingAnchor)
        ])

        messageLabel.font = .preferredFont(forTextStyle: .body)
        messageLabel.adjustsFontSizeToFitWidth = true
        messageLabel.numberOfLines = 0
        contentView.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLabel.firstBaselineAnchor.constraint(equalToSystemSpacingBelow: nameLabel.lastBaselineAnchor, multiplier: 1),
            contentView.readableContentGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: messageLabel.lastBaselineAnchor, multiplier: 1),
            messageLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor)
        ])
    }

    override func updateConfiguration(using state: UICellConfigurationState) {
        setupViewsIfNeeded()

        let item = state.getItemOfType(Content.self)
        imageView.image = UIImage(systemName: "person.circle.fill", withConfiguration: UIImage.SymbolConfiguration(textStyle: .largeTitle))
        nameLabel.text = item?.name
        timeLabel.text = item?.time
        messageLabel.text = item?.message

        let configuration = UIListContentConfiguration.cell().updated(for: state)

        nameLabelLeadingConstraint.constant = configuration.imageToTextPadding
        timeLabelLeadingConstraint.constant = configuration.textToSecondaryTextHorizontalPadding
    }
}

extension PostCell: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return userPreviewMenuConfiguration()
    }

    private func userPreviewMenuConfiguration() -> UIContextMenuConfiguration {
        UIContextMenuConfiguration(
            identifier: nil, // maybe it should be userID
            previewProvider: {
                let vc = UserPreviewViewController()
                vc.configure(name: "User Name", email: "user@synology.com", description: "Some description of user.")
                return vc
            },
            actionProvider: { _ in
                let chatWith = UIAction(title: "Chat with", image: UIImage(systemName: "text.bubble")) { _ in
                    // TODO
                }
                let searchInThisChannel = UIAction(title: "Search in this channel", image: UIImage(systemName: "magnifyingglass")) { _ in
                    // TODO
                }

                return UIMenu(
                    title: "",
                    children: [chatWith, searchInThisChannel]
                )
            }
        )
    }
}
