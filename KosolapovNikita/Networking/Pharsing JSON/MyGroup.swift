//
//  Group.swift
//  KosolapovNikita
//
//  Created by Nikita on 14.05.2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import Foundation
import RealmSwift

class MainMyGroupsResponse: Decodable {
    var response: GroupResponse
}

class GroupResponse: Decodable {
    var items: [MyGroup]
}

class MyGroup: Object, Decodable {
    
    @objc dynamic var id = Int()
    @objc dynamic var activity = String()
    @objc dynamic var name = String()
    @objc dynamic var photo200 = String()
    
    enum CodingKeys: String, CodingKey {
        case id
        case activity
        case name
        case photo200 = "photo_200"
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}





