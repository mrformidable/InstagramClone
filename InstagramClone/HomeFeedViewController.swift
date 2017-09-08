//
//  HomeFeedViewController.swift
//  InstaClone
//
//  Created by Michael A on 2017-08-28.
//  Copyright © 2017 AI Labs. All rights reserved.
//

import UIKit
import Firebase



class HomeFeedCollectionViewController: UICollectionViewController {
    
    fileprivate let homeFeedCellIdentifier = "homefeedCell"
    fileprivate let storiesCellIdentifier = "homeHeaderCell"
    var posts = [Post]()
    var username:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        collectionView?.register(HomeFeedCollectionViewCell.self, forCellWithReuseIdentifier: homeFeedCellIdentifier)
        collectionView?.register(StoryHeaderCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: storiesCellIdentifier)
        setupNavigationItems()
        //fetchUserPosts()
        fetchFollowersPosts()
    }
    
    fileprivate func setupNavigationItems() {
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "Logo"))
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camera"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(cameraNavBarButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "send"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(instaDirectNavBarButtonTapped))
    }
    
    @objc fileprivate func instaDirectNavBarButtonTapped() {
        print("insta dm button tapped")
    }
    
    @objc fileprivate func cameraNavBarButtonTapped() {
        print("camera button tapped")
    }
    
    fileprivate func fetchFollowersPosts() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        firebaseDatabaseReference.child("following").child(currentUserId).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshotDictionary = snapshot.value as? [String:Any] else {
                return
            }
            snapshotDictionary.forEach({ (key, value) in
                Database.fetchUsers(withUserId: key, completion: { (user) in
                    self.fetchPosts(for: user)
                })
            })
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    fileprivate func fetchUserPosts() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        Database.fetchUsers(withUserId: userId) { (user) in
            self.fetchPosts(for: user)
            self.username = user.username
        }
    }
    fileprivate func fetchPosts(for user:User) {
        firebaseDatabaseReference.child("posts").child(user.userID).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapShotDictionaries = snapshot.value as? [String:Any] else { return }
            snapShotDictionaries.forEach({  (key, value) in
                guard let dictionary = value as? [String:Any] else { return }
                    let post = Post(user: user, dictionary: dictionary)
                    self.posts.append(post)
            })
            self.posts.sort(by: { return $0.creationDate > $1.creationDate})
            self.collectionView?.reloadData()
        })
    }
}

extension HomeFeedCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homeFeedCellIdentifier, for: indexPath) as! HomeFeedCollectionViewCell
        let post = posts[indexPath.item]
        cell.post = post
        return cell
    }
}
extension HomeFeedCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height = view.frame.width
        height += 8 + 40 + 8
        height += 50
        height += 60
        
        return CGSize(width: view.frame.width, height: height)
    }
}
// Impliment Stories Here
extension HomeFeedCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let storiesHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: storiesCellIdentifier, for: indexPath) as! StoryHeaderCollectionViewCell
        return storiesHeaderView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
}










