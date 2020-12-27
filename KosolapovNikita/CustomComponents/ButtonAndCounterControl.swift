//
//  LikeControl.swift
//  KosolapovNikita
//
//  Created by Nikita on 02/04/2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import UIKit

@IBDesignable class ButtonAndCounterControl: UIControl {
    
    public let button = UIButton()
    let label = UILabel()
    var stackView = UIStackView()
    public var counter: Int {
        didSet {
            self.setupView()
        }
    }
    var buttonIsSelected = false
    
    @IBInspectable var emptyImage: UIImage? {
        didSet {
            self.button.setImage(emptyImage, for: .normal)
        }
    }
    @IBInspectable var emptyColor: UIColor? {
        didSet {
            self.button.tintColor = emptyColor
        }
    }
    @IBInspectable var fillImage: UIImage?
    @IBInspectable var fillColor: UIColor?
    
    override init(frame: CGRect) {
        self.counter = 0
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.counter = 0
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        
        button.backgroundColor = .clear
//        button.addTarget(self, action: #selector(customButtonAction(_:)), for: .touchUpInside)
        
        label.textColor = .lightGray
        label.text = "\(counter)"
        
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(button)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        self.addSubview(stackView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }
    
    func setupButton(color: UIColor, image: UIImage, counter: Int, buttonIsSelected: Bool, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat) {
        
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: usingSpringWithDamping,
                       initialSpringVelocity: initialSpringVelocity,
                       options: [],
                       animations: {
                        self.button.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                        self.button.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
        
        UIView.transition(with: label,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.label.text = String(counter)
        })
        button.setImage(image, for: .normal)
        button.tintColor = color
        label.textColor = color
        label.text = String(counter)
        self.counter = counter
        self.buttonIsSelected = buttonIsSelected
    }
    
    @objc func customButtonAction(_ sender: UIButton) {
        if buttonIsSelected == false {
            setupButton(color: fillColor!, image: fillImage!, counter: 1, buttonIsSelected: true, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6)
        } else {
            setupButton(color: emptyColor!, image: emptyImage!, counter: 0, buttonIsSelected: false, usingSpringWithDamping: 1, initialSpringVelocity: 0)
        }
    }
}
