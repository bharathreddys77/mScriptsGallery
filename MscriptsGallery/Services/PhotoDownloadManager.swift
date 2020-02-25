//
//  PhotoDownloadManager.swift
//  MscriptsGallery
//
//  Created by A6049116 on 2/25/20.
//  Copyright © 2020 Mscripts. All rights reserved.
//

import Foundation
import UIKit

class PhotoDownloadManager {
    lazy var queue:OperationQueue = {
        var q = OperationQueue()
        q.name = "flickrImageQueue"
        return q
    }()
    let photoCache = NSCache<NSString,UIImage>()
    static let shared = PhotoDownloadManager()
    
    func downloadImage(url:String,completion:@escaping(_ image:UIImage?,_ error:Error?) -> Void) {
        if let image = photoCache.object(forKey: url as NSString) {//return from cache
            print("return from cache")
            return completion(image,nil)
        } else { //download from APi
            let operation = AsynchronousOperation(url: url)
            operation.completion = {[weak self](image,error) in
                if let _ = image {
                    self?.photoCache.setObject(image!, forKey: operation.photoUrl! as NSString)
                }
                DispatchQueue.main.async {
                    completion(image,error)
                }
            }
            queue.addOperation(operation)
        }
    }
}
