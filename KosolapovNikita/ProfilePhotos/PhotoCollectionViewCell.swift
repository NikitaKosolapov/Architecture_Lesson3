//
//  ProfileCollectionViewCell.swift
//  KosolapovNikita
//
//  Created by Nikita on 25/04/2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    func configure(image: PhotoModel) {
        let url = image.url
        self.photoImageView.loadImageUsingCache(withUrl: url)
    }
}
