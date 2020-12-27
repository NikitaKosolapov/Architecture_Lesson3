//
//  NewsTableViewCell.swift
//  KosolapovNikita
//
//  Created by Nikita on 12/04/2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import UIKit

@IBDesignable class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var userImage: CircleImageWithShadowView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var likeControl: ButtonAndCounterControl!
    @IBOutlet private weak var commentControl: ButtonAndCounterControl!
    @IBOutlet private weak var repostsControl: ButtonAndCounterControl!
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .medium
        dateFormatter.timeZone = .current
        return dateFormatter
    }()
    
    func configure(with viewModel: NewsViewModel) {
        userImage.imageView.loadImageUsingCache(withUrl: viewModel.userImage)
        nameLabel.text = viewModel.nameText
        dateLabel.text = viewModel.dateText
        descriptionLabel.text = viewModel.newsText
        photoImageView.loadImageUsingCache(withUrl: viewModel.newsPhoto)
        likeControl.counter = viewModel.likesCount
        commentControl.counter = viewModel.comentsCount
        repostsControl.counter = viewModel.repostsCount
    }
}
