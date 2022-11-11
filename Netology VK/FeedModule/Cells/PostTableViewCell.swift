import UIKit

class PostTableViewCell: UITableViewCell {
    
    var moreButtonConstraints: [NSLayoutConstraint] = []
    var repostViewConstraints: [NSLayoutConstraint] = []
    var lowViewConstraint: NSLayoutConstraint?
    
    let topView = TopView()
    
    let postText: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.font = UIFont(name: "Inter-Regular", size: 14)
        view.contentMode = .top
        return view
    }()
    
    let moreButton: UIButton = {
       let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Показать больше", for: .normal)
        return view
    }()
    
    let attachmentsView = AttachmentsView()
    
    var repostView = RepostView()
    
    let lowView = LowView()
    
    var id: Int?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupLowView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        drawLines()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postText.text = nil
        repostView.prepareForReuse()
        attachmentsView.prepareForReuse()
        lowView.prepareForReuse()
    }
    
    func setValues(model: Post, attachments: PostAttachements?, history: History?,attachmentsHeight: Int?, historyHeight: Int?, completion: ((Bool) -> Void)?) {
        history != nil ? setupRepostViewConstraints() : setupLowViewConstraints()
        
        id = model.postId
        postText.text = model.postDescription
        let textWidth = contentView.frame.width - 67
        if model.postDescription.height(width: textWidth, font: UIFont(name: "Inter-Regular", size: 14)!) > 68 {
            setupButtonConstraints()
        }
        
        topView.setValues(from: model)
        lowView.setValues(from: model)
        lowView.completion = completion
        
        if let attachments = model.attachements {
            attachmentsView.setValues(from: attachments)
        }
        
        if let history = history {
            repostView.setValuse(from: history)
        }
        
    }
    
    func setupViews() {
        contentView.backgroundColor = .clear
        
        [topView, postText, attachmentsView, lowView].forEach(contentView.addSubview(_:))
        
        [topView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
         topView.topAnchor.constraint(equalTo: contentView.topAnchor),
         topView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
         
         postText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 52),
         postText.topAnchor.constraint(equalTo: topView.bottomAnchor),
         postText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
         postText.heightAnchor.constraint(equalToConstant: 85),
         
         attachmentsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 52),
         attachmentsView.topAnchor.constraint(equalTo: postText.bottomAnchor, constant: 15),
         attachmentsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ].forEach {$0.isActive = true}
    }
    
    func setupRepostViewConstraints() {
        if repostView.superview == nil {
            contentView.addSubview(repostView)
        }
        if repostViewConstraints.isEmpty {
        repostViewConstraints = [repostView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 52),
         repostView.topAnchor.constraint(equalTo: attachmentsView.bottomAnchor, constant: 15),
         repostView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
         lowView.topAnchor.constraint(equalTo: repostView.bottomAnchor)
        ]
        }
        lowViewConstraint?.isActive = false
        repostViewConstraints.forEach({$0.isActive = true})
    }
    
    func setupLowViewConstraints() {
        if lowViewConstraint == nil {
            lowViewConstraint = lowView.topAnchor.constraint(equalTo: attachmentsView.bottomAnchor)
        }
        repostView.removeFromSuperview()
        repostViewConstraints.forEach({$0.isActive = false})
        lowViewConstraint?.isActive = true
    }
    
    func setupButtonConstraints() {
        if moreButton.superview == nil {
            contentView.addSubview(moreButton)
        }
        if moreButtonConstraints.isEmpty {
            moreButtonConstraints = [
                moreButton.leadingAnchor.constraint(equalTo: postText.leadingAnchor),
                moreButton.bottomAnchor.constraint(equalTo: postText.bottomAnchor),
                moreButton.trailingAnchor.constraint(equalTo: postText.trailingAnchor),
                moreButton.heightAnchor.constraint(equalToConstant: 17)
            ]
        }
        moreButtonConstraints.forEach({$0.isActive = true})
    }
    
    func setupLowView() {
        [lowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
         lowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
         lowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ].forEach {$0.isActive = true}
    }
    
    func drawLines() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: self.frame.minX + 28, y: topView.avatarImageView.frame.maxY + 32))
        path.addLine(to: CGPoint(x: self.frame.minX + 28, y: lowView.frame.minY - 12))
        let color = UIColor.black
        color.setStroke()
        path.lineWidth = 0.5
        path.stroke()
        
        let path2 = UIBezierPath()
        let start = CGPoint(x: self.contentView.frame.minX, y: lowView.frame.minY + 10)
        let end = CGPoint(x: self.contentView.frame.maxX, y: lowView.frame.minY + 10)
        path2.move(to: start)
        path2.addLine(to: end)
        let color2 = UIColor.gray
        color2.setStroke()
        path2.lineWidth = 0.4
        path2.stroke()
    }
}
