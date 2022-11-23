import Foundation
import UIKit

class Coordinator {
    
    let navigationController: UINavigationController
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() -> UIViewController {
        let presenter = StartModulePresenter()
        let startView = StartViewController(presenter: presenter)
        return startView
    }
    
    func generalModule() -> UITabBarController {
        let tabBarController = UITabBarController()
        
        return tabBarController
    }
}

