//
//  PhotoModel.swift
//  KosolapovNikita
//
//  Created by Nikita on 27.12.2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import UIKit

struct PhotoModel {
    let url: String
    let text: String
    let likes: Int
    let reposts: Int
    let height: Int
    let width: Int
    var aspectRatio: CGFloat {
        return CGFloat(height / width)
    }
}
