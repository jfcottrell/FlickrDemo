//
//  Favorites+CoreDataProperties.swift
//  FlickrDemo
//
//  Created by John Cottrell on 12/14/17.
//  Copyright © 2017 John Cottrell. All rights reserved.
//
//

import Foundation
import CoreData


extension Favorites {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorites> {
        return NSFetchRequest<Favorites>(entityName: "Favorites")
    }

    @NSManaged public var id: String?
    @NSManaged public var image: NSData?

}
