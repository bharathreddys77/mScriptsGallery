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

struct Photos:Decodable {
    var page:Int?
    var pages:Int?
    var perpage:Int?
    var total:String?
    var photo:[Photo]?
}

struct Photo:Decodable {
    var id:String?
    var owner:String?
    var secret:String?
    var server:String?
    var farm:String?
    var title:String?
    var ispublic:Bool?
    var isfriend:Bool?
    var isfamily:Bool?
}
