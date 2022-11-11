//
//  MessageViewController.swift
//  Netology VK
//
//  Created by Ильнур Закиров on 01.08.2022.
//

import UIKit

class MessageViewController: UIViewController {
    
    private let confirmationOfRegistrationLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Подтверждение регистрации"
        view.font = UIFont(name: "Inter-SemiBold", size: 18)
        view.textColor = UIColor(red: 0.965, green: 0.592, blue: 0.027, alpha: 1)
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        let text = NSMutableAttributedString(string: "Мы отправили SMS с кодом на номер\n+38 099 999 99 99 ")
        let range = text.mutableString.range(of: "Мы отправили SMS с кодом на номер")
        let range1 = text.mutableString.range(of: "+38 099 999 99 99")
        text.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Inter-Regular", size: 14)!, range: range)
        text.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Inter-SemiBold", size: 14)!, range: range1)
        view.attributedText = text
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    
    let enterTheCodeLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Введите код из SMS"
        view.font = UIFont(name: "Inter-Regular", size: 12)
        view.textColor = UIColor(red: 0.495, green: 0.507, blue: 0.512, alpha: 1)
        return view
    }()
    
    let enterTheCodeTextField: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.textAlignment = .center
        return view
    }()
    
    private let signUpButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.setTitle("ЗАРЕГИСТРИРОВАТЬСЯ", for: .normal)
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let checkMarkImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: "checkMark"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        [confirmationOfRegistrationLabel, descriptionLabel,enterTheCodeLabel, enterTheCodeTextField, signUpButton, checkMarkImage].forEach(view.addSubview(_:))
        
        [confirmationOfRegistrationLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
         confirmationOfRegistrationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         
         descriptionLabel.topAnchor.constraint(equalTo: confirmationOfRegistrationLabel.bottomAnchor, constant: 12),
         descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         
         enterTheCodeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 58),
         enterTheCodeLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 118),
         
         enterTheCodeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 58),
         enterTheCodeTextField.topAnchor.constraint(equalTo: enterTheCodeLabel.bottomAnchor, constant: 5),
         enterTheCodeTextField.heightAnchor.constraint(equalToConstant: 48),
         enterTheCodeTextField.widthAnchor.constraint(equalToConstant: 261),
         
         signUpButton.topAnchor.constraint(equalTo: enterTheCodeTextField.bottomAnchor, constant: 86),
         signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         signUpButton.heightAnchor.constraint(equalToConstant: 47),
         signUpButton.widthAnchor.constraint(equalToConstant: 261),
         
         checkMarkImage.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 43),
         checkMarkImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         checkMarkImage.heightAnchor.constraint(equalToConstant: 100),
         checkMarkImage.widthAnchor.constraint(equalToConstant: 86)
        ].forEach({$0.isActive = true})
    }
}
