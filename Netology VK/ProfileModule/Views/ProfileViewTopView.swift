//
//  ProfileViewTopView.swift
//  Netology VK
//
//  Created by Ильнур Закиров on 13.11.2022.
//

import UIKit

class ProfileViewTopView: UIView {

    private let avatarImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 30
        return view
    }()
    
    private let nameLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Inter-SemiBold", size: 18)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        [avatarImageView, nameLabel].forEach(addSubview(_:))
        
        avatarImageView.anchor(top: topAnchor,
                               leading: leadingAnchor,
                               bottom: bottomAnchor,
                               padding: UIEdgeInsets(top: 14,
                                                     left: 26,
                                                     bottom: 15,
                                                     right: 0),
                               size: CGSize(width: 60, height: 60))
        nameLabel.anchor(top: topAnchor,
                         leading: avatarImageView.trailingAnchor,
                         padding: UIEdgeInsets(top: 22,
                                               left: 10,
                                               bottom: 0,
                                               right: 0))
    }
    
    func setupValues(from model: Profile) {
        avatarImageView.download(from: model.photo)
        nameLabel.text = model.firstName + " " + model.lastName
    }
}
