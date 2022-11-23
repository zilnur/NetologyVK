import Foundation
import UIKit

class Coordinator {
    
    enum Navigation {
        case feed
        case profile
    }
    
    let feedNavigationController = UINavigationController()
    let profileNavigationController = UINavigationController()
    let factory: Factory
    let window: UIWindow?
    
    init(_ factoty: Factory, window: UIWindow?) {
        self.factory = factoty
        self.window = window
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        feedNavigationController.navigationBar.scrollEdgeAppearance = appearance
        feedNavigationController.tabBarItem = UITabBarItem(title: "Главная", image: UIImage(systemName: "house"), tag: 0)
        profileNavigationController.navigationBar.scrollEdgeAppearance = appearance
        profileNavigationController.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person.circle"), tag: 1)
    }
    
    func start() {
        window?.rootViewController = factory.makeStartModule(window: window,coordinator: self)
    }
    
    func generalModule(id: Int) -> UITabBarController {
        let tabBar = factory.makeMainTabBarController(controllers: [feedNavigationController, profileNavigationController])
        let feedController = factory.makeFeedController(coordinator: self)
        let profileController = factory.makeProfileModule(id: id, coordinator: self)
        feedNavigationController.setViewControllers([feedController], animated: false)
        profileNavigationController.setViewControllers([profileController], animated: false)
        return tabBar
    }
    
    func openProfileModule(id: Int,from: Navigation) {
        switch from {
        case .feed:
            let profileController = factory.makeProfileModule(id: id, coordinator: self)
            feedNavigationController.pushViewController(profileController, animated: true)
        case .profile:
            let profileController = factory.makeProfileModule(id: id, coordinator: self)
            profileNavigationController.pushViewController(profileController, animated: true)
        }
    }
    
    func openPostDetailmodule(post: Post, from: Navigation) {
        switch from {
        case .feed:
            let postController = factory.makePostDetailModule(post: post)
            feedNavigationController.pushViewController(postController, animated: true)
        case .profile:
            let postController = factory.makePostDetailModule(post: post)
            profileNavigationController.pushViewController(postController, animated: true)
        }
    }
    
    func openPhotosModule(id: Int, from: Navigation) {
        switch from {
        case .feed:
            let photosController = factory.makePhotosDetailModule(id: id, coordinator: self)
            feedNavigationController.pushViewController(photosController, animated: true)
        case .profile:
            let photosController = factory.makePhotosDetailModule(id: id, coordinator: self)
            profileNavigationController.pushViewController(photosController, animated: true)
        }
    }
    
    func goToBack(from: Navigation) {
        switch from {
        case .feed:
            feedNavigationController.popViewController(animated: true)
        case .profile:
            profileNavigationController.popViewController(animated: true)
        }
    }
}

