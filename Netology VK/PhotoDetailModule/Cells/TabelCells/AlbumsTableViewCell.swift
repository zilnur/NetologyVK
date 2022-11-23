//
//  AlbumsTableViewCell.swift
//  Netology VK
//
//  Created by Ильнур Закиров on 21.11.2022.
//

import UIKit

class AlbumsTableViewCell: UITableViewCell {

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
        [albumLabel, numberOfAlbumsLabel, photosCollectionView].forEach(contentView.addSubview(_:))
        
        albumLabel.anchor(top: contentView.topAnchor,
                          leading: contentView.leadingAnchor,
                          padding: UIEdgeInsets(top: 10 ,
                                                left: 16,
                                                bottom: 0,
                                                right: 0))
        numberOfAlbumsLabel.anchor(top: contentView.topAnchor,
                                  leading: albumLabel.trailingAnchor,
                                  padding: UIEdgeInsets(top: 10,
                                                        left: 10,
                                                        bottom: 0,
                                                        right: 0))
        
        photosCollectionView.anchor(top: albumLabel.bottomAnchor,
                                    leading: contentView.leadingAnchor,
                                    bottom: contentView.bottomAnchor,
                                    trailing: contentView.trailingAnchor,
                                    padding: UIEdgeInsets(top: 0,
                                                          left: 0,
                                                          bottom: 0,
                                                          right: 0),
                                    size: CGSize(width: 0, height: 103))
    }
    
    //Устанавливает значения для дочерних вью
    func setupValues(from photos: [String]) {
        numberOfAlbumsLabel.text = String(describing: photos.count)
        photosCollectionView.reloadData()
    }

}
