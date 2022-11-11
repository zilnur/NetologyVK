import UIKit

class AttachmentsView: UIView {

    let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.sizeToFit()
        return view
    }()
    
    var height: Int? {
        didSet {
            setupHeigth()
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
        addSubview(imageView)
        imageView.anchor(top: topAnchor,
                             leading: leadingAnchor,
                             bottom: bottomAnchor,
                             trailing: trailingAnchor)
    }
    
    func setupHeigth() {

        if imageHeightConstraint == nil {
            if let height = height {
                imageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: CGFloat(height))
            }
            imageHeightConstraint?.isActive = true
        } else {
            imageHeightConstraint?.isActive = false
        }
    }
    
    func setValues(from attachment: PostAttachements) {
        imageView.download(from: attachment.url)
        height = attachment.height
    }
    
    func prepareForReuse() {
        imageView.image = nil
        height = nil
    }
}
