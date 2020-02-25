//
//  ViewHelper.swift
//  MscriptsGallery
//
//  Created by A6049116 on 2/25/20.
//  Copyright © 2020 Mscripts. All rights reserved.
//

import Foundation
import UIKit

struct ViewHelper {
    static func showAlert(title:String,message:String,source:UIViewController) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancel)
        source.present(alert, animated: true, completion: nil)
    }
    
    static func showNetWorkError(_ error:NetworkControllerError,controller:UIViewController) {
        switch error {
        case .FlickrError(_,let msg,_):
//            print("show error \(msg)")
            showAlert(title: "Error", message: msg ?? "Something went wrong.", source: controller)
        case .noNetworkError:
            showAlert(title: "Error", message: "No network connection is available. Please try again.", source: controller)
        default:
            break
        }
    }
}
