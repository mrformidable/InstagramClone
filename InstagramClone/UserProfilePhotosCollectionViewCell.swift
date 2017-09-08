//
//  UserProfilePhotosCollectionViewCell.swift
//  InstaClone
//
//  Created by Michael A on 2017-08-27.
//  Copyright © 2017 AI Labs. All rights reserved.
//

import UIKit
import SDWebImage

class UserProfilePhotosCollectionViewCell: UICollectionViewCell {
    
    var post:Post? {
        
        didSet {
            guard let postImageUrl = post?.postImageUrl else {return}
            guard let url = URL(string: postImageUrl) else { return }
            photoImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    lazy var photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews(){
      
        addSubview(photoImageView)
        photoImageView.anchorConstraints(topAnchor: topAnchor, topConstant: 0, leftAnchor: leftAnchor, leftConstant: 0, rightAnchor: rightAnchor, rightConstant: 0, bottomAnchor: bottomAnchor, bottomConstant: 0, heightConstant: 0, widthConstant: 0)
     
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


