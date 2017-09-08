//
//  PhotoSelectorCollectionViewController.swift
//  InstaClone
//
//  Created by Michael A on 2017-08-26.
//  Copyright © 2017 AI Labs. All rights reserved.
//

import UIKit
import Photos

private let photoCelIdentifier = "photoSelectorCell"
private let headerCellIdentifier = "photoSelectorHeaderCell"


class PhotoSelectorCollectionViewController: UICollectionViewController {
    
    var images = [UIImage]()
    fileprivate var selectedPhotoImage:UIImage?
    fileprivate var assets = [PHAsset]()
    fileprivate var headerViewRef:PhotoSelectorHeaderCollectionViewCell?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        // Register cell classes
        collectionView!.register(PhotosSelectorCollectionViewCell.self, forCellWithReuseIdentifier: photoCelIdentifier)
        collectionView!.register(PhotoSelectorHeaderCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerCellIdentifier)
        setupNavigationItems()
        fetchMediaAssets()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    fileprivate func setupNavigationItems() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelBarButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextBarButtonTapped))
    }
    
    @objc fileprivate func cancelBarButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func nextBarButtonTapped() {
     
        let sharePostController = SharePhotoViewController()
        sharePostController.choosenPhoto = headerViewRef?.photoImageView.image
        navigationController?.pushViewController(sharePostController, animated: true)
    }
    
    fileprivate func fetchOptions() -> PHFetchOptions {
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 35
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        return fetchOptions
    }
    
    fileprivate func fetchMediaAssets() {
        DispatchQueue.global(qos: .background).async { [unowned self] in
            let allPhotos = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: self.fetchOptions())
            let imageManager = PHImageManager()
            let targetSize = CGSize(width: 300, height: 300)
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            allPhotos.enumerateObjects({ (asset, count, stop) in
            
            imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: PHImageContentMode.aspectFit, options: options, resultHandler: { (image, info)  in
                    guard let _image = image else {return}
                    self.images.append(_image)
                    self.assets.append(asset)
                
                    if self.selectedPhotoImage == nil {
                    self.selectedPhotoImage = _image
                  }
                    if count == allPhotos.count - 1 {
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                        }
                    }
                })
            })
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCelIdentifier, for: indexPath) as! PhotosSelectorCollectionViewCell
            cell.photoImageView.image = images[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(1, 0, 0, 0)
    }
}
// MARK: - PhotoSelectorCollectionViewController Delegate Implimentation
extension PhotoSelectorCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        self.selectedPhotoImage = images[indexPath.item]
        self.collectionView?.reloadData()
        
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        collectionView.reloadData()
      
    }
    
}

extension PhotoSelectorCollectionViewController:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3) / 4
        return CGSize(width: width, height: width)
    }
}

// MARK: - HeaderCell Configuration Implimentation
extension PhotoSelectorCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCellIdentifier, for: indexPath) as! PhotoSelectorHeaderCollectionViewCell
        self.headerViewRef = headerView

        if let photo = selectedPhotoImage {

        if let index = images.index(of: photo) {
                let selectedAsset = assets[index]
                let targetSize = CGSize(width: selectedAsset.pixelWidth, height: selectedAsset.pixelHeight)
                let imageManager = PHImageManager()

                imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: PHImageContentMode.default, options: nil, resultHandler: { (image, info) in
                    if let image = image {
                        headerView.photoImageView.image = image
                    }
                })
            }
        }
        return headerView
   }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
}



