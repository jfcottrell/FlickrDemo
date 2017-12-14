//
//  FlickrCollectionViewCell.swift
//  FlickrDemo
//
//  Created by John Cottrell on 12/13/17.
//  Copyright © 2017 John Cottrell. All rights reserved.
//

import UIKit

class FlickrCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
