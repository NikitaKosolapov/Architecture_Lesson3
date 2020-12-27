//
//  NewsViewModelFactory.swift
//  KosolapovNikita
//
//  Created by Nikita on 27.12.2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import UIKit

final class NewsViewModelFactory {
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .medium
        dateFormatter.timeZone = .current
        return dateFormatter
    }()

    func constructViewModels(from news: [NewsItem]) -> [NewsViewModel] {
        return news.compactMap(self.viewModel)
    }

    private func viewModel(from news: NewsItem) -> NewsViewModel {

        let userImage = news.profile?.photoUrl ?? ""

        let nameText = news.profile?.name ?? ""

        let dateText = NewsViewModelFactory.dateFormatter.string(from: news.date)

        let newsText = news.text

        let newsPhoto = news.photoUrl

        let likeCounter = news.likesCount

        let commentCounter = news.commentsCount

        let repostsCounter = news.repostsCount

        return NewsViewModel(userImage: userImage,
                             nameText: nameText,
                             dateText: dateText,
                             newsText: newsText,
                             newsPhoto: newsPhoto,
                             likesCount: likeCounter,
                             comentsCount: commentCounter,
                             repostsCount: repostsCounter)
    }
}
