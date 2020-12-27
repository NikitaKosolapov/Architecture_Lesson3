//
//  VKService.swift
//  KosolapovNikita
//
//  Created by Nikita on 05.05.2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift
import SwiftyJSON

class MakeRequest {
    
    // Define singleton MakeRequest
    static let shared = MakeRequest()
    private init() {}
    
    // define initial API url
    let initialUrl = "https://api.vk.com/method"
    
    // get current token
    let accessToken = Session.shared.token
    
    // define default parameters
    //    static let defaultParameters = ["access_token": self.accessToken]
}

extension MakeRequest {
    func getPhotosOfSelectedFriend(ownerId: Int) {
        let parameters: Parameters = ["access_token": Session.shared.token,
                                      "extended": "1",
                                      "owner_id": ownerId,
                                      "album_id": "profile",
                                      "v": "5.103"]
        let path = "/photos.get"
        let url = initialUrl + path
        
        DispatchQueue.global().async {
            AF.request(url, method: .get, parameters: parameters).responseData { [weak self] response in
                guard let data = response.value else { return }
                do {
                    let decoder = JSONDecoder()
                    let decodedResponse = try decoder.decode(MainPhotosResponse.self, from: data).response.items
                    self?.saveData(decodedResponse)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func getMyGroupsList() {
        let parameters: Parameters = ["access_token": Session.shared.token,
                                      "fields": "activity",
                                      "extended": "1",
                                      "v": "5.103"]
        let path = "/groups.get"
        let url = initialUrl + path
        
        DispatchQueue.global().async {
            AF.request(url, method: .get, parameters: parameters).responseData { [weak self] response in
                guard let data = response.value else { return }
                do {
                    let decoder = JSONDecoder()
                    let decodedResponse = try decoder.decode(MainMyGroupsResponse.self, from: data).response.items
                    self?.saveData(decodedResponse)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func getAllGroupsList(request: String, completion: @escaping ([AllGroup]) -> Void) {
        let parameters: Parameters = ["access_token": Session.shared.token,
                                      "q": request,
                                      "type": "group",
                                      "v": "5.103"]
        let path = "/groups.search"
        let url = initialUrl + path
        
        DispatchQueue.global().async {
            AF.request(url, method: .get, parameters: parameters).responseData { response in
                guard let data = response.value else { return }
                do {
                    let decoder = JSONDecoder()
                    let decodedResponse = try decoder.decode(AllGroupsResponse.self, from: data).response.items
                    completion(decodedResponse)
                } catch {
                    print(error)
                }
            }
        }
    }

    func getNews(startTime: Date? = nil, startFrom: String = "", completion: @escaping ([NewsItem], String?) -> Void) {
        var parameters: Parameters = ["access_token": Session.shared.token,
                                      "filters": "post",
                                      "count": "10",
                                      "v": "5.58",
                                      "start_from": startFrom]
        let path = "/newsfeed.get"
        let url = initialUrl + path
        
        if let startTime = startTime {
            parameters["start_time"] = startTime
        }
        
        DispatchQueue.global().async {
            AF.request(url, method: .get, parameters: parameters).responseData { response in
                var news: [NewsItem] = []
                
                switch response.result {
                    
                case .success(let value):
                    let json = JSON(value)
                    news = self.parseNews(json)
                    
                    DispatchQueue.main.async {
                        completion(news, "")
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func parseNews(_ json: JSON) -> [NewsItem] {
        let profiles = json["response"]["profiles"]
            .arrayValue
            .map{NewsItemProfile(json: $0)}
        let groups = json["response"]["groups"]
            .arrayValue
            .map{NewsItemProfile(json: $0)}
        let allProfiles = profiles + groups
        
        let items = json["response"]["items"]
            .arrayValue
            .map{NewsItem(json: $0)}
        for (index, item) in items.enumerated() {
            let profile = allProfiles.first(where: { abs(item.sourceId) == $0.id })
            items[index].profile = profile
        }
        return items
    }
    
    func saveData<T: Object & Decodable>(_ arrayOfObjects: [T]){
        do {
            let realm = try Realm()
            let oldObject = realm.objects(T.self)
            realm.beginWrite()
            realm.delete(oldObject)
            realm.add(arrayOfObjects)
            try realm.commitWrite()
            print(realm.configuration.fileURL!)
        } catch {
            print(error)
        }
    }
}
