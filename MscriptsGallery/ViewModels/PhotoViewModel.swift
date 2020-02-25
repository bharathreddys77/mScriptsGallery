//
//  PhotoViewModel.swift
//  MscriptsGallery
//
//  Created by A6049116 on 2/25/20.
//  Copyright © 2020 Mscripts. All rights reserved.
//

import Foundation

struct PhotoViewModel {
    let photoDetails:Photo
    
    func setUpCell(_ cell:PhotoCell) {
        cell.photoLabel.text = photoDetails.ownername ?? "NA"
        if let farmId = photoDetails.farm,let serverId = photoDetails.server,let imageId = photoDetails.id,let secret = photoDetails.secret {
//        https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}_[mstzb].jpg
            let url = "https://farm\(farmId).staticflickr.com/\(serverId)/\(imageId)_\(secret)_s.jpg"
            PhotoDownloadManager.shared.downloadImage(url: url) { (image, error) in
//                print("image downloaded")
                if let _ = image {
                    cell.userPhoto.image = image!
                }
            }
        }
    }
}
