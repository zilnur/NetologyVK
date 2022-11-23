//
//  PhotosTableViewCell.swift
//  Netology VK
//
//  Created by Ильнур Закиров on 15.11.2022.
//

import UIKit

class PhotosTableViewCell: UITableViewCell {
    
    private let photoLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Фотографии"
        view.font = UIFont(name: "Inter-Medium", size: 16)
        return view
    }()
    
    private let numberOfPhotoLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Inter-Medium", size: 16)
        view.textColor = .gray
        return view
    }()
    
    private let arrowImage: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "chevron.right"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .black
        return view
    }()
    
    let photosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCell")
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Настройка UI
    private func setupViews() {
        [photoLabel, numberOfPhotoLabel, arrowImage, photosCollectionView].forEach(contentView.addSubview(_:))
        
        photoLabel.anchor(top: contentView.topAnchor,
                          leading: contentView.leadingAnchor,
                          bottom: nil,
                          trailing: nil,
                          padding: UIEdgeInsets(top: 10 ,
                                                left: 16,
                                                bottom: 0,
                                                right: 0))
        numberOfPhotoLabel.anchor(top: contentView.topAnchor,
                                  leading: photoLabel.trailingAnchor,
                                  bottom: nil,
                                  trailing: nil,
                                  padding: UIEdgeInsets(top: 10,
                                                        left: 10,
                                                        bottom: 0,
                                                        right: 0))
        arrowImage.anchor(top: contentView.topAnchor,
                          leading: nil,
                          bottom: nil,
                          trailing: contentView.trailingAnchor,
                          padding: UIEdgeInsets(top: 10,
                                                left: 0,
                                                bottom: 0,
                                                right: 16),
                          size: CGSize(width: 24, height: 24))
        
        photosCollectionView.anchor(top: arrowImage.bottomAnchor,
                                    leading: contentView.leadingAnchor,
                                    bottom: contentView.bottomAnchor,
                                    trailing: contentView.trailingAnchor,
                                    padding: UIEdgeInsets(top: 0,
                                                          left: 0,
                                                          bottom: 0,
                                                          right: 0),
                                    size: CGSize(width: 0, height: 92))
    }
    
    //Устанавливает значения для дочерних вью
    func setupValues(from photos: [String]) {
        numberOfPhotoLabel.text = String(describing: photos.count)
        photosCollectionView.reloadData()
    }
}
