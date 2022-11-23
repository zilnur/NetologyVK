//
//  CreateCommentView.swift
//  Netology VK
//
//  Created by Ильнур Закиров on 19.11.2022.
//

import UIKit

class CreateCommentView: UIView {

    private lazy var commentTextField: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.placeholder = "Ваш комментарий"
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 45))
        view.leftViewMode = .always
        view.addTarget(self, action: #selector(toggleButtonState), for: .editingChanged)
        return view
    }()
    
    private lazy var sendButton:UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(systemName: "arrow.up.circle"), for: .normal)
        view.tintColor = .black
        view.isEnabled = false
        view.addTarget(self, action: #selector(sendComment), for: .touchUpInside)
        return view
    }()
    
    var completion: ((String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Настройка UI
    private func setupViews() {
        [commentTextField, sendButton].forEach(addSubview(_:))
        
        sendButton.anchor(top: topAnchor,
                          leading: nil,
                          bottom: bottomAnchor,
                          trailing: trailingAnchor,
                          size: CGSize(width: 40, height: 40))
        
        commentTextField.anchor(top: topAnchor,
                                leading: leadingAnchor,
                                bottom: bottomAnchor,
                                trailing: sendButton.leadingAnchor)
    }
    
    @objc
    func sendComment() {
        completion?(commentTextField.text!)
        commentTextField.text = ""
    }
    
    @objc
    func toggleButtonState() {
        if commentTextField.text != "" {
            sendButton.isEnabled = true
        } else {
            sendButton.isEnabled = false
        }
    }
}
