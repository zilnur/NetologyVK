import UIKit

class RepostView: UIView {
    
    var postViewConstraints: [NSLayoutConstraint] = []
    var imageTopConstraint: NSLayoutConstraint?
    
    let repostArrowImage: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "arrow.uturn.backward"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .black
        return view
    }()
    
    let userAvatar: UIImageView = {
       let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    let userNameLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Inter-Medium", size: 16)
        return view
    }()
    
    let postView = PostTextView()
    
    let postPhotoImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var height: Int? {
        didSet {
            setupHeight()
        }
    }
    var imageHeightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -Настройка UI
    func setupViews() {
        [repostArrowImage, userAvatar, userNameLabel, postPhotoImageView].forEach(addSubview(_:))
        
        [repostArrowImage.leadingAnchor.constraint(equalTo: leadingAnchor),
         repostArrowImage.topAnchor.constraint(equalTo: topAnchor, constant: 18),
         repostArrowImage.heightAnchor.constraint(equalToConstant: 15),
         repostArrowImage.widthAnchor.constraint(equalToConstant: 15),
         
         userAvatar.leadingAnchor.constraint(equalTo: repostArrowImage.trailingAnchor, constant: 10),
         userAvatar.topAnchor.constraint(equalTo: topAnchor, constant: 5),
         userAvatar.widthAnchor.constraint(equalToConstant: 40),
         userAvatar.heightAnchor.constraint(equalToConstant: 40),
         
         userNameLabel.leadingAnchor.constraint(equalTo: userAvatar.trailingAnchor, constant: 10),
         userNameLabel.centerYAnchor.constraint(equalTo: userAvatar.centerYAnchor),
         userNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
         
         postPhotoImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
         postPhotoImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
         postPhotoImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
         
        ].forEach {$0.isActive = true}
    }
    
    func setupPostViewConstraints() {
        if postView.superview == nil {
            addSubview(postView)
        }
        if postViewConstraints.isEmpty {
            postViewConstraints = [
                postView.leadingAnchor.constraint(equalTo: leadingAnchor),
                postView.topAnchor.constraint(equalTo: userAvatar.bottomAnchor, constant: 5),
                postView.trailingAnchor.constraint(equalTo: trailingAnchor),
                postPhotoImageView.topAnchor.constraint(equalTo: postView.bottomAnchor, constant: 5)
            ]
        }
        imageTopConstraint?.isActive = false
        postViewConstraints.forEach({$0.isActive = true})
    }
    
    func setupTopImageConstraint() {
        if imageTopConstraint == nil {
            imageTopConstraint = postPhotoImageView.topAnchor.constraint(equalTo: userAvatar.bottomAnchor, constant: 5)
        }
        postView.removeFromSuperview()
        postViewConstraints.forEach({$0.isActive = false})
        imageTopConstraint?.isActive = true
    }
    
    func setupHeight() {
        if imageHeightConstraint == nil {
            if let height = height {
                imageHeightConstraint = postPhotoImageView.heightAnchor.constraint(equalToConstant: CGFloat(height))
            }
            imageHeightConstraint?.isActive = true
        } else {
            imageHeightConstraint?.isActive = false
        }
    }
    //MARK: -Конец настройки UI
    
    //Передать в одноименный метод в UITableViewCell
    func prepareForReuse() {
        userAvatar.image = nil
        userNameLabel.text = nil
        postPhotoImageView.image = nil
        postView.prepareForReuse()
        height = nil
        imageHeightConstraint = nil
    }
    
    //Устанавливает значения для дочерних вью
    func setValuse(from history: History, handler: (() -> Void)?) {
        userNameLabel.text = history.name
        userAvatar.download(from: history.avatarImage)
        postView.setValue(from: history.text)
        postView.handler = handler
        if let attachments = history.attachments {
            postPhotoImageView.download(from: attachments.url)
            height = attachments.height
        }
    }
}
