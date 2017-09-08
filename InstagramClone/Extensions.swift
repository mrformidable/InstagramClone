//
//  Extensions.swift
//  InstaClone
//
//  Created by Michael A on 2017-08-23.
//  Copyright © 2017 AI Labs. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
    
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
}

extension UIView {
    
    func anchorConstraints(topAnchor: NSLayoutYAxisAnchor?, topConstant:CGFloat, leftAnchor: NSLayoutXAxisAnchor?,leftConstant:CGFloat ,rightAnchor:NSLayoutXAxisAnchor?, rightConstant: CGFloat,bottomAnchor: NSLayoutYAxisAnchor?, bottomConstant: CGFloat, heightConstant:CGFloat, widthConstant:CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
      
        if let top = topAnchor {
            self.topAnchor.constraint(equalTo: top, constant: topConstant).isActive = true
        }
        
        if let left = leftAnchor {
            self.leftAnchor.constraint(equalTo: left, constant: leftConstant).isActive = true
        }
        
        if let right = rightAnchor {
            self.rightAnchor.constraint(equalTo: right, constant: rightConstant).isActive = true
        }
        if let bottom = bottomAnchor {
            self.bottomAnchor.constraint(equalTo: bottom, constant: bottomConstant).isActive = true
        }
        
        if heightConstant != 0 && heightConstant > 0 {
            self.heightAnchor.constraint(equalToConstant: heightConstant).isActive = true
            
        }
        
        if widthConstant != 0 && widthConstant > 0 {
            self.widthAnchor.constraint(equalToConstant: widthConstant).isActive = true
            
        }
        
    }
    
    func anchorCenterConstraints(centerXAnchor:NSLayoutXAxisAnchor?, xConstant:CGFloat, centerYAnchor:NSLayoutYAxisAnchor?, yConstant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        if let centerX = centerXAnchor {
            
            self.centerXAnchor.constraint(equalTo: centerX, constant: xConstant).isActive = true
        }
        if let centerY = centerYAnchor {
           
            self.centerYAnchor.constraint(equalTo: centerY, constant: yConstant).isActive = true
        }
      
    }
    
}



extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        //let year = month * 12
        
        let quotient: Int
        let unit: String
        if secondsAgo < minute {
            quotient = secondsAgo
            unit = "second"
        } else if secondsAgo < hour {
            quotient = secondsAgo / minute
            unit = "min"
        } else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = "hour"
        } else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "day"
        } else if secondsAgo < month {
            quotient = secondsAgo / week
            unit = "week"
        } else {
            quotient = secondsAgo / month
            unit = "month"
        }
        
        return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
        
    }
}



//        URLSession.shared.dataTask(with: userProfileUrl, completionHandler: { (data, response, error) in
//            if error != nil {  print(error!.localizedDescription); return }
//            guard let safeData = data else { print("Could not download data from database");return  }
//            let downloadedUserProfileImage = UIImage(data: safeData)
//            guard let compressedUserProfileImage = UIImageJPEGRepresentation(downloadedUserProfileImage!, 0.3) else { return  }
//            DispatchQueue.main.async {
//                self.userProfileImageView.image = UIImage(data: compressedUserProfileImage)
//            }
//        }).resume()



