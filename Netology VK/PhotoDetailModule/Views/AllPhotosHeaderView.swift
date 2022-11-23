//
//  AllPhotosHeaderView.swift
//  Netology VK
//
//  Created by Ильнур Закиров on 21.11.2022.
//

import UIKit

class AllPhotosHeaderView: UIView {

    private let albumLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Альбомы"
        view.font = UIFont(name: "Inter-Medium", size: 16)
        return view
    }()
    
    private let numberOfAlbumsLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Inter-Medium", size: 16)
        view.textColor = .gray
        return view
    }()
    
    let photosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(AllPhotosCollectionViewCell.self, forCellWithReuseIdentifier: "AlbumPhotoCell")
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Настройка UI
    private func setupViews() {
        [albumLabel, numberOfAlbumsLabel, photosCollectionView].forEach(addSubview(_:))
        
        albumLabel.anchor(top: topAnchor,
                          leading: leadingAnchor,
                          padding: UIEdgeInsets(top: 10 ,
                                                left: 16,
                                                bottom: 0,
                                                right: 0))
        numberOfAlbumsLabel.anchor(top: topAnchor,
                                  leading: albumLabel.trailingAnchor,
                                  padding: UIEdgeInsets(top: 10,
                                                        left: 10,
                                                        bottom: 0,
                                                        right: 0))
        
        photosCollectionView.anchor(top: albumLabel.bottomAnchor,
                                    leading: leadingAnchor,
                                    bottom: bottomAnchor,
                                    trailing: trailingAnchor,
                                    padding: UIEdgeInsets(top: 0,
                                                          left: 0,
                                                          bottom: 0,
                                                          right: 0),
                                    size: CGSize(width: 0, height: 112))
    }
    
    //Устанавливает значения для дочерних вью
    func setupValues(from photos: [String]) {
        numberOfAlbumsLabel.text = String(describing: photos.count)
        photosCollectionView.reloadData()
    }

}
