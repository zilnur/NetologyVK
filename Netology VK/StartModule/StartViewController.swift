import UIKit
import VK_ios_sdk

class StartViewController: UIViewController {
    
    let presenter: StartModulePresenter
    
    private let logoImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "logo"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var signUpButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("ЗАРЕГИСТРИРОВАТЬСЯ", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.backgroundColor = UIColor(named: "buttonColor")
        view.layer.cornerRadius = 10
        view.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        return view
    }()
    
    init(presenter: StartModulePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        presenter.networkTest()
    }

    private func setupViews() {
        view.backgroundColor = .white
        [logoImageView, signUpButton].forEach(view.addSubview(_:))
        
        [logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 113),
         
         signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         signUpButton.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 91),
         signUpButton.widthAnchor.constraint(equalToConstant: 261),
         signUpButton.heightAnchor.constraint(equalToConstant: 47)
        ].forEach({$0.isActive = true})
    }
    
    @objc private func signUpTapped() {
        presenter.toSignUpView()
    }

}

extension StartViewController: StartViewOutput {
    
    func presentAuthView(controller: UIViewController) {
        self.modalPresentationStyle = .currentContext
        self.modalTransitionStyle = .coverVertical
        self.present(controller, animated: true)
    }
    
    func pushNextView(controller: UIViewController) {
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

