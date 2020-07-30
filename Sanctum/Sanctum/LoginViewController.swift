import UIKit

class LoginViewController: UIViewController {
    var credentialService: CredentialService?

    private var containerBottomConstraint: NSLayoutConstraint!
    private let accountTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        let container = UIView()
        view.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        containerBottomConstraint = container.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: view.topAnchor),
            containerBottomConstraint,
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        accountTextField.placeholder = "Account"
        accountTextField.textContentType = .username
        accountTextField.borderStyle = .roundedRect
        accountTextField.autocapitalizationType = .none

        passwordTextField.placeholder = "Password"
        passwordTextField.textContentType = .password
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect

        loginButton.setImage(UIImage(systemName: "arrow.right.circle.fill", withConfiguration: UIImage.SymbolConfiguration(textStyle: .largeTitle)), for: .normal)
        loginButton.addTarget(self, action: #selector(login), for: .primaryActionTriggered)

        let vStack = UIStackView(arrangedSubviews: [accountTextField, passwordTextField])
        vStack.axis = .vertical
        vStack.spacing = UIStackView.spacingUseSystem

        loginButton.setContentHuggingPriority(.defaultLow + 1, for: .horizontal)
        let hStack = UIStackView(arrangedSubviews: [vStack, loginButton])
        hStack.axis = .horizontal
        hStack.spacing = UIStackView.spacingUseSystem
        container.addSubview(hStack)
        hStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hStack.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            hStack.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            hStack.widthAnchor.constraint(equalTo: container.readableContentGuide.widthAnchor)
        ])

        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { (notification) in
            guard let userInfo = notification.userInfo,
                  let endFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
                  let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
                  let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
                  let curve = UIView.AnimationCurve(rawValue: curveValue) else { return }

            let endFrame = endFrameValue.cgRectValue

            if endFrame.maxY == UIScreen.main.bounds.height {
                self.containerBottomConstraint.constant = -endFrame.height
            } else {
                self.containerBottomConstraint.constant = 0
            }

            let animator = UIViewPropertyAnimator(duration: duration, curve: curve) {
                self.view.layoutIfNeeded()
            }
            animator.startAnimation()
        }
    }

    @objc private func login() {
        guard let service = credentialService,
              let account = accountTextField.text,
              let password = passwordTextField.text else { return }

        DispatchQueue.global().async {
            let credential = Credential(account: account, password: password)
            service.check(credential: credential) { (result) in
                DispatchQueue.main.async {
                    let coordinator = RootCoordinator()
                    if result {
                        coordinator.showMainView()
                    } else {
                        coordinator.showLoginView(credentialService: service)
                    }
                }
            }
        }
    }
}
