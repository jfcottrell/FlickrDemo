//
//  FlickrPhotoQuery.swift
//  FlickrDemo
//
//  Created by John Cottrell on 12/11/17.
//  Copyright © 2017 John Cottrell. All rights reserved.
//

import Foundation

struct FlickrPhotoQuery {
    
    func query(queryString: String) {
        
        guard let plistPath = Bundle.main.path(forResource: "Config", ofType: "plist") else { return }
        guard let dict = NSDictionary(contentsOfFile: plistPath) as? [String: AnyObject] else { return }
        guard let apiKey = dict["api_key"] else { return }
        guard let perPage = dict["per_page"] else { return }
        print("api_key = \(apiKey)")
        print("per_page = \(perPage)")
        
        //let urlString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=99042481673c83f4132e0fe25e49fdeb&text=747&per_page=4&format=json&nojsoncallback=1"
        let urlString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(queryString)&per_page=\(perPage)&format=json&nojsoncallback=1"
        print("urlString = \(urlString)")
        print("queryString = \(queryString)")
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else { return }
            
            do {
                let str = String(data: data, encoding: String.Encoding.utf8) as String!
                print (str!)
                
                let query = try JSONDecoder().decode(Query.self, from: data)
                
                print(query)
                
                var i: Int = 1
                for myphoto in query.photos.photo {
                    print("title (\(i)) = \(myphoto.title)")
                    i += 1
                }
                
                DispatchQueue.main.async {
                    // UI Update Code
                }
            } catch let jsonError {
                print(jsonError)
            }
        }
        task.resume()
    }
}

