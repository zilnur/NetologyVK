import Foundation
import UIKit

class Factory {
    
    let fetcher = GeneralDataFetcher()
    let authService = VkAuthService()
    
    func makeStartModule(window: UIWindow?, coordinator: Coordinator) -> UIViewController {
        let controller = StartViewController()
        let presenter = StartModulePresenter(view: controller, coordinator: coordinator)
        controller.presenter = presenter
        authService.delegate = presenter
        presenter.authService = authService
        presenter.window = window
        return controller
    }
    
    func makeMainTabBarController(controllers: [UIViewController]) -> UITabBarController {
        let controller = UITabBarController()
        controller.viewControllers = controllers
        controller.tabBar.backgroundColor = .white
        controller.tabBar.tintColor = UIColor(named: "buttonColor")
        controller.tabBar.unselectedItemTintColor = .black
        return controller
    }
    
    func makeFeedController(coordinator: Coordinator) -> UIViewController {
        let controller = FeedViewController()
        let presenter = FeedPresenter(dataFetcher: fetcher, coordinator: coordinator)
        controller.pres = presenter
        return controller
    }
    
    func makeProfileModule(id: Int, coordinator: Coordinator) -> UIViewController {
        let controller = ProfileViewController()
        let presenter = ProfilePresenter(id: id,dataFentcher: fetcher,coordinator: coordinator,authService: authService)
        controller.presenter = presenter
        return controller
    }
    
    func makePostDetailModule(post: Post) -> UIViewController {
        let controller = PostDetailViewController()
        let presenter = PostDetailPresenter(post: post, dataFetcher: fetcher, view: controller)
        controller.presenter = presenter
        return controller
    }
    
    func makePhotosDetailModule(id: Int, coordinator: Coordinator) -> UIViewController {
        let controller = PhotoDetailViewController()
        let presenter = PhotosDetailPresenter(dataFetcher: fetcher, coordinator: coordinator, id: id)
        controller.presenter = presenter
        return controller
    }
    
}
