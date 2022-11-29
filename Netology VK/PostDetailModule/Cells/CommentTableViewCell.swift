//
//  CommentTableViewCell.swift
//  Netology VK
//
//  Created by Ильнур Закиров on 18.11.2022.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    let autorAvatar: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.contentMode = .scaleToFill
        return view
    }()
    
    let autorName: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(red: 1, green: 0.62, blue: 0.271, alpha: 1)
        view.font = UIFont(name: "Inter-Medium", size: 12)
        return view
    }()
    
    let commentText: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(red: 0.495, green: 0.507, blue: 0.512, alpha: 1)
        view.font = UIFont(name: "Inter-Regular", size: 12)
        view.numberOfLines = 0
        return view
    }()
    
    let commentDate: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(red: 0.767, green: 0.792, blue: 0.804, alpha: 1)
        view.font = UIFont(name: "Inter-Regular", size: 12)
        return view
    }()
    
    private lazy var likesButton: UIButton = {
        let view = UIButton()
        view.addTarget(self, action: #selector(likesButtonTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .black
        return view
    }()
    
    var completion: ((Bool) -> Void)?
    
    let likesValueLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(red: 0.495, green: 0.507, blue: 0.512, alpha: 1)
        view.font = UIFont(name: "Inter-Regular", size: 12)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Настройка UI
    private func setupViews() {
        [autorAvatar, autorName, commentText, commentDate, likesButton, likesValueLabel].forEach(contentView.addSubview(_:))
        [autorAvatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
         autorAvatar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
         autorAvatar.heightAnchor.constraint(equalToConstant: 30),
         autorAvatar.widthAnchor.constraint(equalToConstant: 30),
         
         autorName.leadingAnchor.constraint(equalTo: autorAvatar.trailingAnchor, constant: 10),
         autorName.centerYAnchor.constraint(equalTo: autorAvatar.centerYAnchor),
         
         commentText.leadingAnchor.constraint(equalTo: autorName.leadingAnchor),
         commentText.topAnchor.constraint(equalTo: autorAvatar.bottomAnchor, constant: 5),
         commentText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
         
         commentDate.leadingAnchor.constraint(equalTo: commentText.leadingAnchor),
         commentDate.topAnchor.constraint(equalTo: commentText.bottomAnchor, constant: 5),
         commentDate.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),

         likesValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
         likesValueLabel.centerYAnchor.constraint(equalTo: autorName.centerYAnchor),
         
         likesButton.trailingAnchor.constraint(equalTo: likesValueLabel.leadingAnchor, constant: -10),
         likesButton.centerYAnchor.constraint(equalTo: autorAvatar.centerYAnchor),
         likesButton.widthAnchor.constraint(equalToConstant: 20),
         likesButton.heightAnchor.constraint(equalToConstant: 20)
        ].forEach({$0.isActive = true})
    }
    
    //Устанавливает значения для дочерних вью
    func setupValues(from comment: Comment, completion: ((Bool) -> Void)?) {
        autorAvatar.download(from: comment.autorAvatar)
        autorName.text = comment.autorName
        commentText.text = comment.text
        commentDate.text = comment.date.toDate()
        likesValueLabel.text = String(describing: comment.likes)
        likesButton.setImage(comment.isLiked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), for: .normal)
        self.completion = completion
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
