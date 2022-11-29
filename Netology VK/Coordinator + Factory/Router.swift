import Foundation
import UIKit

protocol RouterProtocol {
    func addNavigationController(controller: [String: Any])
    func returnNavigationController(key: String) -> UINavigationController?
}

class Router: RouterProtocol {
    
    typealias Controllers = [String: Any]
    
    var controllers = Controllers()
    
    func addNavigationController(controller: [String: Any]) {
        controller.forEach { (key: String, value: Any) in
            if !controllers.contains(where: { (containKey: String, value: Any) in
                key == containKey
            }) {
                controllers[key] = value
            }
        }
    }
    
    func returnNavigationController(key: String) -> UINavigationController? {
        guard let controller = controllers[key] as? UINavigationController else {
            return nil
        }
        return controller
    }
}
