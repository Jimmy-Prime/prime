import UIKit

extension CATransition {
    class var defaultCrossfade: CATransition {
        let transition = CATransition()
        transition.type = .fade
        transition.duration = 0.25
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        return transition
    }
}

extension UIWindow {
    func switchRootViewController(_ vc: UIViewController, with transition: CATransition = .defaultCrossfade) {
        let transitionWindow = UIWindow(frame: UIScreen.main.bounds)
        transitionWindow.rootViewController = self.rootViewController
        transitionWindow.makeKeyAndVisible()

        self.layer.add(transition, forKey: kCATransition)
        self.rootViewController = vc
        self.makeKeyAndVisible()

        DispatchQueue.main.asyncAfter(deadline: .now() + transition.duration) {
            transitionWindow.removeFromSuperview()
        }
    }
}
