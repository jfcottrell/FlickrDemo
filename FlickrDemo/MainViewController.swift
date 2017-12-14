//
//  MainViewController.swift
//  FlickrDemo
//
//  Created by John Cottrell on 12/11/17.
//  Copyright © 2017 John Cottrell. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, PhotoQueryDelegate {

    var collectionView: UICollectionView!
    var itemsPerRow: CGFloat!
    let sectionInsets = UIEdgeInsets(top: 50.0, left: 40.0, bottom: 50.0, right: 40.0)
    var apiKey: String!
    var searchTextField: UITextField!
    var flickrQuery = FlickrPhotoQuery()
    var flickrPhotos = [FlickrPhoto]()
    let reuseIdentifier = "Cell"
    var page: Int = 0
    var perPage: Int = 0
    var currentPage: Int = 0
    var pagesLoaded: Int = 0
    var searchText: String = ""
    var label: UILabel!
    var activityIndicator = UIActivityIndicatorView()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var favoriteIDs = Set<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // get core data context from app delegate
        let app = UIApplication.shared
        let appDelegate = app.delegate as! AppDelegate
        
        searchTextField = UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
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
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 90, height: 120)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FlickrPhotoCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = UIColor.white
        collectionView.prefetchDataSource = self

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
        flickrQuery.delegate = self
        
        guard let plistPath = Bundle.main.path(forResource: "Config", ofType: "plist") else { return }
        guard let dict = NSDictionary(contentsOfFile: plistPath) as? [String: AnyObject] else { return }
        guard let per_page = dict["per_page"] else { return }
        perPage = per_page as! Int
        page = 1
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue:"ImageSaveEvent"), object: nil, queue: nil, using: saveEventNotif)
        
        loadFavorites()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        searchText = searchTextField.text!
        
        if searchText == "" {
            let alert = UIAlertController(title: "No search term", message: "Please enter a search term.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
        
            // clear and reload favorites
            flickrPhotos.removeAll()
            loadFavorites()
            collectionView.reloadData()
            
            // Make initial query (page should be 1)
            currentPage = 1
            flickrQuery.query(queryString: searchText, page: currentPage)
            pagesLoaded = 1
                
            textField.text = nil
        }
        return true
    }
    
    // MARK: - PhotoQueryDelegate method
    func queryDataLoaded(results: QueryResults) {
        let photos = results.photo
        for photoInfo in photos {
            // check to see if photo is saved as a favorite
            downloadImage(photoInfo: photoInfo, photoCount: 0)
        }
    }
    
    // MARK: - Image download
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(photoInfo: PhotoQueryInfo, photoCount: Int) {
        let flickrPhoto = FlickrPhoto(photoID: photoInfo.id, farm: photoInfo.farm, server: photoInfo.server, secret: photoInfo.secret)
        guard let url = flickrPhoto.flickrImageURL() else { return }
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() {
                if let image = UIImage(data: data) {
                    flickrPhoto.thumbnail = image
                    flickrPhoto.largeImage = image
                    self.flickrPhotos.append(flickrPhoto)
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Load favorites
    func loadFavorites() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
        request.returnsObjectsAsFaults = false
        do {
            let context = appDelegate.persistentContainer.viewContext
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let id = data.value(forKey: "id") as! String
                let imageData = data.value(forKey: "image") as! Data
                let image = UIImage(data: (imageData as? NSData)! as Data)
                let flickrPhoto = FlickrPhoto(photoID: id)
                if let image = image {
                    flickrPhoto.thumbnail = image
                    flickrPhoto.largeImage = image
                    flickrPhoto.favorite = true
                    self.flickrPhotos.append(flickrPhoto)
                    favoriteIDs.insert(id)
                    self.collectionView.reloadData()
                }
            }
        } catch { print("CORREDATA: Failed to load favorite") }
    }
    
    // MARK: - CollectionView delgate/datasource methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flickrPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FlickrPhotoCell
        cell.backgroundColor = UIColor.lightGray
        cell.layer.cornerRadius = 9.0
        cell.imageView.image = flickrPhotos[indexPath.row].thumbnail!
        currentPage = Int(indexPath.row / perPage) + 1
        cell.tag = indexPath.row
        if flickrPhotos[indexPath.row].favorite == true {
            cell.setFavoriteState(favorite: true)
        } else {
            cell.setFavoriteState(favorite: false)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        let img = flickrPhotos[indexPath.row].largeImage
        detailViewController.image = img
        self.navigationController?.pushViewController(detailViewController, animated: false)
    }
    
    // MARK: - Save/Delete event notif
    func saveEventNotif(notification: Notification) -> Void {
        guard let dict = notification.userInfo else { return }
        guard let tag = dict["tag"] else { return }
        guard let favorite = dict["favorite"] else { return }

        if favorite as! Int == 1 {
            // save
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Favorites", in: context)
            let newImage = NSManagedObject(entity: entity!, insertInto: context)
            flickrPhotos[tag as! Int].favorite = true
            let data: NSData = UIImageJPEGRepresentation(flickrPhotos[tag as! Int].thumbnail!, 1.0)! as NSData
            let id = flickrPhotos[tag as! Int].photoID
            newImage.setValue(id, forKey: "id")
            newImage.setValue(data, forKey: "image")
            favoriteIDs.insert(id)
            do {
                try context.save()
            } catch {
                print("COREDATA: save failed")
            }
        } else {
            // delete
            flickrPhotos[tag as! Int].favorite = false
            let idToDelete = flickrPhotos[tag as! Int].photoID
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
            request.predicate = NSPredicate(format: "id = %@", idToDelete)
            request.returnsObjectsAsFaults = false
            let context = appDelegate.persistentContainer.viewContext
            do {
                let result = try context.fetch(request)
                for object in result as! [NSManagedObject] {
                    context.delete(object)
                    favoriteIDs.remove(idToDelete)
                }
            } catch { print("COREDATA: delete failed") }
            do {
                try context.save()
            } catch { print("COREDATA: context.save() failed") }
        }
    }
}

// MARK: - Extensions
extension MainViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {

        //If we are prefetching and on the last page, go ahead and grab another page
        if self.currentPage == pagesLoaded {
            pagesLoaded += 1
            self.flickrQuery.query(queryString: self.searchText, page: self.pagesLoaded)
        }
    }
}
