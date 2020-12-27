//
//  CustomPushAnimator.swift
//  KosolapovNikita
//
//  Created by Nikita on 22/04/2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import UIKit

final class CustomPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(duration)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let source = transitionContext.viewController(forKey: .from) else { return }
        guard let destination = transitionContext.viewController(forKey: .to) else { return }
        
        transitionContext.containerView.addSubview(destination.view)
        destination.view.frame = source.view.frame
        
        // Setup view's positions and anchor points
        destination.view.layer.anchorPoint = CGPoint(x: 1, y: 0) // top right corner
        destination.view.layer.position = CGPoint(x: destination.view.frame.width, y: 0)
        
        source.view.layer.anchorPoint = CGPoint(x: 0, y: 0) // top left corner
        source.view.layer.position = CGPoint(x: 0, y: 0)
        
        // Setup start position of destination view
        destination.view.transform = CGAffineTransform(rotationAngle: -.pi / 2)
        
        // Setup animation
        UIView.animate(withDuration: TimeInterval(duration), animations: {
            
            source.view.transform = CGAffineTransform(rotationAngle: .pi / 2)
            destination.view.transform = .identity
            
        }) { finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
}
