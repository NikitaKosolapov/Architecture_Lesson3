//
//  NewsItemProfile.swift
//  KosolapovNikita
//
//  Created by Nikita on 28.09.2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import Foundation
import SwiftyJSON

final class NewsItemProfile {

    let id: Int
    let name: String
    let photoUrl: String
    
    init(json: JSON) {
        self.id = json["id"].intValue
        if let name = json["name"].string {
            self.name = name
        } else {
            self.name = {
                let firstName = json["first_name"].stringValue
                let lastName = json["last_name"].stringValue
                let name = firstName + " " + lastName
                return name
            }()
        }
        self.photoUrl = json["photo_100"].stringValue
    }
}
