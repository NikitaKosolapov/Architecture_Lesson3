//
//  PhotoAdapter.swift
//  KosolapovNikita
//
//  Created by Nikita on 27.12.2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import Foundation
import RealmSwift

final class PhotoAdapter {

    private var realmNotificationToken: NotificationToken?

    func getPhotos(for id: Int, completion: @escaping ([PhotoModel]) -> Void) {

        guard let realm = try? Realm()else { return }
        let realmPhotos = realm.objects(Photo.self)

        var photos: [PhotoModel] = []

        realmPhotos.forEach { photo in
            photos.append(self.photo(from: photo))
        }
        completion(photos)

        self.realmNotificationToken?.invalidate()

        let token = realmPhotos.observe { [weak self] changes in
            guard let self = self else { return }

            switch changes {
            case .update(let realmPhotos, _, _, _):
                photos = []
                
                realmPhotos.forEach { photo in
                    photos.append(self.photo(from: photo))
                }
                self.realmNotificationToken?.invalidate()
                completion(photos)
            case let .error(error):
                fatalError("\(error)")
            case .initial:
                break
            }
        }
        self.realmNotificationToken = token
        MakeRequest.shared.getPhotosOfSelectedFriend(ownerId: id)
    }

    private func photo(from rlmPhoto: Photo) -> PhotoModel {
        return PhotoModel(url: rlmPhoto.url,
                          text: rlmPhoto.text,
                          likes: rlmPhoto.likes,
                          reposts: rlmPhoto.reposts,
                          height: rlmPhoto.height,
                          width: rlmPhoto.width)
    }
}

