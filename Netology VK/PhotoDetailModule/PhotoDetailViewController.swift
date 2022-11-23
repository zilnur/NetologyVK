//
//  PhotoDetailViewController.swift
//  Netology VK
//
//  Created by Ильнур Закиров on 21.11.2022.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    
    var presenter: PhotoDetailViewInput!
    
    private lazy var photosTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(AllPhotosTableViewCell.self, forCellReuseIdentifier: "AllCell")
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    lazy var headerView: AllPhotosHeaderView = {
        let view = AllPhotosHeaderView()
        view.photosCollectionView.dataSource = self
        view.photosCollectionView.delegate = self
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.setModel { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.photosTableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(photosTableView)
        
        photosTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                               leading: view.leadingAnchor,
                               bottom: view.safeAreaLayoutGuide.bottomAnchor,
                               trailing: view.trailingAnchor)
    }

}

extension PhotoDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let height = Double(view.frame.width - 50) / 3
        guard let photos = presenter.getModel().photos?.map({$0.photo}) else { return UITableViewCell() }
        let photoCell = tableView.dequeueReusableCell(withIdentifier: "AllCell", for: indexPath) as! AllPhotosTableViewCell
        photoCell.setupValues(from: photos, photoHeight: height)
        photoCell.photosCollectionView.dataSource = self
        photoCell.photosCollectionView.delegate = self
        return photoCell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let albums = presenter.getModel().albums?.map({$0.photo}) else { return nil }
        headerView.setupValues(from: albums)
        return headerView
    }
}

extension PhotoDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let albums = presenter.getModel().albums,
              let photos = presenter.getModel().photos else { return 0}
        switch collectionView {
        case headerView.photosCollectionView:
            return albums.count
        default:
            return photos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let albums = presenter.getModel().albums,
              let photos = presenter.getModel().photos else { return UICollectionViewCell()}
        switch collectionView {
        case headerView.photosCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumPhotoCell", for: indexPath) as! AllPhotosCollectionViewCell
            cell.setValues(from: albums[indexPath.item].photo)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllPhotoCell", for: indexPath) as! AllPhotosCollectionViewCell
            cell.setValues(from: photos[indexPath.item].photo)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 50) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
}
