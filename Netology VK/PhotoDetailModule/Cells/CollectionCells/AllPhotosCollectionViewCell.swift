//
//  AllPhotosCollectionViewCell.swift
//  Netology VK
//
//  Created by Ильнур Закиров on 21.11.2022.
//

import UIKit

class AllPhotosCollectionViewCell: UICollectionViewCell {
    
    private let photoImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.contentMode = .center
        view.backgroundColor = .black
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
                              trailing: contentView.trailingAnchor)
    }
    
    //Устанавливает значения для дочерних вью
    func setValues(from model: String) {
        photoImageView.download(from: model)
    }
}
