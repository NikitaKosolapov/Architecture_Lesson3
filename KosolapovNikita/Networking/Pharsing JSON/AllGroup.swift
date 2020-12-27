//
//  GroupsSearch.swift
//  KosolapovNikita
//
//  Created by Nikita on 10.06.2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import Foundation

struct AllGroupsResponse: Codable {
    let response: GroupItems
}

struct GroupItems: Codable {
    let items: [AllGroup]
}

struct AllGroup: Codable {
    let id: Int
    let name: String
    let photo: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case photo = "photo_200"
    }
}
