//
//  DetailPostHeaderView.swift
//  Netology VK
//
//  Created by Ильнур Закиров on 18.11.2022.
//

import UIKit

class DetailPostHeaderView: UIView {
    
    var repostViewContraints: [NSLayoutConstraint] = []
    var lowViewConstraint: NSLayoutConstraint?

    let avataImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    let nameLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Inter-Medium", size: 16)
        view.textColor = UIColor(red: 1, green: 0.62, blue: 0.271, alpha: 1)
        return view
    }()
    
    let attachmentView = AttachmentsView()

    let textView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Inter-Regular", size: 14)
        view.numberOfLines = 0
        return view
    }()
    let repostView = RepostView()
    let lowView = LowView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Настройка UI
    func setupViews(model: Post) {
        [avataImageView, nameLabel, attachmentView, textView, lowView].forEach(addSubview(_:))
        avataImageView.anchor(top: topAnchor,
                              leading: leadingAnchor,
                              bottom: nil,
                              trailing: nil,
                              padding: UIEdgeInsets(top: 18, left: 29, bottom: 0, right: 0),
                              size: CGSize(width: 40, height: 40))
        nameLabel.leadingAnchor.constraint(equalTo: avataImageView.trailingAnchor, constant: 16).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: avataImageView.centerYAnchor).isActive = true
        attachmentView.anchor(top: avataImageView.bottomAnchor,
                              leading: leadingAnchor,
                              bottom: nil,
                              trailing: trailingAnchor,
                              padding: UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0))
        textView.anchor(top: attachmentView.bottomAnchor,
                        leading: leadingAnchor,
                        bottom: nil,
                        trailing: trailingAnchor,
                        padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        lowView.anchor(top: nil,
                       leading: leadingAnchor,
                       bottom: bottomAnchor,
                       trailing: trailingAnchor)
        
        if model.copyHistory != nil {
            addSubview(repostView)
            repostView.anchor(top: textView.bottomAnchor,
                              leading: leadingAnchor,
                              bottom: nil,
                              trailing: trailingAnchor,
                              padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
            lowView.topAnchor.constraint(equalTo: repostView.bottomAnchor).isActive = true
        } else {
            lowView.topAnchor.constraint(equalTo: textView.bottomAnchor).isActive = true
        }
    }
    
    //Устанавливает значения для дочерних вью
    func setupValues(from post: Post, completion: ((Bool) -> Void)?, handler: (() -> Void)?) {
        if post.copyHistory != nil {
            post.copyHistory!.text.text.isEmpty ? repostView.setupTopImageConstraint() : repostView.setupPostViewConstraints()
            
            post.copyHistory!.text.text.height() > 68 ? repostView.postView.setupButtonConstraints() : repostView.postView.setupTextViewConstraint()
        }
        
        avataImageView.download(from: post.autorImage)
        nameLabel.text = post.autorName
        textView.text = post.postText.text
        lowView.setValues(from: post)
        lowView.completion = completion
        
        if let history = post.copyHistory {
            repostView.setValuse(from: history, handler: handler)
        }
        
        if let attachments = post.attachements {
            attachmentView.setValues(from: attachments)
        }
        
    }
}
