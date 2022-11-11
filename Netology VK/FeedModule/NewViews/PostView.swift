//
//  TitleView.swift
//  Netology VK
//
//  Created by Ильнур Закиров on 19.10.2022.
//

import UIKit

class PostView: UIView {

    let avatarImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        return view
    }()
    
    let nameLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Inter-Medium", size: 16)
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
    
    let postText: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.font = UIFont(name: "Inter-Regular", size: 14)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
