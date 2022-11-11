//
//  SignUpViewController.swift
//  Netology VK
//
//  Created by Ильнур Закиров on 20.07.2022.
//

import UIKit
import VK_ios_sdk

class SignUpViewController: UIViewController {
    
    private let signUpLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "ЗАРЕГИСТРИРОВАТЬСЯ"
        view.font = UIFont(name: "Inter-SemiBold", size: 18)
        return view
    }()
    
    private let enteringNumberInfoLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        let text = NSMutableAttributedString(string: "Введите логин и пароль\nОни будут использоваться\nдля входа в аккаунт")
        let range1 = text.mutableString.range(of: "Введите логин и пароль")
        let range2 = text.mutableString.range(of: "Они будут использоваться\nдля входа в аккаунт")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        text.addAttributes([NSAttributedString.Key.font : UIFont(name: "Inter-Medium", size: 16)!,
                            NSAttributedString.Key.paragraphStyle : paragraphStyle], range: range1)
        text.addAttributes([NSAttributedString.Key.font : UIFont(name: "Inter-Medium", size: 12)!,
                            NSAttributedString.Key.foregroundColor : UIColor.gray],
                           range: range2)
        view.attributedText = text
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    
    private lazy var emailTextField: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.cornerRadius = 10
        view.textAlignment = .center
        view.keyboardType = .emailAddress
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    private lazy var passTextField: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.cornerRadius = 10
        view.textAlignment = .center
        view.isSecureTextEntry = true
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return view
    }()
    
    private lazy var onwardButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("ЗАРЕГИСТРИРОВАТЬСЯ", for: .normal)
        view.backgroundColor = UIColor(named: "buttonColor")
        view.layer.cornerRadius = 10
        view.addTarget(self, action: #selector(tapOnwardBtn), for: .touchUpInside)
        return view
    }()
    
    private let infoLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Нажимая кнопку “Далее” Вы принимаете\nпользовательское Соглашение и политику\nконфедициальности"
        view.font = UIFont(name: "Inter-Medium", size: 12)
        view.textColor = .gray
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
//    init(presenter: SignUpPresenter) {
//        self.presenter = presenter
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        setupViews()
    }
    
    func setupViews() {
        view.backgroundColor = .white
        [signUpLabel, enteringNumberInfoLabel, emailTextField, passTextField, onwardButton, infoLabel]
            .forEach(view.addSubview(_:))
        [signUpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         signUpLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 148),
         
         enteringNumberInfoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         enteringNumberInfoLabel.topAnchor.constraint(equalTo: signUpLabel.bottomAnchor, constant: 70),
         
         emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         emailTextField.topAnchor.constraint(equalTo: enteringNumberInfoLabel.bottomAnchor, constant: 16),
         emailTextField.heightAnchor.constraint(equalToConstant: 48),
         emailTextField.widthAnchor.constraint(equalToConstant: 260),
         
         passTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         passTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: -1),
         passTextField.heightAnchor.constraint(equalToConstant: 48),
         passTextField.widthAnchor.constraint(equalToConstant: 260),
         
         onwardButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         onwardButton.topAnchor.constraint(equalTo: passTextField.bottomAnchor, constant: 70),
         onwardButton.heightAnchor.constraint(equalToConstant: 47),
         onwardButton.widthAnchor.constraint(equalToConstant: 260),
         
         infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         infoLabel.topAnchor.constraint(equalTo: onwardButton.bottomAnchor, constant: 20)
        ].forEach({$0.isActive = true})
    }
    
    func getData() {
        
        
    }
    
    @objc private func tapOnwardBtn() {
//        let pres = SignUpPresenter()
//        pres.eee { ewq in
//            let pres = FeedPresenter(model: [])
//            let view = FeedViewController(pres: pres)
//            self.navigationController?.pushViewController(view, animated: true)
//        }
//        print("qwe")
//        let net = NetworkService()
//        net.getData {  in
//            switch result {
//                
//            case .success(let feed):
//                print(feed.response.items)
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
    
}
    
