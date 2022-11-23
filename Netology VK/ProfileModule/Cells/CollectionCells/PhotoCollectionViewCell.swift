//
//  PhotoCollectionViewCell.swift
//  Netology VK
//
//  Created by Ильнур Закиров on 15.11.2022.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    private let photoImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.contentMode = .center
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
    //Настройка UI
    private func setupViews() {
        contentView.backgroundColor = .white
        contentView.addSubview(photoImageView)
        photoImageView.anchor(top: contentView.topAnchor,
                              leading: contentView.leadingAnchor,
                              bottom: contentView.bottomAnchor,
                              trailing: contentView.trailingAnchor,
                              size: CGSize(width: 72, height: 72))
    }
    
    //Устанавливает значения для дочерних вью
    func setValues(from model: String) {
        photoImageView.download(from: model)
    }
}
