import Foundation
import VK_ios_sdk

protocol AuthDelegate {
    func shouldPresent(controller: UIViewController)
    func authorized()
}

class VkAuthService: NSObject, VKSdkDelegate, VKSdkUIDelegate {
    
    let AppID = "51412278"
    let VkSDK: VKSdk
    var delegate: AuthDelegate?
    var token: String? {
        return VKSdk.accessToken()?.userId
    }
    
    override init() {
        VkSDK = VKSdk.initialize(withAppId: AppID)
        super.init()
        VkSDK.register(self)
        VkSDK.uiDelegate = self
    }
    
    func wakeUpSession() {
        let scope = ["wall,friends,photos,video,groups"]
        VKSdk.wakeUpSession(scope) { [weak self] state, error in
            guard let self = self else { return }
            switch state {
            case .initialized:
                VKSdk.authorize(scope)
            case .authorized:
                self.delegate?.authorized()
            default:
                print(error?.localizedDescription as Any )
            }
        }
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if result.token != nil {
            delegate?.authorized()
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        print(#function)
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        delegate?.shouldPresent(controller: controller)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print(#function)
    }
    
}
