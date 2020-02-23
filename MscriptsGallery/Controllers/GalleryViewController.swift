//
//  ViewController.swift
//  MscriptsGallery
//
//  Created by A6049116 on 2/23/20.
//  Copyright © 2020 Mscripts. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showProgressBar()
        mScriptsServiceController().retrievePublicPhotos {[unowned self] (photos, error) in
            self.hideProgressBar()
            print("photos \(photos?.photo?.count)")
        }
    }
    
    
    @IBAction func onSegmentTap(_ sender: Any) {
        
    }
}

extension GalleryViewController:mProgressbar {
    
}


extension GalleryViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell(frame: .zero)
    }
}
