//
//  PhotosTableViewCell.swift
//  Netology VK
//
//  Created by Ильнур Закиров on 21.11.2022.
//

import UIKit

class AllPhotosTableViewCell: UITableViewCell {

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
    
    let photosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isScrollEnabled = false
        view.register(AllPhotosCollectionViewCell.self, forCellWithReuseIdentifier: "AllPhotoCell")
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
        [photoLabel, numberOfPhotoLabel, photosCollectionView].forEach(contentView.addSubview(_:))
        
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
        
        photosCollectionView.anchor(top: photoLabel.bottomAnchor,
                                    leading: contentView.leadingAnchor,
                                    bottom: contentView.bottomAnchor,
                                    trailing: contentView.trailingAnchor,
                                    padding: UIEdgeInsets(top: 0,
                                                          left: 0,
                                                          bottom: 0,
                                                          right: 0))
    }
    
    //Устанавливает значения для дочерних вью
    func setupValues(from photos: [String], photoHeight: Double) {
        numberOfPhotoLabel.text = String(describing: photos.count)
        photosCollectionView.reloadData()
        let _height: Double = Double(photos.count) / 3
        print(_height, ceil(_height))
        let height = ceil(_height) * photoHeight + 80
        print(height)
        photosCollectionView.heightAnchor.constraint(equalToConstant: height).isActive = true
    }

}
