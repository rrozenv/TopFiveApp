
import UIKit
import Firebase

final class AppController: UIViewController {
    
    fileprivate var actingVC: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNotificationObservers()
        loadInitialViewController()
    }
    
}

// MARK: - Notficiation Observers
extension AppController {
    
    func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(switchViewController(with:)), name: .closeOnboardingVC, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(switchViewController(with:)), name: .closeHomeVC, object: nil)
    }
    
}

struct UserDefaultsKeys {
    static let sources = "sources"
}

// MARK: - Loading VC's
extension AppController {
    
    func loadInitialViewController() {
        let userSources = UserDefaults.standard.array(forKey: UserDefaultsKeys.sources) as? [String]
        self.actingVC = (userSources != nil) ? UINavigationController(rootViewController: MasterTabBarController()) : OnboardingViewController()
        self.add(viewController: self.actingVC, animated: true)
    }
    
}

// MARK: - Displaying VC's
extension AppController {
    
    func add(viewController: UIViewController, animated: Bool = false) {
        self.addChildViewController(viewController)
        view.addSubview(viewController.view)
        view.alpha = 0.0
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParentViewController: self)
        
        guard animated else { view.alpha = 1.0; return }
        
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.view.alpha = 1.0
        }) { _ in }
    }
    
    func switchViewController(with notification: Notification) {
        switch notification.name {
        case Notification.Name.closeOnboardingVC:
            let masterTabBarVC = UINavigationController(rootViewController: MasterTabBarController())
            switchToViewController(masterTabBarVC)
        case Notification.Name.closeHomeVC:
            let onboardingVC = LoginViewController()
            switchToViewController(onboardingVC)
        default:
            fatalError("\(#function) - Unable to match notficiation name.")
        }
        
    }
    
    private func switchToViewController(_ viewController: UIViewController) {
        let existingVC = actingVC
        existingVC?.willMove(toParentViewController: nil)
        add(viewController: viewController)
        actingVC.view.alpha = 0.0
        
        UIView.animate(withDuration: 0.8, animations: {
            self.actingVC.view.alpha = 1.0
            existingVC?.view.alpha = 0.0
        }) { success in
            existingVC?.view.removeFromSuperview()
            existingVC?.removeFromParentViewController()
            self.actingVC.didMove(toParentViewController: self)
        }
    }
    
}

// MARK: - Notification Extension
extension Notification.Name {
    static let closeOnboardingVC = Notification.Name("close-onboarding-view-controller")
    static let closeHomeVC = Notification.Name("close-home-view-controller")
}

