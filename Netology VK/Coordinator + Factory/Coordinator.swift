import Foundation
import UIKit

protocol CoordinatorProtocol {
    func start()
    func generalModule(id: Int)
    func openProfileModule(id: Int,from controller: String)
    func openPostDetailModule(from controller: String, post: Post)
    func openPhotosViewController(id: Int, from controller: String)
    func goToBack(from controller: String)
}

class Coordinator: CoordinatorProtocol {
    
    let feedNavigationController = UINavigationController()
    let profileNavigationController = UINavigationController()
    let factory: Factory
    let window: UIWindow?
    let router: RouterProtocol
    
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
        self.router = Router()
    }
    
    func start() {
        window?.rootViewController = factory.makeStartModule(coordinator: self)
    }
    
    func generalModule(id: Int)  {
        let tabBar = factory.makeMainTabBarController(controllers: [feedNavigationController, profileNavigationController])
        let feedController = factory.makeFeedController(coordinator: self)
        let profileController = factory.makeProfileModule(id: id, coordinator: self)
        feedNavigationController.setViewControllers([feedController.asViewController()], animated: false)
        profileNavigationController.setViewControllers([profileController.asViewController()], animated: false)
        router.addNavigationController(controller: feedController.registerNavigationController())
        router.addNavigationController(controller: profileController.registerNavigationController())
        window?.rootViewController = tabBar
    }
    
    func openProfileModule(id: Int,from controller: String) {
        guard let navigationController = router.returnNavigationController(key: controller) else { return }
        let profileView = factory.makeProfileModule(id: id, coordinator: self)
        navigationController.pushViewController(profileView.asViewController(), animated: true)
        router.addNavigationController(controller: profileView.registerNavigationController())
    }
    
    func openPostDetailModule(from controller: String, post: Post) {
        guard let navigationController = router.returnNavigationController(key: controller) else { return }
        let postController = factory.makePostDetailModule(post: post)
        navigationController.pushViewController(postController.asViewController(), animated: true)
        router.addNavigationController(controller: postController.registerNavigationController())
    }
    
    func openPhotosViewController(id: Int, from controller: String) {
        guard let controller = router.returnNavigationController(key: controller) else { return }
        let photosView = factory.makePhotosDetailModule(id: id, coordinator: self)
        controller.pushViewController(photosView.asViewController(), animated: true)
        router.addNavigationController(controller: photosView.registerNavigationController())
    }
    
    func goToBack(from controller: String) {
        guard let controller = router.returnNavigationController(key: controller) else { return }
        controller.popViewController(animated: true)
    }
}

