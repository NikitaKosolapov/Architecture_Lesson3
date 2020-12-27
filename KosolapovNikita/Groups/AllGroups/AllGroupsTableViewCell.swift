//
//  AllGroupsTableViewCell.swift
//  KosolapovNikita
//
//  Created by Nikita on 10.06.2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import UIKit

class AllGroupsTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var groupCircleImage: CircleImageWithShadowView!
    @IBOutlet private weak var groupNameLabel: UILabel!
    
    func configure(groups: AllGroup) {
    
        // Icon
        let url = groups.photo
        self.groupCircleImage.imageView.loadImageUsingCache(withUrl: url)
        
        // Name
        self.groupNameLabel.text = groups.name
    }
}
