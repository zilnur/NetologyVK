import Foundation
import VK_ios_sdk

protocol StartViewInput {
    func toSignUpView()
}

protocol StartViewOutput {
    func presentAuthView(controller: UIViewController)
    func pushNextView(controller: UIViewController)
}

class StartModulePresenter: StartViewInput {
    
    let coordinator: CoordinatorProtocol
    var authService: VkAuthService?
    let view: StartViewOutput
    
    init(view: StartViewOutput, coordinator: CoordinatorProtocol) {
        self.view = view
        self.coordinator = coordinator
    }
    
    //Запускает процесс авторизации
    func toSignUpView() {
        authService?.wakeUpSession()
    }
}

extension StartModulePresenter: AuthDelegate {
    
    //Переходит на экран авторизации.
    func shouldPresent(controller: UIViewController) {
        view.presentAuthView(controller: controller)
    }
    
    //В случае успешной авторизации переходит на главный экран
    func authorized() {
        guard let token = Int(authService?.token ?? "") else { return }
        coordinator.generalModule(id: token)
    }
}
