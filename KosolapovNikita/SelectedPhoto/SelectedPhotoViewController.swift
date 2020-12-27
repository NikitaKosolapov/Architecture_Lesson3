//
//  PhotoDetailViewController.swift
//  KosolapovNikita
//
//  Created by Nikita on 25/04/2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.

import UIKit
import RealmSwift

class SelectedPhotoViewController: UIViewController {
    
    @IBOutlet private weak var currentImageView: UIImageView! // Setup selected photo
    @IBOutlet private weak var nextImageView: UIImageView! // Calculated value
    @IBOutlet private weak var likeControl: ButtonAndCounterControl! // Animated like counter
    
    var photos: Results<Photo>?
    var profileImages = [UIImage]()
    
    var currentPhotoNumber = Int() // Set flag value for index of profilePhoto
    var interactiveAnimator = UIViewPropertyAnimator(duration: 0.8, curve: .easeInOut) // Left and right swipe animator
    var initialTouchPoint: CGPoint = CGPoint(x: 0, y: 0) // Set starting touch point
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set gestures observers
        panObserver()
        tapObserver()
        
        // Pair ViewController with Realm
        guard let realm = try? Realm() else { return }
        photos = realm.objects(Photo.self)
        
        
        // Setup currentPhotoView
        if let url = photos?[currentPhotoNumber].url {
            currentImageView.loadImageUsingCache(withUrl: url)
        }
    }
    
    // MARK: Observe for pan
    func panObserver() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned))
        self.view.addGestureRecognizer(pan)
    }
    
    // MARK: Add action for pan
    @objc func viewPanned(gesture: UIPanGestureRecognizer) {
        
        let velocity = gesture.velocity(in: self.view) // Define the velocity
        let touchPoint = gesture.location(in: self.view) // Define location of touch
        let translation = gesture.translation(in: self.view) // Define translation
        
        switch gesture.state {
            
        case .began:
            
            guard let photos = photos else { return }
            initialTouchPoint = touchPoint // Define initial touch point as touch point
            
            // Left and right swipe
            if velocity.x < 0 { // From right to left
                
                guard photos.indices.contains(currentPhotoNumber + 1) else { return }
                setupNextPhoto(nextOrPrevious: 1, offset: view.bounds.width)
                setupInteractiveAnimator(translationX: -view.bounds.width, currentPhotoNumber: 1)
                
            } else if velocity.x > 0 { // From left to right
                
                guard photos.indices.contains(currentPhotoNumber - 1) else { return }
                setupNextPhoto(nextOrPrevious: -1, offset: -view.bounds.width)
                setupInteractiveAnimator(translationX: view.bounds.width, currentPhotoNumber: -1)
                
            } else if velocity.y > 0 { // From up to down
                
                interactiveAnimator.addAnimations {
                    UIView.animate(withDuration: 2,
                                   animations: {
                                    self.view.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
                                    self.view.alpha = 0
                    })
                }
                
                interactiveAnimator.addCompletion {_ in
                    self.navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true, completion: nil)
                }
            }
            interactiveAnimator.startAnimation()
            interactiveAnimator.pauseAnimation()
            
        case .changed:
            
            // Down and up swipe
            if touchPoint.y - initialTouchPoint.y > 0 {
                interactiveAnimator.fractionComplete = abs(translation.y / 300)
                
            } else if abs(touchPoint.x - initialTouchPoint.x) > 0 {
                interactiveAnimator.fractionComplete = abs(translation.x / 300)
            }
            
        case .ended, .cancelled:
            
            // Down and up swipe
            if translation.y < 300 && translation.y > abs(translation.x) {
                interactiveAnimator.stopAnimation(true)
                
                UIView.animate(withDuration: 0.3,
                               animations: {
                                self.view.transform = .identity
                                self.view.alpha = 1
                })
            } else  {
                interactiveAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            }
        default:
            return
        }
    }
    
    // MARK: Observe for tap
    func tapObserver() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleTapAction))
        doubleTap.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(doubleTap)
    }
    
    // MARK: Add action for taps
    @objc func handleTapAction(gesture: UITapGestureRecognizer) {
        likeControl.button.sendActions(for: .touchUpInside) // double tap activate like button
    }
    
    // MARK: Change names of images views
    func nextPhotoEqualsCurrentPhoto() { // The next photo that changes the current photo becomes the current photo
        let tmp = nextImageView
        nextImageView = currentImageView
        currentImageView = tmp
    }
    
    // MARK: Setup next or previous photo
    func setupNextPhoto(nextOrPrevious: Int, offset: CGFloat) {
        guard let photos = photos else { return }
        guard photos.indices.contains(currentPhotoNumber + nextOrPrevious) else { return } // check up of error: index out of range
        
        let url = photos[currentPhotoNumber + nextOrPrevious].url
        nextImageView.loadImageUsingCache(withUrl: url)
        
//        nextImageView.image = photos[currentPhotoNumber + nextOrPrevious]
        nextImageView.transform = CGAffineTransform(translationX: offset, y: 0)
    }
    
    // MARK: Setup animation for photos
    func animatePhotos(translationX: CGFloat) {
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       animations: {
                        self.currentImageView.transform = CGAffineTransform(translationX: translationX, y: 0) // depends on swipe direction
        })
        UIView.animate(withDuration: 0.4,
                       delay: 0.2,
                       animations: {
                        self.nextImageView.transform = .identity
        })
    }
    
    // MARK: Setup interativeAnimator
    func setupInteractiveAnimator(translationX: CGFloat, currentPhotoNumber: Int) {
        interactiveAnimator.addAnimations {
            self.animatePhotos(translationX: translationX)
        }
        interactiveAnimator.addCompletion { _ in
            self.nextPhotoEqualsCurrentPhoto()
            self.currentPhotoNumber += currentPhotoNumber
        }
    }
}

