//
//  NewsItem.swift
//  KosolapovNikita
//
//  Created by Nikita on 28.09.2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import Foundation
import SwiftyJSON

final class NewsItem {
    
    enum NewsItemType: String {
        case post
        case photo = "wall_photo"
    }
    
    enum AttachmentsType: String {
        case photo
        case video
    }
    
    enum PostType: String {
        case post // original
        case copy // repost
    }
    
    var profile: NewsItemProfile?
    var sourceId: Int
    var date: Date
    var likesCount: Int
    var repostsCount: Int
    var commentsCount: Int
    var viewsCount: Int
    var photoUrl: String = ""
    var text: String = ""
    var type: NewsItemType
    var attachmentsType: AttachmentsType
    var postType: PostType
    
    init(json: JSON) {
        self.sourceId = json["source_id"].intValue
        self.date = {
            let timeInterval = json["date"].doubleValue
            let date = Date(timeIntervalSince1970: timeInterval)
            return date
        }()
        self.type = NewsItemType(rawValue: json["type"].stringValue) ?? .post
        self.likesCount = json["likes"]["count"].intValue
        self.repostsCount = json["reposts"]["count"].intValue
        self.commentsCount = json["comments"]["count"].intValue
        self.viewsCount = json["views"]["count"].intValue
        
        if json["copy_history"].array != nil {
            self.postType = .copy
        } else {
            self.postType = .post
        }
        
        switch self.postType {
        case .post:
            self.photoUrl = json["attachments"]
                .arrayValue
                .first?["photo"]["photo_604"]
                .string ?? ""
            self.attachmentsType = NewsItem.AttachmentsType(rawValue: json["attachments"]
            .arrayValue
            .first?["type"]
            .string ?? "") ?? .photo
        case .copy:
            self.photoUrl = json["copy_history"]
                .arrayValue
                .first?["attachments"]
                .arrayValue
                .first?["photo"]["photo_604"]
                .string ?? ""
            self.attachmentsType = NewsItem.AttachmentsType(rawValue: json["copy_history"]
                .arrayValue
                .first?["attachments"]
                .arrayValue
                .first?["type"]
                .string ?? "") ?? .photo
        }
        self.text = json["text"].stringValue
    }
}
