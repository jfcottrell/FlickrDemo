//
//  PhotoModel.swift
//  FlickrDemo
//
//  Created by John Cottrell on 12/12/17.
//  Copyright © 2017 John Cottrell. All rights reserved.
//

import Foundation
import UIKit

struct PhotoModel {
    let photoImage: UIImage
    let id: String
    let favorite: Bool
}

class PhotoCollection {
    
    var photoCollection = [PhotoModel]()
    
    func addPhotoToCollection(flickrPhotoUrl: String, id: String, favorite: Bool = false) {
        
        guard let url = URL(string: flickrPhotoUrl) else {
            print("ERROR: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            
            // do stuff with response, data & error here
            if let error = error {
                print(error)
                return
            } else {
                print("NO ERROR")
            }
            
            if let response = response {
                print("response = \(response)")
            } else {
                print("NO RESPONSE")
                return
            }
            
            if let data = data {
                let image: UIImage = UIImage(data: data)!
                let photo: PhotoModel = PhotoModel(photoImage: image, id: id, favorite: favorite)
                self.photoCollection.append(photo)
            } else {
                print("NO DATA")
            }
        })
        task.resume()
    }
}
