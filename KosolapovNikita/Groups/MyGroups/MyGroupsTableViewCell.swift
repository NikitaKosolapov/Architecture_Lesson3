//
//  MyGroupsTableViewCell.swift
//  KosolapovNikita
//
//  Created by Nikita on 01.06.2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import UIKit

class MyGroupsTableViewCell: UITableViewCell {
   
    @IBOutlet weak var groupImage: CircleImageWithShadowView!
    @IBOutlet weak var groupName: UILabel!
    
    
    func configure(myGroup: MyGroup) {
    
        // Icon
        let url = myGroup.photo200
        self.groupImage.imageView.loadImageUsingCache(withUrl: url)
        
        // Name
        self.groupName.text = myGroup.name
    }
}
