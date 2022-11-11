//
//  PostTextView.swift
//  Netology VK
//
//  Created by Ильнур Закиров on 11.11.2022.
//

import UIKit

class PostTextView: UIView {
    
    var moreButtonConstraints: [NSLayoutConstraint] = []

    let postText: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 4
        view.font = UIFont(name: "Inter-Regular", size: 14)
        view.contentMode = .top
        return view
    }()
    
    let moreButton: UIButton = {
       let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Показать больше", for: .normal)
        view.contentHorizontalAlignment = .leading
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(postText)
        postText.anchor(top: topAnchor,
                        leading: leadingAnchor,
                        bottom: bottomAnchor,
                        trailing: nil)
    }
    
    func setupButtonConstraints() {
        if moreButton.superview == nil {
            addSubview(moreButton)
        }
        if moreButtonConstraints.isEmpty {
            moreButtonConstraints = [
                moreButton.leadingAnchor.constraint(equalTo: postText.leadingAnchor),
                moreButton.topAnchor.constraint(equalTo: postText.bottomAnchor),
                moreButton.trailingAnchor.constraint(equalTo: postText.trailingAnchor),
                moreButton.bottomAnchor.constraint(equalTo: bottomAnchor),
                moreButton.heightAnchor.constraint(equalToConstant: 17)
            ]
        }
        moreButtonConstraints.forEach({$0.isActive = true})
    }
}
