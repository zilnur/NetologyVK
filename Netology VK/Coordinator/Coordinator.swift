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
    
//    func openSignInModule() -> UIViewController {
//        let presenter = SignUpPresenter(coordinator: self)
//        let signUpView = SignUpViewController(presenter: presenter)
//        return signUpView
//    }
}

