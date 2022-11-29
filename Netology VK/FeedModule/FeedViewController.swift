import UIKit

class FeedViewController: ViewController {
    //MARK: -Properties
    
    var pres: FeedPresenterOutput!
    
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
    
    //MARK: -Functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        postsTableView.refreshControl?.beginRefreshing()
        pres?.setModel { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.postsTableView.refreshControl?.endRefreshing()
                self.postsTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        naviController()
        setupViews()
    }
    
    //Настройка UI
    private func setupViews() {
        view.addSubview(postsTableView)
        
        postsTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                              leading: view.leadingAnchor,
                              bottom: view.bottomAnchor,
                              trailing: view.trailingAnchor)
    }
    
    //Настройка UINavigationController
    private func naviController() {
        let leftBarItem = UIBarButtonItem(title: "Главная", style: .plain, target: nil, action: nil)
        leftBarItem.isEnabled = false
        leftBarItem.setTitleTextAttributes([.font: UIFont(name: "Inter-SemiBold", size: 18)!, .foregroundColor: UIColor.black], for: .disabled)
        navigationItem.leftBarButtonItem = leftBarItem
    }
    
    //Настройка Pull to refresh
    @objc func refreshTableView() {
        pres?.setModel {
            DispatchQueue.main.async {
                self.postsTableView.refreshControl?.endRefreshing()
                self.postsTableView.reloadData()
            }
        }
    }
}

extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pres?.numberOfCells() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PostTableViewCell else {
            return UITableViewCell()

        }
        cell.selectionStyle = .none
        cell.backgroundColor = indexPath.row % 2 != 0 ? UIColor(named: "test") : .white
        cell.setValues(model: pres!.getModel().posts[indexPath.row],
                       attachments: pres!.getModel().attachments[indexPath.row],
                       history: pres!.getModel().copyHistory[indexPath.row],
                       attachmentsHeight: pres!.getModel().attachentsImageHeight[indexPath.row],
                       historyHeight: pres!.getModel().historyImageHeight[indexPath.row]) {
            [weak self] in
            guard let self = self else {return}
            self.pres.toProfileModule(id: self.pres.getModel().posts[indexPath.row].sourceId,
                                      from: self.navigationController?.description ?? "")
        } completion: { [weak self] bool in
            guard let self = self else {return}
            switch bool {
            case false:
                self.pres?.addLike(sourceId: self.pres!.getModel().posts[indexPath.row].sourceId,
                                  itemId: self.pres!.getModel().posts[indexPath.row].postId)
                self.pres.isLikedToggle(index: indexPath.row)
            case true:
                self.pres?.deleteLike(sourceId: self.pres!.getModel().posts[indexPath.row].sourceId,
                                  itemId: self.pres!.getModel().posts[indexPath.row].postId)
                self.pres.isLikedToggle(index: indexPath.row)
            }
        } handler: {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        return cell
    }
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("feed \(self.description)")
            pres.toPostModule(index: indexPath.row, register: self.navigationController?.description ?? "")
        }
}
