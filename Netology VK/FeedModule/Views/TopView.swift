//
//  TopView.swift
//  Netology VK
//
//  Created by Ильнур Закиров on 26.10.2022.
//

import UIKit

class TopView: UIView {

    let avatarImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let nameLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Inter-Medium", size: 16)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let dateLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Inter-Regular", size: 14)
        view.textColor = .gray
        return view
    }()
    
    let menuButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(named: "menu"), for: .normal)
        view.contentVerticalAlignment = .fill
        view.contentHorizontalAlignment = .fill
        view.clipsToBounds = true
        return view
    }()
    
    var closure: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupView()
        addRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(avataOrNameTapped))
        avatarImageView.addGestureRecognizer(recognizer)
        nameLabel.addGestureRecognizer(recognizer)
    }
    
    //Настройка UI
    private func setupView() {
        [avatarImageView, nameLabel, dateLabel, menuButton].forEach(addSubview(_:))
        
        avatarImageView.anchor(top: topAnchor,
                               leading: leadingAnchor,
                               bottom: bottomAnchor,
                               trailing: nil,
                               padding: UIEdgeInsets(top: 27, left: 16, bottom: 12, right: 0),
                               size: CGSize(width: 60, height: 60))
        nameLabel.anchor(top: topAnchor,
                         leading: avatarImageView.trailingAnchor,
                         bottom: nil,
                         trailing: nil,
                         padding: UIEdgeInsets(top: 32, left: 24, bottom: 0, right: 0))
        
        dateLabel.anchor(top: nameLabel.bottomAnchor,
                         leading: nameLabel.leadingAnchor,
                         bottom: nil,
                         trailing: nil,
                         padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0))
        
        menuButton.anchor(top: topAnchor,
                          leading: nil,
                          bottom: nil,
                          trailing: trailingAnchor,
                          padding: UIEdgeInsets(top: 39, left: 0, bottom: 0, right: 26),
                          size: CGSize(width: 5, height: 21))
                               
    }
    
    //Устанавливает значения для дочерних вью
    func setValues(from post: Post, closure: (() -> Void)?) {
        nameLabel.text = post.autorName
        avatarImageView.download(from: post.autorImage)
        dateLabel.text = post.postDate.toDate()
        self.closure = closure
    }
    
    @objc
    func avataOrNameTapped() {
        closure?()
    }
}
