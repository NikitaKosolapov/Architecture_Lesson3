//
//  MyFriendsTableViewCell.swift
//  KosolapovNikita
//
//  Created by Nikita on 02/04/2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import UIKit

class MyFriendsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: CircleImageWithShadowView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBAction func userImageAnimate() {
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity:  0,
                       options: [.curveEaseOut],
                       animations: {
                        self.userImageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                        self.userImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
    func configure(user: User) {
        
        // Icon
        let url = user.photo
        self.userImageView.imageView.loadImageUsingCache(withUrl: url)
        
        // Name
        self.userNameLabel.text = user.lastName + " " + user.firstName
    }
}
