import UIKit

class PostTableViewCell: UITableViewCell {
    
    var postViewConstraints: [NSLayoutConstraint] = []
    var repostViewConstraints: [NSLayoutConstraint] = []
    var lowViewConstraint: NSLayoutConstraint?
    var attachmentViewConstraint: NSLayoutConstraint?
    
    let topView = TopView()
    let postView = PostTextView()
    let attachmentsView = AttachmentsView()
    var repostView = RepostView()
    let lowView = LowView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        drawLines()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        topView.prepareForReuse()
        postView.prepareForReuse()
        repostView.prepareForReuse()
        attachmentsView.prepareForReuse()
        lowView.prepareForReuse()
    }
    
    //Устанавливает значения для всех дочерних вью
    func setValues(model: Post, attachments: PostAttachements?, history: History?,attachmentsHeight: Int?, historyHeight: Int?, topViewClosure: (() -> Void)?, completion: ((Bool) -> Void)?, handler: (() -> Void)?) {
        history != nil ? setupRepostViewConstraints() : setupLowViewConstraints()
        model.postText.text.isEmpty ? setupAttachmentViewConstraint() : setupPostViewConstraints()
        
        model.postText.text.height() > 68 ? postView.setupButtonConstraints() : postView.setupTextViewConstraint()
        
        if model.copyHistory != nil {
            model.copyHistory!.text.text.isEmpty ? repostView.setupTopImageConstraint() : repostView.setupPostViewConstraints()
            
            model.copyHistory!.text.text.height() > 68 ? repostView.postView.setupButtonConstraints() : repostView.postView.setupTextViewConstraint()
        }
        
        topView.setValues(from: model, closure: topViewClosure)
        postView.setValue(from: model.postText)
        postView.handler = handler
        lowView.setValues(from: model)
        lowView.completion = completion
        
        if let history {
            repostView.setValuse(from: history, handler: handler)
        }
        
        if let attachments {
            attachmentsView.setValues(from: attachments)
        }
        
    }
    
    //MARK: -Настройка UI
    func setupViews() {
        contentView.backgroundColor = .clear
        
        [topView, attachmentsView, lowView].forEach(contentView.addSubview(_:))
        
        [topView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
         topView.topAnchor.constraint(equalTo: contentView.topAnchor),
         topView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

         attachmentsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 52),
         attachmentsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
         
         lowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 36),
         lowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
         lowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
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
    
    func setupPostViewConstraints() {
        if postView.superview == nil {
            contentView.addSubview(postView)
        }
        if postViewConstraints.isEmpty {
            postViewConstraints = [
                postView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 52),
                postView.topAnchor.constraint(equalTo: topView.bottomAnchor),
                postView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                attachmentsView.topAnchor.constraint(equalTo: postView.bottomAnchor, constant: 15)
            ]
        }
        attachmentViewConstraint?.isActive = false
        postViewConstraints.forEach({$0.isActive = true})
    }
    
    func setupAttachmentViewConstraint() {
        if attachmentViewConstraint == nil {
            attachmentViewConstraint = attachmentsView.topAnchor.constraint(equalTo: topView.bottomAnchor)
        }
        postView.removeFromSuperview()
        postViewConstraints.forEach({$0.isActive = false})
        attachmentViewConstraint?.isActive = true
    }
    //MARK: -Конец настройки UI
    
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
