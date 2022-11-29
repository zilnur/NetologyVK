import Foundation
import UIKit

protocol ViewControllerProtocol {
    func asViewController() -> UIViewController
    func registerNavigationController() -> [String: Any]
}

class ViewController: UIViewController, ViewControllerProtocol {
    
    func asViewController() -> UIViewController {
        self
    }
    
    func registerNavigationController() -> [String : Any] {
        print("controller \(self.description)")
        return [self.navigationController?.description ?? "": navigationController ?? ""]
    }
}
