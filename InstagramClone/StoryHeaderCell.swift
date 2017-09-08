//
//  StoryHeaderCell.swift
//  InstaClone
//
//  Created by Michael A on 2017-08-29.
//  Copyright © 2017 AI Labs. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class StoryHeaderCollectionViewCell: UICollectionViewCell {
    
    fileprivate let storyCellIdentifier = "storyHeaderCellID"
    let storyUsernames:[String] = ["kelsy33_","fitfanny","jess.3","lory.parker","nike","studio55fit"]
    let storyImages:[UIImage] = [#imageLiteral(resourceName: "1"), #imageLiteral(resourceName: "3"), #imageLiteral(resourceName: "5"),#imageLiteral(resourceName: "4"), #imageLiteral(resourceName: "6"), #imageLiteral(resourceName: "2")]
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        return cv
    }()
    
    fileprivate let storiesLabel:UILabel = {
        let label = UILabel()
        label.text = "Stories"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    lazy var watchAllStories: UIButton = {
        let button = UIButton(type: .system)
        let attributes = [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 20), NSForegroundColorAttributeName: UIColor.black]
        let attributedTitle = NSMutableAttributedString(string: "►", attributes: attributes)
        let newAttributes = [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.black]
        attributedTitle.append(NSAttributedString.init(string: " Watch All", attributes: newAttributes))
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    
    fileprivate let storyHeaderSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.register(StoryCVCell.self, forCellWithReuseIdentifier: storyCellIdentifier)
        addSubview(collectionView)
        collectionView.anchorConstraints(topAnchor: topAnchor, topConstant: 0, leftAnchor: leftAnchor, leftConstant: 8, rightAnchor: rightAnchor, rightConstant: 0, bottomAnchor: bottomAnchor, bottomConstant: 0, heightConstant: 0, widthConstant: 0)
        addSubview(storyHeaderSeparatorView)
        storyHeaderSeparatorView.anchorConstraints(topAnchor: nil, topConstant: 0, leftAnchor: leftAnchor, leftConstant: 0, rightAnchor: rightAnchor, rightConstant: 0, bottomAnchor: bottomAnchor, bottomConstant: 0, heightConstant: 0.5, widthConstant: 0)
        collectionView.addSubview(storiesLabel)
        storiesLabel.anchorConstraints(topAnchor: collectionView.topAnchor, topConstant: 2, leftAnchor: collectionView.leftAnchor, leftConstant: 0, rightAnchor: nil, rightConstant: 0, bottomAnchor: nil, bottomConstant: 0, heightConstant: 20, widthConstant: 78)
        addSubview(watchAllStories)
        watchAllStories.anchorConstraints(topAnchor: collectionView.topAnchor, topConstant: 2, leftAnchor: nil, leftConstant: 0, rightAnchor: collectionView.rightAnchor, rightConstant: -8, bottomAnchor: nil, bottomConstant: 0, heightConstant: 20, widthConstant: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StoryHeaderCollectionViewCell:UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return storyUsernames.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: storyCellIdentifier, for: indexPath) as! StoryCVCell
            cell.usernameLabel.text = storyUsernames[indexPath.item]
            cell.userStoryImageView.image = storyImages[indexPath.item]
        
        return cell
    }
}


extension StoryHeaderCollectionViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 100)
    }
    
}

class StoryCVCell:UICollectionViewCell {
    
    
    
    lazy var userStoryImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 30
        iv.layer.masksToBounds = true
        iv.layer.borderWidth = 1.5
        iv.layer.borderColor = UIColor.orange.cgColor
        return iv
    }()
    
    fileprivate let usernameLabel:UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 10)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(userStoryImageView)
        addSubview(usernameLabel)
         userStoryImageView.anchorConstraints(topAnchor: nil, topConstant: 0, leftAnchor: leftAnchor, leftConstant: 0, rightAnchor: nil, rightConstant: 0, bottomAnchor: usernameLabel.topAnchor, bottomConstant: -4, heightConstant: 60, widthConstant: 60)
        usernameLabel.anchorConstraints(topAnchor: nil, topConstant: 0, leftAnchor: userStoryImageView.leftAnchor, leftConstant: 0, rightAnchor: userStoryImageView.rightAnchor, rightConstant: 0, bottomAnchor: bottomAnchor, bottomConstant: -2, heightConstant: 0, widthConstant: 0)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




