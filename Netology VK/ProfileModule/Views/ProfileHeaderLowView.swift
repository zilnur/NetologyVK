//
//  ProfileHeaderLowView.swift
//  Netology VK
//
//  Created by Ильнур Закиров on 15.11.2022.
//

import UIKit

class ProfileHeaderLowView: UIView {
    
    private let postsCountLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Inter-Regular", size: 14)
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    private let subscribesCountLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Inter-Regular", size: 14)
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    private let followersCountLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Inter-Regular", size: 14)
        view.textAlignment = .center
        view.numberOfLines = 0
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
        [postsCountLabel, subscribesCountLabel, followersCountLabel].forEach(addSubview(_:))
        [postsCountLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 26),
        postsCountLabel.topAnchor.constraint(equalTo: topAnchor, constant: 25),
         postsCountLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25),
        
        subscribesCountLabel.topAnchor.constraint(equalTo: topAnchor, constant: 25),
         subscribesCountLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
         
         followersCountLabel.topAnchor.constraint(equalTo: topAnchor, constant: 25),
         followersCountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25)
        ].forEach({$0.isActive = true})
    }
    
    func setupViews(from profile: Profile) {
        postsCountLabel.text = "\(profile.posts?.count ?? 0)\nпубликаций"
        subscribesCountLabel.text = "\(profile.subscritionsCount ?? 0)\nподписок"
        followersCountLabel.text = "\(profile.followersCount ?? 0)\nподписчиков"
    }
}
