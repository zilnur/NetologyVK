//
//  ProfileViewController.swift
//  Netology VK
//
//  Created by Ильнур Закиров on 21.08.2022.
//

import UIKit

class ProfileViewController: ViewController {
    
    var presenter: ProfileViewInput!
    
    private lazy var refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return view
    }()
    
    private lazy var profileTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.refreshControl = refreshControl
        view.register(ProfileWallTableViewCell.self, forCellReuseIdentifier: "profileCell")
        view.register(PhotosTableViewCell.self, forCellReuseIdentifier: "profilePhotoCell")
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.setHidesBackButton(true, animated: false)
        refreshControl.beginRefreshing()
        presenter?.setModel { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.profileTableView.reloadData()
                self.refreshControl.endRefreshing()
                self.naviController()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func naviController() {
        guard let name = presenter?.getModel()?.firstName else { return }
        if presenter.isCurrentUserAccount() {
            let leftBarItem = UIBarButtonItem(title: name, style: .done, target: nil, action: nil)
            leftBarItem.isEnabled = false
            leftBarItem.setTitleTextAttributes([.font: UIFont(name: "Inter-SemiBold", size: 18)!, .foregroundColor: UIColor.black], for: .disabled)
            navigationItem.leftBarButtonItem = leftBarItem
        } else {
            let leftBarItem = UIBarButtonItem(title: "←  " + name, style: .done, target: self, action: #selector(goPreviousController))
            leftBarItem.tintColor = .black
            leftBarItem.setTitleTextAttributes([.font: UIFont(name: "Inter-SemiBold", size: 18)!, .foregroundColor: UIColor.black], for: .disabled)
            navigationItem.leftBarButtonItem = leftBarItem
        }
        navigationItem.setHidesBackButton(false, animated: true)
    }
    
    private func setupViews() {
        [profileTableView].forEach(view.addSubview(_:))
        
        profileTableView.anchor(top: view.topAnchor,
                                leading: view.leadingAnchor,
                                bottom: view.bottomAnchor,
                                trailing: view.trailingAnchor)
    }
    
    @objc
    func refreshData() {
        presenter.setModel { [weak self] in
            guard let self else {return}
            DispatchQueue.main.async {
                self.profileTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    @objc
    func goPreviousController() {
        presenter.goBack(navigationController?.description ?? "")
    }

}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfCells()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = presenter.getModel() else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "profilePhotoCell", for: indexPath) as! PhotosTableViewCell
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileWallTableViewCell
        switch indexPath.row {
        case 0:
            guard let photos = model.photos else {return UITableViewCell()}
            cell.photosCollectionView.delegate = self
            cell.photosCollectionView.dataSource = self
            cell.setupValues(from: photos)
            return cell
        default:
            guard let posts = model.posts else {return UITableViewCell()}
            cell1.backgroundColor = indexPath.row % 2 != 0 ? UIColor(named: "test") : .white
            cell1.setValues(model: posts[indexPath.row - 1]) { [weak self] in
                guard let self else { return }
                self.presenter.toProfileModule(id: posts[indexPath.row - 1].sourceId,
                                               from: self.navigationController?.description ?? "")
            } completion: { [weak self] bool in
                guard let self else {return}
                let sourceId = String(describing: posts[indexPath.row - 1].sourceId)
                let id = String(describing: posts[indexPath.row - 1].postId)
                switch bool {
                case false:
                    self.presenter.addlike(sourceId: sourceId, itemId: id)
                    self.presenter.isLikedToggle(index: indexPath.row)
                case true:
                    self.presenter.deleteLike(sourceId: sourceId, itemId: id)
                    self.presenter.isLikedToggle(index: indexPath.row)
                }
            } handler: {
                tableView.beginUpdates()
                tableView.endUpdates()
            }

            return cell1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let model = presenter.getModel() else {return UIView()}
        let view = ProfileHeaderView()
        view.setupValues(from: model)
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            presenter.toPostModule(from: navigationController?.description ?? "",
                                   index: indexPath.row - 1)
        } else {
            presenter.toPhotosModule(from: navigationController?.description ?? "")
        }
    }
    
}

extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let photos = presenter.getModel()?.photos else { return 0 }
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCollectionViewCell
        guard let photos = presenter.getModel()?.photos else {return UICollectionViewCell()}
        cell.setValues(from: photos[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 72, height: 72)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 0)
    }
}
