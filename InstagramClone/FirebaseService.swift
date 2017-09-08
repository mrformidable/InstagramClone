//
//  FirebaseService.swift
//  InstaClone
//
//  Created by Michael A on 2017-08-24.
//  Copyright © 2017 AI Labs. All rights reserved.
//

import Foundation
import Firebase
import SVProgressHUD

public var firebaseStorageReference = Storage.storage().reference()
public var firebaseDatabaseReference = Database.database().reference()

extension Database {
    
    static func fetchUsers(withUserId userID:String, completion: @escaping (User)-> ()) {
        
        firebaseDatabaseReference.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshotDictionary = snapshot.value as? [String:Any] else { return }
            let user = User(userID: userID, dictionary: snapshotDictionary)
            completion(user)
            
        }) { (error) in
            print(error.localizedDescription)
            return
        }
    }
}

struct FirebaseService {
    
    static func savePhotoPost(userId:String?, imageToSave:UIImage?, photoCaptionText:String?) {
        guard let userId = userId else {  return  }
        guard let imageToSave = imageToSave else { return}
        guard let jpegImageData = UIImageJPEGRepresentation(imageToSave, 0.85) else {print("can't convert image");return}
        guard let photoCaption = photoCaptionText, photoCaption.characters.count > 0 else {
            return
        }
        let uniquePostsStoragePath = NSUUID().uuidString
        firebaseStorageReference.child("Posts").child(uniquePostsStoragePath).putData(jpegImageData, metadata: nil) {(metadata, error) in
            if error != nil { print(error!.localizedDescription)
            }
            guard let postImageUrl = metadata?.downloadURL()?.absoluteString else { return }
            let imageHeight = imageToSave.size.height
            let imageWidth = imageToSave.size.width
            let creationDate = Date().timeIntervalSince1970
            let values:[String:Any] = ["postImageUrl":postImageUrl,
                                       "captionText": photoCaption,
                                       "imageHeight":imageHeight,
                                       "imageWidth":imageWidth,
                                       "creationDate":creationDate
            ]
            firebaseDatabaseReference.child("posts").child(userId).childByAutoId().updateChildValues(values) { (error, reference) in
                if error != nil {
                    print(error!.localizedDescription);
                    return
                }
                print("saved to database")

            }
        }
    }
}
    
//    static func saveVideoPost(userId:String?, imageToSave:UIImage?, photoCaptionText:String?, videoUrl:String?) {
//        guard let userId = userId else { return }
//        guard let imageToSave = imageToSave else { return }
//        guard let jpegImageData = UIImageJPEGRepresentation(imageToSave, 0.85) else { print("can't convert image");return}
//        guard let photoCaption = photoCaptionText, photoCaption.characters.count > 0 else {
//            return
//        }
//        let uniquePostsStoragePath = NSUUID().uuidString
//        firebaseStorageReference.child("Posts").child(uniquePostsStoragePath).putData(jpegImageData, metadata: nil) {(metadata, error) in
//            if error != nil { print(error!.localizedDescription)
//                return
//            }
//            guard let videoUrl = videoUrl else { return }
//            guard let url = URL(string:videoUrl) else { return }
//            let uniqueVideosStoragePath = NSUUID().uuidString
//            guard let postImageUrl = metadata?.downloadURL()?.absoluteString else { return }
//            let uploadTask = firebaseStorageReference.child("Videos").child(uniqueVideosStoragePath).putFile(from: url, metadata: nil) { (metadata, error) in
//                if error != nil { print(error!.localizedDescription) }
//                guard let videoUrl = metadata?.downloadURL()?.absoluteString  else {  return  }
//                
//                let imageHeight = imageToSave.size.height
//                let imageWidth = imageToSave.size.width
//                let creationDate = Date().timeIntervalSinceNow
//                let values:[String:Any] = ["postImageUrl":postImageUrl,
//                                           "captionText": photoCaption,
//                                           "imageHeight":imageHeight,
//                                           "imageWidth":imageWidth,
//                                           "createdAt":creationDate,
//                                           "video":["videoUrl":videoUrl]
//                ]
//            firebaseDatabaseReference.child("posts").child(userId).childByAutoId().updateChildValues(values) { (error, reference) in
//                    if error != nil {
//                        print(error!.localizedDescription);
//                        return
//                    }
//                    print("saved to database")
//                }
//            }
//            uploadTask.observe(.progress, handler: { (snapshot) in
//                print(snapshot.progress ?? "no progress")
//                if let progress = snapshot.progress {
//                    let update = Float(progress.fractionCompleted)
//                    let percentageCompleted = update * 100
//                    SVProgressHUD.showProgress(update, status: "\(percentageCompleted)%")
//                    if update == 1.0 {
//                        SVProgressHUD.dismiss()
//                    }
//                }
//            })
//            uploadTask.removeAllObservers()
//        }
//    }
/*
 fileprivate func fetchVideos() {
 let fetchOptions = PHFetchOptions()
 //fetchOptions.fetchLimit = 35
 let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
 fetchOptions.sortDescriptors = [sortDescriptor]
 
 let imageManager = PHImageManager()
 let targetSize = CGSize(width: 300, height: 300)
 let imageRequestOptions = PHImageRequestOptions()
 imageRequestOptions.isSynchronous = true
 imageRequestOptions.deliveryMode = .fastFormat
 
 
 DispatchQueue.global(qos: .background).async { [unowned self] in
 let allVideo = PHAsset.fetchAssets(with: .video, options: self.fetchOptions())
 allVideo.enumerateObjects({ (asset, count, stop) in
 
 imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: PHImageContentMode.aspectFit, options: imageRequestOptions, resultHandler: {  (image, info) in
 guard let image = image else { return }
 self.assets.append(asset)
 
 // FetchVideo
 let videoRequestOptions = PHVideoRequestOptions()
 
 imageManager.requestAVAsset(forVideo: asset, options: videoRequestOptions, resultHandler: { (avAsset, audioMix, info) in
 guard let asset = avAsset as? AVURLAsset else {
 return
 }
 let urlString = String(describing: asset.url)
 let mediaAsset = MediaAsset(image: image, url: urlString)
 self.mediaAssets.append(mediaAsset)
 DispatchQueue.main.async {
 self.collectionView?.reloadData()
 }
 })
 
 })
 })
 }
 }
 

 */




