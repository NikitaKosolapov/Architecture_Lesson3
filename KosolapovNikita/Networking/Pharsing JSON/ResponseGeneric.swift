//
//  Response.swift
//  KosolapovNikita
//
//  Created by Nikita on 21.05.2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import Foundation


struct Response<T: Decodable>: Decodable {
    let response: Response?
    let error: VKError?
    
    enum CodingKeys: String, CodingKey {
        case response
        case error
    }
    
    struct Response: Decodable {
        let items: [T]
    }
    
    struct VKError: Decodable {
        let error_code: Int?
        let error_msg: String?
        
        enum ErrorKeys: String, CodingKey {
            case errorCode = "error_code"
            case errorMsg = "error_msg"
        }
    }
    
    
}
