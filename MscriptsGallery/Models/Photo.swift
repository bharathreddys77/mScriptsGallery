//
//  Photo.swift
//  MscriptsGallery
//
//  Created by A6049116 on 2/23/20.
//  Copyright © 2020 Mscripts. All rights reserved.
//

import Foundation

struct GetPhotoRequest:Encodable {
    
}

struct PhotoDetails:Decodable {
    var page:Int?
    var pages:Int?
    var perpage:Int?
    var total:String?
    var allPhotos:[Photo]?
    
    enum CodeKeys:String,CodingKey {
        case allPhotos = "photo"
    }
    
    init(from decoder:Decoder) throws {
        let container = try decoder.container(keyedBy: CodeKeys.self)
        allPhotos = try container.decode([Photo].self,forKey: .allPhotos)
    }
}

struct Photos:Decodable {
    var photos:PhotoDetails?
    var networkError:NetworkControllerError?
    enum CodingKeys:String,CodingKey {
        case photos = "photos"
        case errorStatus = "stat"
        case errorCode = "code"
        case errorMessage = "message"
    }
    
    init(from decoder:Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        photos = try container.decodeIfPresent(PhotoDetails.self, forKey: .photos)
        if let errCode = try container.decodeIfPresent(Int.self, forKey: .errorCode) {
            let errMsg = try container.decodeIfPresent(String.self, forKey: .errorMessage)
            let errStatus = try container.decodeIfPresent(String.self, forKey: .errorStatus)
            networkError = NetworkControllerError.FlickrError(code: errCode, message: errMsg, status: errStatus ?? "" == "fail")
        }
    }
}

struct Photo:Decodable {
    var id:String?
    var owner:String?
    var secret:String?
    var server:String?
    var farm:Int?
    var title:String?
    var ownername:String?
    var photoTakenDate:Date?
    var photoUploadedDate:Date?
    
    enum CodingKeys:String,CodingKey {
        case id = "id"
        case owner = "owner"
        case secret = "secret"
        case server = "server"
        case farm = "farm"
        case title = "title"
        case ownername = "ownername"
        case DateTaken = "datetaken"
        case DateUpload = "dateupload"
    }
    
    init(from decoder:Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let takenDate = try container.decode(String.self, forKey: .DateTaken)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        photoTakenDate = formatter.date(from: takenDate)
        id = try container.decode(String.self, forKey: .id)
        owner = try container.decode(String.self, forKey: .owner)
        secret = try container.decode(String.self, forKey: .secret)
        server = try container.decode(String.self, forKey: .server)
        farm = try container.decode(Int.self, forKey: .farm)
        title = try container.decode(String.self, forKey: .title)
        ownername = try container.decode(String.self, forKey: .ownername)
        let dateUpload = try container.decode(String.self, forKey: .DateUpload)
        if let milliSeconds = Int(dateUpload) {
            let dateConversion = Date.init(timeIntervalSinceNow: TimeInterval(milliSeconds)/1000)
            photoUploadedDate = dateConversion
        }
    }
}
