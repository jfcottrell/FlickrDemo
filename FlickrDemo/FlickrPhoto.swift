//
//  FlickrPhoto.swift
//  FlickrDemo
//
//  Created by John Cottrell on 12/12/17.
//  Copyright © 2017 John Cottrell. All rights reserved.
//

import Foundation
import UIKit

class FlickrPhoto {
    var thumbnail : UIImage?
    var largeImage : UIImage?
    var favorite: Bool?
    var photoID : String
    let farm : Int
    let server : String
    let secret : String
    
    init(photoID: String,farm: Int, server: String, secret: String) {
        self.photoID = photoID
        self.farm = farm
        self.server = server
        self.secret = secret
    }
    
    convenience init(photoID: String) {
        self.init(photoID: photoID, farm: 0, server: "", secret: "")
    }
    
    func flickrImageURL(_ size:String = "m") -> URL? {
        if let url =  URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_\(size).jpg") {
            return url
        }
        return nil
    }
    
    func sizeToFillWidthOfSize(_ size:CGSize) -> CGSize {
        guard let thumbnail = thumbnail else {
            return size
        }
        
        let imageSize = thumbnail.size
        var retSize = size
        let aspectRatio = imageSize.width / imageSize.height
        
        retSize.height = retSize.width / aspectRatio
        if retSize.height > size.height {
            retSize.height = size.height
            retSize.width = size.height * aspectRatio
        }
        return retSize
    }
}
