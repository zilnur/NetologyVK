//
//  ProfileHeaderView.swift
//  Netology VK
//
//  Created by Ильнур Закиров on 13.11.2022.
//

import UIKit

class ProfileHeaderView: UIView {
    
    private let topView = ProfileViewTopView()
    private let lowView = ProfileHeaderLowView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .white
        [topView, lowView].forEach(addSubview(_:))
        topView.anchor(top: topAnchor,
                       leading: leadingAnchor,
                       bottom: nil,
                       trailing: trailingAnchor)
        lowView.anchor(top: topView.bottomAnchor,
                       leading: leadingAnchor,
                       bottom: bottomAnchor,
                       trailing: trailingAnchor)
    }
    
    func setupValues(from profile: Profile) {
        topView.setupValues(from: profile)
        lowView.setupViews(from: profile)
    }
}
