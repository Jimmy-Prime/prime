import UIKit

class GridLayoutSettingsUnitView: UIView {
    let titleLabel = UILabel()
    let valueLabel = UILabel()
    let decrementButton = UIButton(type: .system)
    let incrementButton = UIButton(type: .system)

    private var value: Int = 0 {
        didSet {
            valueLabel.text = "\(value)"
        }
    }

    func initialize() {
        decrementButton.setTitle("-", for: .normal)
        decrementButton.addTarget(self, action: #selector(decrementValue), for: .primaryActionTriggered)
        incrementButton.setTitle("+", for: .normal)
        incrementButton.addTarget(self, action: #selector(incrementValue), for: .primaryActionTriggered)

        decrementButton.translatesAutoresizingMaskIntoConstraints = false
        incrementButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            decrementButton.widthAnchor.constraint(equalTo: decrementButton.heightAnchor),
            incrementButton.widthAnchor.constraint(equalTo: incrementButton.heightAnchor),
        ])

        let stackView = UIStackView(arrangedSubviews: [titleLabel, UIView(), valueLabel, decrementButton, incrementButton])
        stackView.axis = .horizontal
        stackView.spacing = 20
        addSubview(stackView)
        stackView.frame = CGRect(origin: .zero, size: bounds.size)
    }

    func set(title: String, value: Int) {
        titleLabel.text = title
        self.value = value
    }

    @objc
    private func decrementValue() {
        value -= 1
    }

    @objc
    private func incrementValue() {
        value += 1
    }
}

class GridLayoutSettingsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        for value in (1...4) {
            let unitView = GridLayoutSettingsUnitView(frame: CGRect(x: 0, y: value * 150, width: 800, height: 120))
            unitView.initialize()
            unitView.set(title: "Title", value: value)
            view.addSubview(unitView)

        }
    }
}
