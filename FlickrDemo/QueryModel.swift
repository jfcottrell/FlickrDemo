//
//  Query.swift
//  FlickrDemo
//
//  Created by John Cottrell on 12/11/17.
//  Copyright © 2017 John Cottrell. All rights reserved.
//

import Foundation

struct PhotoQueryInfo : Codable {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let ispublic: Int
    let isfriend: Int
    let isfamily: Int
}

struct QueryResults : Decodable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: String
    let photo: [PhotoQueryInfo]
}

struct Query : Decodable {
    let photos: QueryResults
    let stat: String
}
