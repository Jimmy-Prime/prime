import UIKit

class LoadingCell: WrapperCell<String> {
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    private let label = UILabel()

    private var labelLeadingConstraint: NSLayoutConstraint!

    private func setupViewsIfNeeded() {
        guard labelLeadingConstraint == nil else { return }

        contentView.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicatorView.topAnchor.constraint(greaterThanOrEqualTo: contentView.readableContentGuide.topAnchor),
            activityIndicatorView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.readableContentGuide.bottomAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: contentView.readableContentGuide.centerYAnchor),
            activityIndicatorView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor)
        ])

        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        labelLeadingConstraint = label.leadingAnchor.constraint(equalTo: activityIndicatorView.trailingAnchor)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(greaterThanOrEqualTo: contentView.readableContentGuide.topAnchor),
            label.bottomAnchor.constraint(lessThanOrEqualTo: contentView.readableContentGuide.bottomAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.readableContentGuide.centerYAnchor),
            labelLeadingConstraint
        ])
    }

    override func updateConfiguration(using state: UICellConfigurationState) {
        setupViewsIfNeeded()

        activityIndicatorView.startAnimating()

        let item = state.getItemOfType(String.self)
        label.text = item

        let configuration = UIListContentConfiguration.cell().updated(for: state)

        labelLeadingConstraint.constant = configuration.imageToTextPadding
    }
}
