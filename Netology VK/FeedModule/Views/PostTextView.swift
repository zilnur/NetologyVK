//
//  PostTextView.swift
//  Netology VK
//
//  Created by Ильнур Закиров on 11.11.2022.
//

import UIKit

class PostTextView: UIView {
    
    var moreButtonConstraints: [NSLayoutConstraint] = []
    var postViewConstraint: NSLayoutConstraint?
    var postViewHeightConstraint: NSLayoutConstraint?

    let postText: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 4
        view.font = UIFont(name: "Inter-Regular", size: 14)
        view.contentMode = .top
        view.sizeToFit()
        return view
    }()
    
    lazy var moreButton: UIButton = {
       let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Показать больше", for: .normal)
        view.setTitleColor(.link, for: .normal)
        view.titleLabel?.font = UIFont(name: "Inter-Regular", size: 14)
        view.contentHorizontalAlignment = .leading
        view.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        return view
    }()
    
    var handler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -Настройка UI
    private func setupViews() {
        addSubview(postText)
        postText.anchor(top: topAnchor,
                        leading: leadingAnchor,
                        bottom: nil,
                        trailing: trailingAnchor)
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
                moreButton.heightAnchor.constraint(equalToConstant: 14)
            ]
        }
        postViewConstraint?.isActive = false
        moreButtonConstraints.forEach({$0.isActive = true})
    }
    
    func setupTextViewConstraint() {
        if postViewConstraint == nil {
            postViewConstraint = postText.bottomAnchor.constraint(equalTo: bottomAnchor)
        }
        moreButton.removeFromSuperview()
        moreButtonConstraints.forEach({$0.isActive = false})
        postViewConstraint?.isActive = true
    }
    //MARK: -Конец настройки UI

    //Устанавливает значения для дочерних вью
    func setValue(from text: PostText) {
        postText.text = text.text
    }
    
    //Передать в одноименный метод в UITableViewCell
    func prepareForReuse() {
        postText.text = nil
    }
    
    @objc func moreButtonTapped() {
        guard let handler else { return }
        moreButton.isHidden = true
        postText.numberOfLines = 0
        handler()
    }
}
