//
//  SearchCollectionViewCell.swift
//  InstaClone
//
//  Created by Michael A on 2017-09-04.
//  Copyright © 2017 AI Labs. All rights reserved.
//

import UIKit
import SDWebImage

class SearchCollectionViewCell: UICollectionViewCell {
    
    var user: User? {
        didSet {
            guard let username = user?.username, let userProfileImageUrl = user?.userProfileImage else {
                return
            }
            userNameLabel.text = username
            guard let url = URL(string: userProfileImageUrl) else { return }
            profileImageView.sd_setImage(with: url, completed: nil)
        }
    }
    lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .blue
        iv.layer.cornerRadius = 25
        iv.layer.masksToBounds = true
        return iv
    }()
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
  override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    fileprivate func setupViews() {
        addSubview(profileImageView)
        addSubview(userNameLabel)
        addSubview(separatorView)
        profileImageView.anchorConstraints(topAnchor: nil, topConstant: 0, leftAnchor: leftAnchor, leftConstant: 8, rightAnchor: nil, rightConstant: 0, bottomAnchor: nil, bottomConstant: 0, heightConstant: 50, widthConstant: 50)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        userNameLabel.anchorConstraints(topAnchor: topAnchor, topConstant: 0, leftAnchor: profileImageView.rightAnchor, leftConstant: 8, rightAnchor: rightAnchor, rightConstant: 0, bottomAnchor: bottomAnchor, bottomConstant: 0, heightConstant: 0, widthConstant: 0)
        separatorView.anchorConstraints(topAnchor: nil, topConstant: 0, leftAnchor: userNameLabel.leftAnchor, leftConstant: 0, rightAnchor: rightAnchor, rightConstant: 0, bottomAnchor: bottomAnchor, bottomConstant: 0, heightConstant: 0.5, widthConstant: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
