//
//  MainViewController.swift
//  FlickrDemo
//
//  Created by John Cottrell on 12/11/17.
//  Copyright © 2017 John Cottrell. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    var collectionView: UICollectionView!
    var itemsPerRow: CGFloat!
    let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let searchTextField = UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
        searchTextField.placeholder = "Search"
        searchTextField.font = UIFont.systemFont(ofSize: 15)
        searchTextField.borderStyle = UITextBorderStyle.roundedRect
        searchTextField.autocorrectionType = UITextAutocorrectionType.no
        searchTextField.keyboardType = UIKeyboardType.default
        searchTextField.returnKeyType = UIReturnKeyType.search
        searchTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        searchTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        searchTextField.delegate = self
        self.navigationItem.titleView = searchTextField
        //searchTextField.becomeFirstResponder()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 90, height: 120)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.white
        self.view.addSubview(collectionView)
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            itemsPerRow = 2
        case .phone:
            itemsPerRow = 1
        case .unspecified:
            itemsPerRow = 1
        default:
            itemsPerRow = 1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()
        
        // Do search here
        activityIndicator.removeFromSuperview()
            
//            if let error = error {
//                // 2
//                print("Error searching : \(error)")
//                return
//            }
//
//            if let results = results {
//                // 3
//                print("Found \(results.searchResults.count) matching \(results.searchTerm)")
//                self.searches.insert(results, at: 0)
//
//                // 4
//                self.collectionView?.reloadData()
//            }
        
        textField.text = nil
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - CollectionView delgate/datasource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath)
        cell.backgroundColor = UIColor.orange
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
