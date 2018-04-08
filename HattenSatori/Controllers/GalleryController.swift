//
//  GalleryController.swift
//  HattenSatori
//
//  Created by Re Foong Lim on 08/04/2018.
//  Copyright © 2018 Silvertech Solution. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

class GalleryController: BaseMenuController, CAAnimationDelegate {
    override func getMenu() -> MenuItem? {
        return MenuItem.Gallery
    }
    
    override func getSubMenu() -> SubMenuItem? {
        return nil
    }
    
    var imageHolder: UIView!
    var images: [UIImage] = []
    var displayedImage = 0
    var nextShouldFromLeft: Bool = true
    var nextShouldFromTop: Bool = true
    
    override func viewDidLoad() {
        imageHolder = UIView(frame: self.view.bounds)
        self.view.addSubview(imageHolder)
        
        super.viewDidLoad()
        
        let imageNames = Bundle.main.paths(forResourcesOfType: "jpg", inDirectory: "Media")
        var images: [UIImage] = []
        for name in imageNames {
            if let image = UIImage(named: name) {
                images.append(image)
            }
        }
        self.images = images
        
        showImage()
    }
    
    var isFirstTime: Bool = true
    func showImage() {
        displayedImage = displayedImage % images.count
        
        let image = UIImageView(frame: self.view.bounds)
        image.contentMode = .scaleAspectFill
        image.image = images[displayedImage]
        
        if isFirstTime {
            fadeIn(view: image)
            isFirstTime = false
        } else {
            if let size = image.image?.size {
                let bounds = self.imageHolder.bounds
                if size.width / bounds.width > size.height / bounds.height {
                    if nextShouldFromLeft {
                        fromLeftToRight(view: image)
                    } else {
                        fromRightToLeft(view: image)
                    }
                    nextShouldFromLeft = !nextShouldFromLeft
                } else {
                    if nextShouldFromTop {
                        fromTopToBottom(view: image)
                    } else {
                        fromBottomToTop(view: image)
                    }
                    nextShouldFromTop = !nextShouldFromTop
                }
            }
        }
        
        self.imageHolder.addSubview(image)
    }
    
    func fadeIn(view: UIView) {
        let fadeAnim = CABasicAnimation(keyPath: "opacity");
        fadeAnim.fromValue = 0
        fadeAnim.toValue = 1
        fadeAnim.duration = 4
        fadeAnim.delegate = self
        view.layer.add(fadeAnim, forKey: "opacity")
        view.layer.opacity = 1
    }
    
    let slidingDuration: CFTimeInterval = 8
    func fromLeftToRight(view: UIView) {
        let transition = CATransition()
        transition.duration = slidingDuration
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        transition.delegate = self
        view.layer.add(transition, forKey: nil)
    }
    
    func fromRightToLeft(view: UIView) {
        let transition = CATransition()
        transition.duration = slidingDuration
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        transition.delegate = self
        view.layer.add(transition, forKey: nil)
    }
    
    func fromTopToBottom(view: UIView) {
        let transition = CATransition()
        transition.duration = slidingDuration
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        transition.delegate = self
        view.layer.add(transition, forKey: nil)
    }
    
    func fromBottomToTop(view: UIView) {
        let transition = CATransition()
        transition.duration = slidingDuration
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromBottom
        transition.delegate = self
        view.layer.add(transition, forKey: nil)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if self.imageHolder.subviews.count > 1 {
            self.imageHolder.subviews.first?.removeFromSuperview()
        }
        displayedImage = displayedImage + 1
        showImage()
    }
}
