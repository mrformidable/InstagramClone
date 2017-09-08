//
//  MainTabBarController.swift
//  InstaClone
//
//  Created by Michael A on 2017-08-24.
//  Copyright © 2017 AI Labs. All rights reserved.
//

import UIKit

class MainTabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        let flowLayout = UICollectionViewFlowLayout()
        let userprofileViewController = UserProfileController(collectionViewLayout: flowLayout)
        let userProfileNavController = createNavigationController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"), rootViewController: userprofileViewController)
        let homefeedController = HomeFeedCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let homeNavController = createNavigationController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: homefeedController)

        let searchCVC = SearchViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let searchNavController = createNavigationController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: searchCVC)
       
        let addPhotoNavController = createNavigationController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"))
        let likeNavController = createNavigationController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"))
        
        tabBar.tintColor = .black
        
        viewControllers = [homeNavController,
                           searchNavController,
                           addPhotoNavController,
                           likeNavController,
                           userProfileNavController
        ]
        
        guard let tabItems = tabBar.items else {return}
        for item in tabItems {
            item.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0)
        }
    }
    
    fileprivate func createNavigationController(unselectedImage: UIImage, selectedImage:UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        
        let viewController = rootViewController
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.image = unselectedImage
        navigationController.tabBarItem.selectedImage = selectedImage
        
        return navigationController
    }
}

extension MainTabController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let index = viewControllers?.index(of: viewController)
        
        if index == 2 {
            
            let flowLayout = UICollectionViewFlowLayout()
            let photoSelectorController = PhotoSelectorCollectionViewController(collectionViewLayout: flowLayout)
            let navigationController = UINavigationController(rootViewController: photoSelectorController)
            self.present(navigationController, animated: true, completion: nil)
            
            return false
        }
        return true
    }
}





























