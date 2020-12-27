//
//  Photo.swift
//  KosolapovNikita
//
//  Created by Nikita on 14.05.2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import Foundation
import RealmSwift

class MainPhotosResponse: Decodable {
    var response: PhotoResponse
}

class PhotoResponse: Decodable {
    var items: [Photo]
}

class Photo: Object, Decodable {
    
    @objc dynamic var url = String()
    @objc dynamic var text = String()
    @objc dynamic var likes = Int()
    @objc dynamic var reposts = Int()
    @objc dynamic var height = Int()
    @objc dynamic var width = Int()
    @objc dynamic var aspectRatio: CGFloat { return CGFloat(height)/CGFloat(width)}
    
    enum ItemKeys: String, CodingKey {
        case sizes
        case text
        case likes
        case reposts
    }
    
    enum SizesKeys: String, CodingKey {
        case url
        case height
        case width
    }
    
    enum LikesKeys: String, CodingKey {
        case count
    }
    
    enum Reposts: String, CodingKey {
        case count
    }
    
    override class func primaryKey() -> String? {
        return "url"
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        
        // Text
        let itemContainer = try decoder.container(keyedBy: ItemKeys.self)
        self.text = try itemContainer.decode(String.self, forKey: .text)
        
        // Url
        var nestedUnkeyedSizesContainer = try itemContainer.nestedUnkeyedContainer(forKey: .sizes)
        var urlArray = [String]()
        var heightArray = [Int]()
        var widthArray = [Int]()
        
        // Get needed size
        while !nestedUnkeyedSizesContainer.isAtEnd {
            let nestedSizesContainer = try nestedUnkeyedSizesContainer.nestedContainer(keyedBy: SizesKeys.self)
            urlArray.append(try nestedSizesContainer.decode(String.self, forKey: .url))
            heightArray.append(try nestedSizesContainer.decode(Int.self, forKey: .height))
            widthArray.append(try nestedSizesContainer.decode(Int.self, forKey: .width))
        }
        self.url = urlArray.last!
        self.height = heightArray.last!
        self.width = widthArray.last!
        
        // Likes
        let nestedLikesContainer = try itemContainer.nestedContainer(keyedBy: LikesKeys.self, forKey: .likes)
        self.likes = try nestedLikesContainer.decode(Int.self, forKey: .count)
        
        // Reposts
        let nestedRepostsContainer = try itemContainer.nestedContainer(keyedBy: Reposts.self, forKey: .reposts)
        self.reposts = try nestedRepostsContainer.decode(Int.self, forKey: .count)
        
        
    }
}

