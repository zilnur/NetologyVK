//
//  LowView.swift
//  Netology VK
//
//  Created by Ильнур Закиров on 26.10.2022.
//

import UIKit

class LowView: UIView {
    
    private lazy var likesButton: UIButton = {
        let view = UIButton()
//        view.setImage(UIImage(systemName: "heart"), for: .normal)
        view.addTarget(self, action: #selector(likesButtonTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .black
        return view
    }()
    
    let likesValueLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Inter-Regular", size: 14)
        return view
    }()
    
    private let commentsButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "message"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .black
        return view
    }()
    
    let commentsValueLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Inter-Regular", size: 14)
        return view
    }()
    
    private let bookmarkImageView: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "bookmark"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .black
        return view
    }()
    
    var completion: ((Bool) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Настройка UI
    private func setupViews() {
        [likesButton, likesValueLabel, commentsButton, commentsValueLabel, bookmarkImageView].forEach(addSubview(_:))
        
        [likesButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
         likesButton.topAnchor.constraint(equalTo: topAnchor, constant: 20),
         likesButton.heightAnchor.constraint(equalToConstant: 20),
         likesButton.widthAnchor.constraint(equalToConstant: 20),
         likesButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18),
         
         likesValueLabel.leadingAnchor.constraint(equalTo: likesButton.trailingAnchor, constant: 10),
         likesValueLabel.centerYAnchor.constraint(equalTo: likesButton.centerYAnchor),
         
         commentsButton.leadingAnchor.constraint(equalTo: likesValueLabel.trailingAnchor, constant: 30),
         commentsButton.topAnchor.constraint(equalTo: topAnchor, constant: 20),
         commentsButton.heightAnchor.constraint(equalToConstant: 20),
         commentsButton.widthAnchor.constraint(equalToConstant: 20),
         
         commentsValueLabel.leadingAnchor.constraint(equalTo: commentsButton.trailingAnchor, constant: 10),
         commentsValueLabel.centerYAnchor.constraint(equalTo: commentsButton.centerYAnchor),
         
         bookmarkImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
         bookmarkImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
         bookmarkImageView.heightAnchor.constraint(equalToConstant: 20),
         bookmarkImageView.widthAnchor.constraint(equalToConstant: 20)
        ].forEach({$0.isActive = true})
    }
    
    //Передать в одноименный метод в UITableViewCell
    func prepareForReuse() {
        likesValueLabel.text = nil
        commentsValueLabel.text = nil
    }
    
    //Устанавливает значения для дочерних вью
    func setValues(from post: Post) {
        likesButton.setImage(post.isLiked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), for: .normal)
        likesValueLabel.text = String(post.likes)
        commentsValueLabel.text = String(post.comments)
    }
    
    @objc
    func likesButtonTapped() {
        guard let completion = completion else {return}
        if likesButton.image(for: .normal) == UIImage(systemName: "heart") {
            likesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            if var likesValue = Int(likesValueLabel.text!) {
                likesValue += 1
                likesValueLabel.text = String(likesValue)
                completion(false)
            }
        } else {
            likesButton.setImage(UIImage(systemName: "heart"), for: .normal)
            if var likesValue = Int(likesValueLabel.text!) {
                likesValue -= 1
                likesValueLabel.text = String(likesValue)
                completion(true)
            }
        }
        
    }
}
