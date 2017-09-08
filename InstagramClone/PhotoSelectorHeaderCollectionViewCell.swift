//
//  PhotoSelectorHeaderCollectionViewCell.swift
//  InstaClone
//
//  Created by Michael A on 2017-08-26.
//  Copyright © 2017 AI Labs. All rights reserved.
//

import UIKit


class PhotoSelectorHeaderCollectionViewCell: UICollectionViewCell {
    
    lazy var photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(photoImageView)
        photoImageView.anchorConstraints(topAnchor: topAnchor, topConstant: 0, leftAnchor: leftAnchor, leftConstant: 0, rightAnchor: rightAnchor, rightConstant: 0, bottomAnchor: bottomAnchor, bottomConstant: 0, heightConstant: 0, widthConstant: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
