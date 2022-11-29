import Foundation
import UIKit

class Factory {
    
    let fetcher = GeneralDataFetcher()
    let authService = VkAuthService()
    
    func makeStartModule(coordinator: CoordinatorProtocol) -> UIViewController {
        let controller = StartViewController()
        let presenter = StartModulePresenter(view: controller, coordinator: coordinator)
        controller.presenter = presenter
        authService.delegate = presenter
        presenter.authService = authService
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
    
    func makeFeedController(coordinator: CoordinatorProtocol) -> ViewControllerProtocol {
        let controller = FeedViewController()
        let presenter = FeedPresenter(dataFetcher: fetcher, coordinator: coordinator)
        controller.pres = presenter
        return controller
    }
    
    func makeProfileModule(id: Int, coordinator: CoordinatorProtocol) -> ViewControllerProtocol {
        let controller = ProfileViewController()
        let presenter = ProfilePresenter(id: id,dataFentcher: fetcher,coordinator: coordinator,authService: authService)
        controller.presenter = presenter
        return controller
    }
    
    func makePostDetailModule(post: Post) -> ViewControllerProtocol {
        let controller = PostDetailViewController()
        let presenter = PostDetailPresenter(post: post, dataFetcher: fetcher, view: controller)
        controller.presenter = presenter
        return controller
    }
    
    func makePhotosDetailModule(id: Int, coordinator: CoordinatorProtocol) -> ViewControllerProtocol {
        let controller = PhotoDetailViewController()
        let presenter = PhotosDetailPresenter(dataFetcher: fetcher, coordinator: coordinator, id: id)
        controller.presenter = presenter
        return controller
    }
    
}
