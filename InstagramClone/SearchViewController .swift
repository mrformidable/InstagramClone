//
//  SearchViewController .swift
//  InstaClone
//
//  Created by Michael A on 2017-09-01.
//  Copyright © 2017 AI Labs. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SearchViewController: UICollectionViewController {
    
    fileprivate let cellIdentifier = "searchCell"
    var users = [User]()
    var filteredUsers = [User]()
    
    lazy var searchBar:UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Enter Username"
        bar.tintColor = .gray
        bar.delegate = self
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 235, green: 235, blue: 235)
        bar.showsCancelButton = false
        return bar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.addSubview(searchBar)
        let navBar =  navigationController?.navigationBar
        searchBar.anchorConstraints(topAnchor: navBar?.topAnchor, topConstant: 0, leftAnchor: navBar?.leftAnchor, leftConstant: 8, rightAnchor: navBar?.rightAnchor, rightConstant: -8, bottomAnchor: navBar?.bottomAnchor, bottomConstant: 0, heightConstant: 0, widthConstant: 0)
        fetchUsers()
        collectionView?.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        searchBar.isHidden = false
    }
    
    fileprivate func fetchUsers() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        firebaseDatabaseReference.child("users").observeSingleEvent(of: .value, with: { [unowned self](snapshot) in
            guard let snapshotDictionary = snapshot.value as? [String:Any] else { return  }
            snapshotDictionary.forEach({ (key,value) in
                guard let userDictionary = value as? [String:Any] else { return }
                let user = User(userID: key, dictionary: userDictionary)
                if currentUserId != user.userID {
                    self.users.append(user)
                }
            })
            
            self.users.sort(by: {
            return $0.username.lowercased() < $1.username.lowercased()
            })
            
            self.filteredUsers = self.users
            self.collectionView?.reloadData()
        })
    }
    
}

extension SearchViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SearchCollectionViewCell
        let user = filteredUsers[indexPath.item]
        cell.user = user
        return cell
    }
}

extension SearchViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
        let user = filteredUsers[indexPath.item]
        let userProfileViewController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileViewController.userId = user.userID
        navigationController?.pushViewController(userProfileViewController, animated: true)
    }
}

extension SearchViewController:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 66)
    }
    
}

extension SearchViewController:UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      
        if searchText.isEmpty {
            filteredUsers = users
        } else {
            filteredUsers = self.users.filter({ (user) -> Bool in
                return user.username.lowercased().contains(searchText.lowercased())
            })
        }
        collectionView?.reloadData()
    }
}







