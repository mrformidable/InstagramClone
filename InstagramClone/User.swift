//
//  User.swift
//  InstaClone
//
//  Created by Michael A on 2017-08-24.
//  Copyright © 2017 AI Labs. All rights reserved.
//

import Foundation

struct User {
    
    let userID:String
    let username:String
    let userProfileImage:String
    
    init(userID:String, dictionary:[String:Any]) {
        self.userID = userID
        self.username = dictionary["username"] as? String ?? ""
        self.userProfileImage = dictionary["profileImageUrl"] as? String ?? ""
    }
}

