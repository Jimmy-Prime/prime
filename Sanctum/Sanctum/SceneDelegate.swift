import SwiftUI
import UIKit

//import os.log

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard window == nil, let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window
        window.makeKeyAndVisible()

        let coordinator = RootCoordinator()
        coordinator.showLoadingView()

        DispatchQueue.global().async {
            let storage = KeychainCredentialStorage()
            let service = CredentialService(credentialStorage: storage)
            service.checkSession { result in
                DispatchQueue.main.async {
                    if result {
                        coordinator.showMainView()
                    } else {
                        coordinator.showLoginView(credentialService: service)
                    }
                }
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

//    func scene(_ scene: UIScene, willContinueUserActivityWithType userActivityType: String) {
//        osLog(log: .debug, level: .debug, "\(userActivityType)")
//    }
//
//    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
//        osLog(log: .debug, level: .debug, "\(userActivity.activityType)")
//        osLog(log: .debug, level: .debug, "\(userActivity.userInfo?.description ?? "")")
//    }
}
