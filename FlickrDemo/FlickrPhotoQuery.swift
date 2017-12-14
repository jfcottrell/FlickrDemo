//
//  FlickrPhotoQuery.swift
//  FlickrDemo
//
//  Created by John Cottrell on 12/11/17.
//  Copyright © 2017 John Cottrell. All rights reserved.
//

import Foundation

protocol PhotoQueryDelegate {
    func queryDataLoaded(results: QueryResults)
}

struct FlickrPhotoQuery {
    
    var delegate: PhotoQueryDelegate?
    
    func query(queryString: String, page: Int) {
        guard let plistPath = Bundle.main.path(forResource: "Config", ofType: "plist") else { return }
        guard let dict = NSDictionary(contentsOfFile: plistPath) as? [String: AnyObject] else { return }
        guard let apiKey = dict["api_key"] else { return }
        guard let perPage = dict["per_page"] else { return }
        
        var urlString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(queryString)&per_page=\(perPage)&page=\(page)&format=json&nojsoncallback=1&safe_search=1"
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                //let str = String(data: data, encoding: String.Encoding.utf8) as String!           // DEBUG use only
                let query = try JSONDecoder().decode(Query.self, from: data)                        // decode json using new Swift4 decoder (yeah!)
                let queryResults: QueryResults = query.photos
                self.delegate?.queryDataLoaded(results: queryResults)
            } catch let jsonError {
                print(jsonError)
            }
        }
        task.resume()
    }
}
