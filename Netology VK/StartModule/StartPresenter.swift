import Foundation
import VK_ios_sdk

protocol StartViewInput {
    func toSignUpView()
    func setAuthServiceDelegates(delegate: VKSdkDelegate, uiDelegate: VKSdkUIDelegate)
    func networkTest()
}

protocol StartViewOutput {
    func presentAuthView(controller: UIViewController)
    func pushNextView(controller: UIViewController)
}

class StartModulePresenter: StartViewInput {
    
//    let coordinator: Coordinator
    var authService: VkAuthService?
    let networkFetcher = NetworkDataFetcher()
    
    var view: StartViewOutput?
    
//    init() {
//
//    }
    
    func toSignUpView() {
        authService?.wakeUpSession()
    }
    
    func setAuthServiceDelegates(delegate: VKSdkDelegate, uiDelegate: VKSdkUIDelegate) {
        
    }
}

extension StartModulePresenter: AuthDelegate {
    func shouldPresent(controller: UIViewController) {
        view?.presentAuthView(controller: controller)
    }
    
    func authorized() {
        let presenter = FeedPresenter()
        let view1 = FeedViewController(pres: presenter)
        view?.pushNextView(controller: view1)
    }
    
    func networkTest() {
//        networkService.getData(token: authService!.token!)
    }
}
