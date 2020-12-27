//
//  AnimationViewController.swift
//  KosolapovNikita
//
//  Created by Nikita on 14/04/2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import UIKit

class AnimationViewController: UIViewController {
    
    @IBOutlet private weak var circle1ImageView: UIImageView!
    @IBOutlet private weak var circle2ImageView: UIImageView!
    @IBOutlet private weak var circle3ImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let circleArray = [circle1ImageView, circle2ImageView, circle3ImageView]
        
        for circle in circleArray {
            circle?.alpha = 0
        }
        
        runAnimation()
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 2.6, execute: {
            for circle in circleArray {
                circle!.layer.removeAllAnimations()
            }
            self.performSegue(withIdentifier: "showLogin", sender: self)
        })
    }
    
    func animation(delay: Double, circle: UIImageView) {
        UIView.animate(
            withDuration: 0.5,
            delay: delay,
            options: [.repeat, .autoreverse],
            animations: {
                circle.alpha = 1
        })
    }
    
    func runAnimation() {
        animation(delay: 0, circle: circle1ImageView)
        animation(delay: 0.1, circle: circle2ImageView)
        animation(delay: 0.2, circle: circle3ImageView)
    }
}
