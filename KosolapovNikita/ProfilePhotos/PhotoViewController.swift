//
//  Profile.swift
//  L1_KosolapovNikita
//
//  Created by Nikita on 29/03/2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.

import UIKit
import RealmSwift

class PhotoController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var token: NotificationToken?
//    var photos: Results<Photo>?

    private let photoAdapter = PhotoAdapter()
    private var photos: [PhotoModel] = []
    
    var ownerId = Int()
    var profileImages = [UIImage]() // Get photos for selected user
    var indexPathRow = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Define collection view delegates
        collectionView.dataSource = self
        collectionView.delegate = self

        photoAdapter.getPhotos(for: ownerId) { [weak self] photos in
            self?.photos = photos
            self?.collectionView.reloadData()
        }
    }
}

// Setup UICollectionView data
extension PhotoController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Setup cells
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoViewCell", for: indexPath) as! PhotoCollectionViewCell
        
        cell.configure(image: photos[indexPath.row])
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPhotoDetail" {
            if let selectedIndexPathRow = collectionView?.indexPathsForSelectedItems?.first?.row { // get indexPath for selected item
                if let photoDetailViewController = segue.destination as? SelectedPhotoViewController { // get link to photoDetailViewController
                    photoDetailViewController.currentPhotoNumber = selectedIndexPathRow // set current photo number into photoDetailViewController
                }
            }
        }
    }
}

// Setup UICollectionView flow layout
extension PhotoController: UICollectionViewDelegateFlowLayout {
    
    // Item size
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfItemInRow: CGFloat = 3 // set number of items in rows
        let size = collectionView.bounds.width / numberOfItemInRow - 1
        
        return CGSize(width: size, height: size)
    }
    
    // Spacing in section
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    // Minimum horizontal spacing
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // Minimum vertical spacing
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
