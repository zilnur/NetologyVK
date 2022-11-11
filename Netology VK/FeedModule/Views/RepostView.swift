import UIKit

class RepostView: UIView {

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
    
    let postTextLabel: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Inter-Regular", size: 14)
        view.numberOfLines = 4
        return view
    }()
    
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
    
    func setupViews() {
        [repostArrowImage, userAvatar, userNameLabel, postTextLabel].forEach(addSubview(_:))
        
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
         
         postTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
         postTextLabel.topAnchor.constraint(equalTo: userAvatar.bottomAnchor, constant: 5),
         postTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ].forEach {$0.isActive = true}
        
        setupPostImage()
    }
    
    func setupTextLabel() {
        [postTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
         postTextLabel.topAnchor.constraint(equalTo: userAvatar.bottomAnchor, constant: 5),
         postTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ].forEach{$0.isActive = true}
    }
    
    func setupPostImage() {
        addSubview(postPhotoImageView)
        [postPhotoImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
        postPhotoImageView.topAnchor.constraint(equalTo: postTextLabel.bottomAnchor, constant: 5),
        postPhotoImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
        postPhotoImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ].forEach{$0.isActive = true}
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
    
    func prepareForReuse() {
        userAvatar.image = nil
        userNameLabel.text = nil
        postPhotoImageView.image = nil
        postTextLabel.text = nil
        height = nil
    }
    
    func setValuse(from history: History) {
        userNameLabel.text = history.name
        userAvatar.download(from: history.avatarImage)
        postTextLabel.text = history.text
        
        if let attachments = history.attachments {
            postPhotoImageView.download(from: attachments.url)
            height = attachments.height
        }
    }
}
