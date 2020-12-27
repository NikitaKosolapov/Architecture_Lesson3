//
//  ParseDataOperation.swift
//  KosolapovNikita
//
//  Created by Nikita on 01.08.2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import Foundation
import SwiftyJSON

class ParseData: Operation {
    
    var outputData: [User] = []
    
    override func main() {
        guard let getDataOperation = dependencies.first as? GetDataOperation,
            let data = getDataOperation.data else { return }
        if let json = try? JSON(data: data) {
            let users: [User] = json["response"]["items"].compactMap {
                let id = $0.1["id"].intValue
                let photo = $0.1["photo_200"].stringValue
                let firstName = $0.1["first_name"].stringValue
                let lastName = $0.1["last_name"].stringValue
                return User(id: id,  photo: photo, firstName: firstName, lastName: lastName)
            }
            outputData = users
        }
    }
}



