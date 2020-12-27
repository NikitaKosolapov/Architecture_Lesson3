//
//  Session.swift
//  KosolapovNikita
//
//  Created by Nikita on 12.05.2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import Foundation

// Define Session singleton
class Session {
    
    static let shared = Session()
    
    private init() {}
    
    var token = String()
    var userId = Int()
}
