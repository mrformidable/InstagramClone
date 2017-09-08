//
//  HomeFeedCollectionViewCell.swift
//  InstaClone
//
//  Created by Michael A on 2017-08-28.
//  Copyright © 2017 AI Labs. All rights reserved.
//

import UIKit
import AVFoundation
class HomeFeedCollectionViewCell: UICollectionViewCell {
    
  
   
    var post: Post? {
        
        didSet {
            guard let postImageUrlString = post?.postImageUrl, let profileImageUrlString = post?.user.userProfileImage, let username = post?.user.username else {return}
            guard let postUrl = URL(string: postImageUrlString), let profileImageUrl = URL(string: profileImageUrlString) else {return}
            postImageView.sd_setImage(with: postUrl, completed: nil)
            userProfileImageView.sd_setImage(with: profileImageUrl, completed: nil)
            usernameLabel.text = username
            setupAttributedCaption()
    }
 }
    lazy var postImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    lazy var userProfileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 20
        return iv
    }()
    lazy var usernameLabel:UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    lazy var optionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "heart").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon_long").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    lazy var captionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(postImageView)
        addSubview(userProfileImageView)
        addSubview(usernameLabel)
        addSubview(optionButton)
        setupActionButtons()
        addSubview(bookmarkButton)

        userProfileImageView.anchorConstraints(topAnchor: topAnchor, topConstant: 8, leftAnchor: leftAnchor, leftConstant: 8, rightAnchor: nil, rightConstant: 0, bottomAnchor: nil, bottomConstant: 0, heightConstant: 40, widthConstant: 40)
        usernameLabel.anchorConstraints(topAnchor: topAnchor, topConstant: 5, leftAnchor: userProfileImageView.rightAnchor, leftConstant: 8, rightAnchor: optionButton.leftAnchor, rightConstant: 0, bottomAnchor: postImageView.topAnchor, bottomConstant: 0, heightConstant: 0, widthConstant: 0)
        
        optionButton.anchorConstraints(topAnchor: topAnchor, topConstant: 0, leftAnchor: nil, leftConstant: 0, rightAnchor: rightAnchor, rightConstant: 0, bottomAnchor: postImageView.topAnchor, bottomConstant: 0, heightConstant: 0, widthConstant: 44)
        
        postImageView.anchorConstraints(topAnchor: userProfileImageView.bottomAnchor, topConstant: 8, leftAnchor: leftAnchor, leftConstant: 0, rightAnchor: rightAnchor, rightConstant: 0, bottomAnchor: nil, bottomConstant: 0, heightConstant: 0, widthConstant: 0)
        postImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0).isActive = true

        bookmarkButton.anchorConstraints(topAnchor: postImageView.bottomAnchor, topConstant: 10, leftAnchor: nil, leftConstant: 0, rightAnchor: rightAnchor, rightConstant: 0, bottomAnchor: nil, bottomConstant: 0, heightConstant: 30, widthConstant: 44)
       
        addSubview(captionLabel)
        captionLabel.anchorConstraints(topAnchor: likeButton.bottomAnchor, topConstant: 0, leftAnchor: leftAnchor, leftConstant: 8, rightAnchor: rightAnchor, rightConstant: -8, bottomAnchor: bottomAnchor, bottomConstant: 0, heightConstant: 0, widthConstant: 0)
        
    }

    fileprivate func setupAttributedCaption() {
        guard let post = self.post else {  return }
     
        let attributedText = NSMutableAttributedString(string: post.user.username, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: " \(post.captionText)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]))
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 4)]))
        let timeDisplay = post.creationDate.timeAgoDisplay()
        attributedText.append(NSAttributedString(string: timeDisplay, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.gray]))
        captionLabel.attributedText = attributedText
    }

    
    fileprivate func setupActionButtons() {
        addSubview(likeButton)
        addSubview(commentButton)
        addSubview(sendButton)
        
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, sendButton])
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .red
        addSubview(stackView)
        stackView.anchorConstraints(topAnchor: postImageView.bottomAnchor, topConstant: 0, leftAnchor: leftAnchor, leftConstant: 8, rightAnchor: nil, rightConstant: 0, bottomAnchor: nil, bottomConstant: 0, heightConstant: 50, widthConstant: 120)
    }
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}























