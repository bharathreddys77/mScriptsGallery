//
//  mProgressbar.swift
//  MscriptsGallery
//
//  Created by A6049116 on 2/23/20.
//  Copyright © 2020 Mscripts. All rights reserved.
//

import Foundation

import UIKit

protocol mProgressbar {
    func showProgressBar()
    func hideProgressBar()
}

extension mProgressbar where Self:UIViewController {
    func showProgressBar() {
        let v = UIView(frame: view.frame)
        v.backgroundColor = .gray
        v.alpha = 0.7
        let progress = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        progress.color = .white
        progress.style = .medium
        progress.startAnimating()
        progress.center = v.center
        v.addSubview(progress)
        let label = UILabel(frame: CGRect(x: 0, y: progress.frame.origin.y+40, width: 100, height: 44))
        label.center.x = v.center.x
        label.text = "Please wait..."
        label.textColor = .white
        v.addSubview(label)
        v.tag = 200
        view.addSubview(v)
    }
    
    func hideProgressBar() {
        view.viewWithTag(200)?.removeFromSuperview()
    }
}
