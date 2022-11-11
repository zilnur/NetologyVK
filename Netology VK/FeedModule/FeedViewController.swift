import UIKit

class FeedViewController: UIViewController {
    
    var pres: FeedPresenter
    
    lazy var ref: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        return view
    }()
    
    private lazy var postsTableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(PostTableViewCell.self, forCellReuseIdentifier: "cell")
        view.refreshControl = ref
        view.addSubview(ref)
        view.separatorColor = .clear
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    init (pres: FeedPresenter) {
        self.pres = pres
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        naviController()
        postsTableView.refreshControl?.beginRefreshing()
        pres.setModel {
            DispatchQueue.main.async {
                self.postsTableView.refreshControl?.endRefreshing()
                self.postsTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        view.addSubview(postsTableView)
        
        postsTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                              leading: view.leadingAnchor,
                              bottom: view.bottomAnchor,
                              trailing: view.trailingAnchor)
    }
    
    func naviController() {
        let app = UINavigationBarAppearance()
        app.configureWithOpaqueBackground()
        app.backgroundColor = .white
        navigationController?.navigationBar.scrollEdgeAppearance = app
    }
    
    @objc func refreshTableView() {
        pres.setModel {
            DispatchQueue.main.async {
                self.postsTableView.refreshControl?.endRefreshing()
                self.postsTableView.reloadData()
            }
        }
    }
}

extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pres.numberOfCells()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PostTableViewCell else {
            return UITableViewCell()

        }
        cell.selectionStyle = .none
        cell.backgroundColor = indexPath.row % 2 != 0 ? UIColor(named: "test") : .white
        cell.setValues(model: pres.getModel().posts[indexPath.row],
                       attachments: pres.getModel().attachments[indexPath.row],
                       history: pres.getModel().copyHistory[indexPath.row],
                       attachmentsHeight: pres.getModel().attachentsImageHeight[indexPath.row],
                       historyHeight: pres.getModel().historyImageHeight[indexPath.row]) { [weak self] bool in
            guard let self = self else {return}
            switch bool {
            case false:
                self.pres.addLike(sourceId: self.pres.getModel().posts[indexPath.row].sourceId,
                                  itemId: self.pres.getModel().posts[indexPath.row].postId)
            case true:
                self.pres.deleteLike(sourceId: self.pres.getModel().posts[indexPath.row].sourceId,
                                  itemId: self.pres.getModel().posts[indexPath.row].postId)
            }
        }
        return cell
    }
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let cell = tableView.cellForRow(at: indexPath) as! PostTableViewCell
            tableView.beginUpdates()
            cell.postText.numberOfLines = cell.postText.numberOfLines == 0 ? 4 : 0
            cell.repostView.postTextLabel.numberOfLines = cell.repostView.postTextLabel.numberOfLines == 0 ? 4 : 0
            cell.draw(.zero)
            tableView.endUpdates()
        }
}
