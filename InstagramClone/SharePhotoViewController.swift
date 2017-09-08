//
//  SharePhotoViewController.swift
//  InstaClone
//
//  Created by Michael A on 2017-08-27.
//  Copyright © 2017 AI Labs. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SharePhotoViewController: UIViewController {
    
    var choosenPhoto:UIImage?
    var videoUrl:String?
    let shareCaptionTextView = UITextView()
    let rightNavigationBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(shareBarButtonTapped))
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 245, green: 245, blue: 245)
        setupContainerViews()
        navigationController?.navigationBar.tintColor = .black
       
        navigationItem.rightBarButtonItem = rightNavigationBarButtonItem
    }
    
    @objc fileprivate func shareBarButtonTapped() {
        navigationItem.rightBarButtonItem?.isEnabled = false
            savePhotoPost()
  }
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    fileprivate func savePhotoPost() {
    guard let userId = Auth.auth().currentUser?.uid else {print("Can't get user id"); return}
    guard let image = choosenPhoto else {return}
    guard let photoCaption = shareCaptionTextView.text, photoCaption.characters.count > 0  else {return}
    FirebaseService.savePhotoPost(userId: userId, imageToSave: image, photoCaptionText: photoCaption)
    self.dismiss(animated: true, completion: nil)

 }
    
    fileprivate func setupContainerViews() {
        
        let containerView = UIView()
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        containerView.anchorConstraints(topAnchor: topLayoutGuide.bottomAnchor, topConstant: 0, leftAnchor: view.leftAnchor, leftConstant: 0, rightAnchor: view.rightAnchor, rightConstant: 0, bottomAnchor: nil, bottomConstant: 0, heightConstant: 100, widthConstant: 0)
        
        let sharePhotoImageView = UIImageView()
        sharePhotoImageView.contentMode = .scaleAspectFill
        sharePhotoImageView.clipsToBounds = true
        if let image = choosenPhoto {
            sharePhotoImageView.image = image
        }
        view.addSubview(sharePhotoImageView)
        sharePhotoImageView.anchorConstraints(topAnchor: containerView.topAnchor, topConstant: 8, leftAnchor: containerView.leftAnchor, leftConstant: 8, rightAnchor: nil, rightConstant: 0, bottomAnchor: containerView.bottomAnchor, bottomConstant: -8, heightConstant: 0, widthConstant: 84)
        
        view.addSubview(shareCaptionTextView)
        shareCaptionTextView.anchorConstraints(topAnchor: sharePhotoImageView.topAnchor, topConstant: 0, leftAnchor: sharePhotoImageView.rightAnchor, leftConstant: 0, rightAnchor: containerView.rightAnchor, rightConstant: 0, bottomAnchor: containerView.bottomAnchor, bottomConstant: -2, heightConstant: 0, widthConstant: 0)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
