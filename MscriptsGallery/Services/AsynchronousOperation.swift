//
//  AsynchronousOperation.swift
//  MscriptsGallery
//
//  Created by A6049116 on 2/25/20.
//  Copyright © 2020 Mscripts. All rights reserved.
//

import Foundation
import UIKit

class AsynchronousOperation:Operation {
    typealias PhotoDownloadHandler = (_ image:UIImage?,_ error:Error?) -> Void
    @objc private enum OperationState: Int {
        case ready
        case executing
        case finished
    }
    var photoUrl:String!
    var completion:PhotoDownloadHandler?
    
    override var isAsynchronous: Bool {
        get {
            return true
        }
    }

    private let stateQueue = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".rw.state", attributes: .concurrent)

    private var rawState: OperationState = .ready
    @objc private dynamic var state: OperationState {
        get { return stateQueue.sync { rawState } }
        set { stateQueue.sync(flags: .barrier) { rawState = newValue } }
    }
    open         override var isReady: Bool { return state == .ready && super.isReady }
    public final override var isExecuting: Bool { return state == .executing }
    public final override var isFinished: Bool { return state == .finished }

    open override class func keyPathsForValuesAffectingValue(forKey key: String) -> Set<String> {
        if ["isReady", "isFinished", "isExecuting"].contains(key) {
            return [#keyPath(state)]
        }

        return super.keyPathsForValuesAffectingValue(forKey: key)
    }
    
    required init(url:String) {
        photoUrl = url
    }

    public final override func start() {
        if isCancelled {
            finish()
            return
        }
        state = .executing
        main()
    }
    
    open override func main() {
        guard isCancelled == false else {
            finish()
            return
        }
        guard let url = URL(string: photoUrl) else {
            return
        }
        let session = URLSession.shared
        session.downloadTask(with: url) {[weak self] (location, response, error) in
            if let source = location,let imageData = try? Data(contentsOf: source) {
                let image = UIImage(data: imageData)
                self?.completion?(image,nil)
            } else {
                self?.completion?(nil,error)
            }
            self?.finish()
        }.resume()
    }

    public final func finish() {
        if isExecuting || isReady {
            state = .finished
        }
    }
}
