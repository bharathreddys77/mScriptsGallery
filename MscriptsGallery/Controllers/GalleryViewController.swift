//
//  ViewController.swift
//  MscriptsGallery
//
//  Created by A6049116 on 2/23/20.
//  Copyright © 2020 Mscripts. All rights reserved.
//

import UIKit

class PhotoCell:UICollectionViewCell {
    
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var photoLabel: UILabel!
}

class GalleryViewController: UIViewController {

    @IBOutlet weak var collectionView:UICollectionView!
    fileprivate var ownerPhotos:[Photo] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showProgressBar()
        mScriptsServiceController().retrievePublicPhotos {[unowned self] (photos, error) in
            self.hideProgressBar()
            guard photos?.networkError == nil && error == nil else {
                if photos?.networkError != nil {
                    ViewHelper.showNetWorkError(photos!.networkError!, controller: self)
                } else if error != nil {
                    ViewHelper.showNetWorkError(error!, controller: self)
                }
                return
            }
            
            self.ownerPhotos = photos?.photos?.allPhotos ?? []
//            print("photos \(photos?.photos?.allPhotos?.count)")
        }
    }
    
    @IBAction func onSegmentTap(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 { // date taken
            ownerPhotos = ownerPhotos.sorted(by: { (p1, p2) -> Bool in
                guard let p1Date = p1.photoTakenDate, let p2Date = p2.photoTakenDate else {
                    return false
                }
                return p1Date > p2Date
            })
        } else { // date publish
            ownerPhotos = ownerPhotos.sorted(by: { (p1, p2) -> Bool in
                guard let p1Date = p1.photoUploadedDate, let p2Date = p2.photoUploadedDate else {
                    return false
                }
                return p1Date > p2Date
            })
        }
    }
}

extension GalleryViewController:mProgressbar {
    
}


extension GalleryViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ownerPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell {
            let model = PhotoViewModel(photoDetails: ownerPhotos[indexPath.row])
            model.setUpCell(cell)
            return cell
        }
        return UICollectionViewCell(frame: .zero)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
}
