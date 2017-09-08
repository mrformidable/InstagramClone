//
//  Post.swift
//  InstaClone
//
//  Created by Michael A on 2017-08-28.
//  Copyright © 2017 AI Labs. All rights reserved.
//

import Foundation


struct Post {
    
    let postImageUrl:String
    let captionText:String
    let creationDate:Date
    let user:User
    
    init(user: User, dictionary:[String:Any]) {
        self.postImageUrl = dictionary["postImageUrl"] as? String ?? ""
        self.captionText = dictionary["captionText"] as? String ?? ""
        self.user = user
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
        
    }
}



