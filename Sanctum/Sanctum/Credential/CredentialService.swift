import os
import UIKit

struct RootCoordinator {
    private var window: UIWindow {
        UIApplication.shared.windows.filter { $0.isKeyWindow }.first!
    }

    func showLoadingView() {
        window.switchRootViewController(LoadingViewController())
    }

    func showLoginView(credentialService: CredentialService) {
        let loginVC = LoginViewController()
        loginVC.credentialService = credentialService
        window.switchRootViewController(loginVC)
    }

    func showMainView() {
        let splitVC = UISplitViewController(style: .doubleColumn)

        let sidebarVC = SidebarViewController()
        splitVC.setViewController(sidebarVC, for: .primary)

        let contentVC = ViewController()
        splitVC.setViewController(contentVC, for: .secondary)

        // TODO: create compact VC, for compact-width size class

        window.switchRootViewController(splitVC)
    }
}

struct CredentialService {
    let credentialStorage: CredentialStorage

    func checkSession(completion: @escaping (Bool) -> Void) {
        URLSession.shared.send(TimeoutCheckRequest()) { (result) in
            if case let .success(response) = result, response.success {
                completion(true)
            } else {
                loadCredential(completion: completion)
            }
        }
    }

    func loadCredential(completion: @escaping (Bool) -> Void) {
        if let credential = credentialStorage.load() {
            check(credential: credential, completion: completion)
        } else {
            completion(false)
        }
    }

    func check(credential: Credential, completion: @escaping (Bool) -> Void) {
        URLSession.shared.send(EncryptRequest()) { (result) in
            if case let .success(encrypt) = result {
                let request = AuthRequest(encrypt: encrypt, account: credential.account, password: credential.password)
                URLSession.shared.send(request) { (result) in
                    if case let .success(response) = result, !response.sid.isEmpty {
                        credentialStorage.save(credential: credential)
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            } else {
                completion(false)
            }
        }
    }
}
