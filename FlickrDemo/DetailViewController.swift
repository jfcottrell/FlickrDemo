//
//  DetailViewController.swift
//  FlickrDemo
//
//  Created by John Cottrell on 12/12/17.
//  Copyright © 2017 John Cottrell. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var imageView : UIImageView!
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView  = UIImageView(frame: self.view.frame)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageView)
        
        let margins = self.view.layoutMarginsGuide
        imageView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.view.frame = self.view.bounds
        self.view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        if UIDevice.current.orientation.isLandscape {
            print("Landscape: \(size)")
            self.imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        } else {
            print("Portrait: \(size)")
        }
    }
}
