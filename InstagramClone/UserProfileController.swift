//
//  UserProfileController.swift
//  InstaClone
//
//  Created by Michael A on 2017-08-24.
//  Copyright © 2017 AI Labs. All rights reserved.
//

import UIKit
import Firebase

protocol UserProfileControllerDelegate: class  {
    func presentEditProfileViewController()
}

class UserProfileController: UICollectionViewController {
    
    fileprivate let headerCellIdentifier = "headerCellId"
    fileprivate let profileCellIdentifier = "profilePhotosCellId"
    var user:User?
    var posts = [Post]()
    var userId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        collectionView?.register(UserProfileHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerCellIdentifier)
        collectionView?.register(UserProfilePhotosCollectionViewCell.self, forCellWithReuseIdentifier: profileCellIdentifier)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogoutBarButton))
        fetchUser()
    }

 
    @objc fileprivate func handleLogoutBarButton() {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "Log Out", style: .default) { (action) in
            do {
                try Auth.auth().signOut()
                
            } catch let error {
                print(error.localizedDescription)
                return
            }
            let loginVC = LoginViewController()
            self.present(loginVC, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(logoutAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCellIdentifier, for: indexPath) as! UserProfileHeaderCell
        headerView.userProfileDelegate = self
        headerView.user = self.user
        return headerView
    }
    
    fileprivate func fetchUser() {
        let userId = self.userId ?? Auth.auth().currentUser?.uid ?? ""
        Database.fetchUsers(withUserId: userId) { (user) in
            self.user = user
            self.collectionView?.reloadData()
            self.navigationItem.title = self.user?.username
            self.fetchOrderedPosts()
        }
    }
    
    fileprivate func fetchOrderedPosts() {
        let userID = self.userId ?? Auth.auth().currentUser?.uid ?? ""
        firebaseDatabaseReference.child("posts").child(userID).queryOrdered(byChild: "createdAt").observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let user = self.user else { return }
            let post = Post(user: user, dictionary: dictionary)
            self.posts.insert(post, at: 0)
            
            self.collectionView?.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
   
}


// MARK:- CollectionViewDataSource
extension UserProfileController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: profileCellIdentifier, for: indexPath) as! UserProfilePhotosCollectionViewCell
        let post = posts[indexPath.item]
        cell.post = post
        return cell
    }
    
}

extension UserProfileController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width , height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
}

extension UserProfileController: UserProfileControllerDelegate {
    
    func presentEditProfileViewController() {
        let navController = UINavigationController(rootViewController: EditUserProfileTableViewController())
        present(navController, animated: true, completion: nil)
    }
    
}










