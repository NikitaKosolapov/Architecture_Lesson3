//
//  FirebaseUser.swift
//  KosolapovNikita
//
//  Created by Nikita on 04.06.2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import Foundation
import Firebase

class FirebaseGroup {
    
    let name: String
    let activity: String
    let groupId: Int
    let ref: DatabaseReference?
    
    init(groupId: Int, name: String, activity: String) {
        self.groupId = groupId
        self.name = name
        self.activity = activity
        self.ref = nil
    }
    
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any],
            let activity = value["activity"] as? String,
            let name = value["name"] as? String,
            let groupId = value["group_id"] as? Int else {
                return nil
        }
        self.ref = snapshot.ref
        self.groupId = groupId
        self.name = name
        self.activity = activity
    }
    
    func toAnyObject() -> [String: Any] {
        return [
            "name" : name,
            "activity": activity
        ]
    }
}
