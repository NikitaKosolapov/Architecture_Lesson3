//
//  ProfileImageView.swift
//  KosolapovNikita
//
//  Created by Nikita on 03/04/2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import UIKit

@IBDesignable class CircleImageWithShadowView: UIView {
    
    @IBInspectable var shadowOpacity: Float = 0.8 {
        didSet {
            updateShadowOpacity()
        }
    }
    
    @IBInspectable var shadowColor: UIColor = UIColor.black {
        didSet {
            updateShadowColor()
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 2 {
        didSet {
            updateShadowRadius()
        }
    }
    
    var imageView: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 2, y: 2, width: 46, height: 46))
        image.layer.cornerRadius = 23
        image.layer.masksToBounds = true
        return image
    }()
    
    let shadowView: UIImageView = {
        let shadow = UIImageView(frame: CGRect(x: 2, y: 2, width: 46, height: 46))
        shadow.layer.cornerRadius = 23
        shadow.backgroundColor = .white
        shadow.layer.shadowOffset = CGSize(width: 1, height: 1)
        shadow.layer.masksToBounds = false
        return shadow
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    func updateShadowOpacity() {
        self.shadowView.layer.shadowOpacity = shadowOpacity
    }
    
    func updateShadowColor() {
        self.shadowView.layer.shadowColor = shadowColor.cgColor
    }
    
    func updateShadowRadius() {
        self.shadowView.layer.shadowRadius = shadowRadius
    }
    
    func setupViews() {
        self.addSubview(shadowView)
        self.addSubview(imageView)
    }
}
