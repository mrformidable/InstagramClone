//
//  UserProfileHeaderCell.swift
//  InstaClone
//
//  Created by Michael A on 2017-08-24.
//  Copyright © 2017 AI Labs. All rights reserved.
//

import UIKit
import Firebase

enum FollowingState:String {
    
    case following = "Follow"
    case unfollowing = "Unfollow"
    case loading = "Loading"
}

class UserProfileHeaderCell: UICollectionViewCell {
    
    var user:User? {
        
        didSet {
            loadUserProfileImage()
            userNameLabel.text = user?.username
            checkForFollowingStatus()
        }
    }
    
    fileprivate func checkForFollowingStatus() {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else {return}
        guard let userId = user?.userID else { return }

        if currentLoggedInUserId != userId {
           
            if editProfileOrFollowButton.titleLabel?.text == FollowingState.loading.rawValue {
                self.changeToFollowButton()

            }
            let databaseRef = firebaseDatabaseReference.child("following").child(currentLoggedInUserId).child(userId)
            databaseRef.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let snapshotDictionary = snapshot.value as? [String:Any] else { return }
            
                DispatchQueue.main.async {
                    snapshotDictionary.forEach({ (key,value) in
                        let isFollowing = value as? Int
                        if isFollowing == 1 {
                            self.changeToUnFollowButton()
                        }
                    })
                }
 
            }, withCancel: { (error) in
                print(error.localizedDescription)
            })
        } else  {
            // Change button to edit profile, and configure
            print("current user...")
            editProfileOrFollowButton.setTitle("Edit Profile", for: .normal)
        }
    }
    
    
    weak var userProfileDelegate: UserProfileControllerDelegate?
    
    lazy var userProfileImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 40
        iv.layer.masksToBounds = true
        return iv
    }()
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    lazy var postLabel:UILabel = {
        let label = UILabel()
        let attributes = [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14)]
        let attributedText = NSMutableAttributedString(string: "1\n", attributes: attributes)
        let postAttributes = [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.lightGray]
        attributedText.append(NSAttributedString.init(string: "posts", attributes: postAttributes))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    lazy var followersLabel:UILabel = {
        let label = UILabel()
        let attributes = [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14)]
        let attributedText = NSMutableAttributedString(string: "1\n", attributes: attributes)
        let postAttributes = [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.lightGray]
        attributedText.append(NSAttributedString.init(string: "followers", attributes: postAttributes))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    lazy var followingLabel:UILabel = {
        let label = UILabel()
        let attributes = [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14)]
        let attributedText = NSMutableAttributedString(string: "1\n", attributes: attributes)
        let postAttributes = [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.lightGray]
        attributedText.append(NSAttributedString.init(string: "following", attributes: postAttributes))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    lazy var editProfileOrFollowButton: UIButton = {
        let button = UIButton()
        button.setTitle("Loading", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        button.addTarget(self, action: #selector(editProfileOrFollowButtonTapped(_ :)), for: .touchUpInside)
        return button
    }()
    lazy var gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        button.layer.borderColor = UIColor.init(white: 0, alpha: 0.2).cgColor
        button.layer.cornerRadius = 3
        return button
    }()
    lazy var listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor.lightGray
        button.layer.borderColor = UIColor.init(white: 0, alpha: 0.2).cgColor
        button.layer.cornerRadius = 3
        return button
    }()
    lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor.lightGray
        button.layer.borderColor = UIColor.init(white: 0, alpha: 0.2).cgColor
        button.layer.cornerRadius = 3
        return button
    }()
    
    private let headerSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    private let collectionViewSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    @objc private func editProfileOrFollowButtonTapped(_ sender:UIButton) {
       
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else {return}
        guard let userId = user?.userID else { return }
        
        if editProfileOrFollowButton.titleLabel?.text == FollowingState.unfollowing.rawValue {
            let databaseRef = firebaseDatabaseReference.child("following").child(currentLoggedInUserId).child(userId)
            databaseRef.removeValue(completionBlock: { (error, ref) in
                if error != nil {
                    print(error!.localizedDescription); return
                }
                self.changeToFollowButton()

            })
            
        } else if editProfileOrFollowButton.titleLabel?.text == FollowingState.following.rawValue {
            
            let values = [userId:1]
            let databaseRef = firebaseDatabaseReference.child("following").child(currentLoggedInUserId).child(userId)
            databaseRef.updateChildValues(values) { (error, databaseRef) in
                self.changeToUnFollowButton()
            }
        }
   
    }
  
    fileprivate func changeToFollowButton() {
        editProfileOrFollowButton.setTitle(FollowingState.following.rawValue, for: .normal)
        editProfileOrFollowButton.setTitleColor(.white, for: .normal)
        editProfileOrFollowButton.backgroundColor =  UIColor.rgb(red: 17, green: 154, blue: 237)
        editProfileOrFollowButton.layer.borderColor = UIColor(white: 1, alpha: 0.2).cgColor
    }
    fileprivate func changeToUnFollowButton() {
        
        editProfileOrFollowButton.setTitle(FollowingState.unfollowing.rawValue, for: .normal)
        editProfileOrFollowButton.setTitleColor(.black, for: .normal)
        editProfileOrFollowButton.backgroundColor =  UIColor.white
        editProfileOrFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    fileprivate func setupViews() {
        addSubview(userProfileImageView)
        userProfileImageView.anchorConstraints(topAnchor: topAnchor, topConstant: 12, leftAnchor: leftAnchor, leftConstant: 12, rightAnchor: nil, rightConstant: 0, bottomAnchor: nil, bottomConstant: 0, heightConstant: 80, widthConstant: 80)
        setupUserSegmentBarView()
        
        addSubview(userNameLabel)
        userNameLabel.anchorConstraints(topAnchor: userProfileImageView.bottomAnchor, topConstant: 4, leftAnchor: userProfileImageView.leftAnchor, leftConstant: 0, rightAnchor: rightAnchor, rightConstant: 12, bottomAnchor: gridButton.topAnchor, bottomConstant: 0, heightConstant: 0, widthConstant: 0)
        setupUserStatsView()
        
    }
    
    fileprivate func setupUserStatsView() {
        let stackView = UIStackView(arrangedSubviews: [postLabel, followersLabel, followingLabel])
        stackView.distribution = .fillEqually
        addSubview(stackView)
        addSubview(editProfileOrFollowButton)
        
        stackView.anchorConstraints(topAnchor: topAnchor, topConstant: 12, leftAnchor: userProfileImageView.rightAnchor, leftConstant: 12, rightAnchor: rightAnchor, rightConstant: -12, bottomAnchor: nil, bottomConstant: 0, heightConstant: 50, widthConstant: 0)
        
        editProfileOrFollowButton.anchorConstraints(topAnchor: postLabel.bottomAnchor, topConstant: 4, leftAnchor: postLabel.leftAnchor, leftConstant: 12, rightAnchor: followingLabel.rightAnchor, rightConstant: -12, bottomAnchor: nil, bottomConstant: 0, heightConstant: 34, widthConstant: 0)
    }
    
    fileprivate func setupUserSegmentBarView() {
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.anchorConstraints(topAnchor: nil, topConstant: 0, leftAnchor: leftAnchor, leftConstant: 0, rightAnchor: rightAnchor, rightConstant: 0, bottomAnchor: bottomAnchor, bottomConstant: 0, heightConstant: 50, widthConstant: 0)
        addSubview(headerSeparatorView)
        addSubview(collectionViewSeparatorView)
        headerSeparatorView.anchorConstraints(topAnchor: nil, topConstant: 0, leftAnchor: leftAnchor, leftConstant: 0, rightAnchor: rightAnchor, rightConstant: 0, bottomAnchor: stackView.topAnchor, bottomConstant: 0, heightConstant: 0.5, widthConstant: 0)
        collectionViewSeparatorView.anchorConstraints(topAnchor: nil, topConstant: 0, leftAnchor: leftAnchor, leftConstant: 0, rightAnchor: rightAnchor, rightConstant: 0, bottomAnchor: stackView.bottomAnchor, bottomConstant: 0, heightConstant: 0.5, widthConstant: 0)
    }
    
    fileprivate func loadUserProfileImage() {
        
        guard let urlString = user?.userProfileImage else {return}
        guard let userProfileUrl = URL(string: urlString) else { print("cant set user profile image");return }
        userProfileImageView.sd_setImage(with: userProfileUrl, completed: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
