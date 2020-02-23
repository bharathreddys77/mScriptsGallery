//
//  NetworkingController.swift
//  MscriptsGallery
//
//  Created by A6049116 on 2/23/20.
//  Copyright © 2020 Mscripts. All rights reserved.
//

import Foundation

protocol NetworkingController {
    func retrievePublicPhotos(completion:@escaping(Photos?,NetworkControllerError?) -> Void)
}

enum NetworkControllerError:Error {
    case invalidRequest
    case dataParseError(_ error:Error?)
    case Non200StatusCodeError(_ error:Error?)
    case BadResponseError(_ error:Error?)
    case forwardedError(Error:Error?)
    case noDataError
    case noNetworkError
    case customMessageError(title:String,msg:String)
    case customMessage(title:String,message:String)
    case defaultError
    case NoDataError
    case inputValidationError
}
