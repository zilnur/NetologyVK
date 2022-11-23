//
//  PostDetailViewController.swift
//  Netology VK
//
//  Created by Ильнур Закиров on 12.11.2022.
//

import UIKit

class PostDetailViewController: UIViewController {
    
    var presenter: PostDetailViewInput!
    
    let refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        return view
    }()
    
    lazy var commentsTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.refreshControl = refreshControl
        view.register(CommentTableViewCell.self, forCellReuseIdentifier: "CommentCell")
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .white
        return view
    }()
    
    lazy var createCommentView: CreateCommentView = {
        let view = CreateCommentView()
        view.completion = { [weak self] text in
                guard let self else { return }
                self.presenter.createNewComment(message: text)
        }
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.setPostComments { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.commentsTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        self.refreshControl.beginRefreshing()
    }
    
    //Настройка UI
    private func setupViews() {
        view.addSubview(commentsTableView)
        view.addSubview(createCommentView)
        
        createCommentView.anchor(top: nil,
                                 leading: view.leadingAnchor,
                                 bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                 trailing: view.trailingAnchor)
        
        commentsTableView.anchor(top: view.topAnchor,
                                 leading: view.leadingAnchor,
                                 bottom: createCommentView.topAnchor,
                                 trailing: view.trailingAnchor)
    }
    
}

extension PostDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let comments = presenter.getModel().comments else {return 0}
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let comments = presenter.getModel().comments else {return UITableViewCell()}
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
        cell.setupValues(from: comments[indexPath.row]) { [weak self] bool in
            guard let self else {return}
            let sourceId = String(describing: comments[indexPath.row].autorId)
            let id = String(describing: comments[indexPath.row].id)
            switch bool {
            case true:
                self.presenter.deleteLike(sourceId: sourceId, itemId: id, type: "comment")
            case false:
                self.presenter.addLike(sourceId: sourceId, itemId: id, type: "comment")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = DetailPostHeaderView()
        view.setupViews(model: presenter.getModel().post)
        view.setupValues(from: presenter.getModel().post) { [weak self] bool in
            guard let self else {return}
            let sourceId = String(describing: self.presenter.getModel().post.sourceId)
            let id = String(describing: self.presenter.getModel().post.postId)
            switch bool {
            case true:
                self.presenter.deleteLike(sourceId: sourceId, itemId: id, type: "post")
            case false:
                self.presenter.addLike(sourceId: sourceId, itemId: id, type: "post")
            }
        } handler: {
            
        }
        return view
    }
    
}

extension PostDetailViewController: PostDetailViewOutput {
    
    func reloadTable() {
        commentsTableView.reloadData()
    }
}
