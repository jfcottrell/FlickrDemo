//
//  FlickrPhotoCell.swift
//  FlickrDemo
//
//  Created by John Cottrell on 12/12/17.
//  Copyright © 2017 John Cottrell. All rights reserved.
//

import Foundation
import UIKit

class FlickrPhotoCell: UICollectionViewCell {
    var button: UIButton!
    var buttonState: Bool!
    var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        button = UIButton(type: UIButtonType.custom) as UIButton
        button.frame = CGRect(x: 10, y: self.frame.height - 40, width: 30, height: 30)
        button.setBackgroundImage(UIImage(named:"star_white2.png"), for: .normal)
        self.buttonState = false
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        addSubview(button)
        
        self.backgroundColor = #colorLiteral(red: 0.9338415265, green: 0.9338632822, blue: 0.9338515401, alpha: 1)
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 8
    }
    
    @objc func buttonTapped() {
        var userInfo = [String: Int]()
        userInfo["tag"] = self.tag
        if buttonState == false {
            buttonState = true
            button.setBackgroundImage(UIImage(named:"star_yellow2.png"), for: .normal)
            userInfo["favorite"] = 1
        } else {
            buttonState = false
            button.setBackgroundImage(UIImage(named:"star_white2.png"), for: .normal)
            userInfo["favorite"] = 0
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue:"ImageSaveEvent"), object: nil, userInfo: userInfo)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setFavoriteState(favorite: Bool) {
        if favorite == true {
            buttonState = true
            button.setBackgroundImage(UIImage(named:"star_yellow2.png"), for: .normal)
        } else {
            buttonState = false
            button.setBackgroundImage(UIImage(named:"star_white2.png"), for: .normal)
        }
    }
}
