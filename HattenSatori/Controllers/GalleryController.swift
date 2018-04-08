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
        
        let clickArea = self.view.bounds.width / 3
        let leftClick = UIView(frame: CGRect(x: 0, y: 50, width: clickArea, height: self.view.bounds.height - 50)).initView()
        leftClick.isUserInteractionEnabled = true
        let leftGesture = UITapGestureRecognizer(target: self, action: #selector(prevImage))
        leftClick.addGestureRecognizer(leftGesture)
        
        let rightClick = UIView(frame: CGRect(x: self.view.bounds.width - clickArea, y: 50, width: clickArea, height: self.view.bounds.height - 50)).initView()
        rightClick.isUserInteractionEnabled = true
        let rightGesture = UITapGestureRecognizer(target: self, action: #selector(nextImage))
        rightClick.addGestureRecognizer(rightGesture)
        
        let centerClick = UIView(frame: CGRect(x: clickArea, y: 50, width: clickArea, height: self.view.bounds.height - 50)).initView()
        centerClick.isUserInteractionEnabled = true
        let centerGesture = UITapGestureRecognizer(target: self, action: #selector(pauseImage))
        centerClick.addGestureRecognizer(centerGesture)
        
        self.view.addSubview(leftClick)
        self.view.addSubview(rightClick)
        self.view.addSubview(centerClick)
        
        super.viewDidLoad()
        
        let imageNames = Bundle.main.paths(forResourcesOfType: "jpg", inDirectory: "Media")
        var images: [UIImage] = []
        for name in imageNames {
            if let image = UIImage(named: name) {
                images.append(image)
            }
        }
        self.images = images
    }
    
    func prevImage() {
        showImage(step: -1, duration: 0.5)
    }
    
    func nextImage() {
        showImage(step: 1, duration: 0.5)
    }
    
    func pauseImage() {
        pauseTheShow = !pauseTheShow
        if !pauseTheShow {
            resumeAnimation()
        } else {
            pauseAnimation()
        }
    }
    
    func pauseAnimation(){
        if let layer = self.presentationLayer {
            let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
            layer.speed = 0.0
            layer.timeOffset = pausedTime
        }
    }
    
    func resumeAnimation(){
        if let layer = self.presentationLayer {
            let pausedTime = layer.timeOffset
            layer.speed = 1.0
            layer.timeOffset = 0.0
            layer.beginTime = 0.0
            let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
            layer.beginTime = timeSincePause
        }
    }
    
    let slidingDuration: CFTimeInterval = 8
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pauseTheShow = false
        showImage(step: 0, duration: slidingDuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        pauseTheShow = true
    }
    
    var pauseTheShow: Bool = false
    func showImage(step: Int, duration: CFTimeInterval) {
        if pauseTheShow {
            return
        }
        
        displayedImage = (displayedImage + step) % images.count
        if displayedImage < 0 {
            displayedImage = 0
        }
        
        let image = UIImageView(frame: self.view.bounds)
        image.contentMode = .scaleAspectFill
        image.image = images[displayedImage]
        self.imageHolder.addSubview(image)
        
        if step == 0 {
            fadeIn(view: image)
        } else if duration < 1 {
            if step < 0 {
                fromLeftToRight(view: image, duration: duration)
                nextShouldFromLeft = false
            } else {
                fromRightToLeft(view: image, duration: duration)
                nextShouldFromLeft = true
            }
        } else {
            if let size = image.image?.size {
                let bounds = self.imageHolder.bounds
                if size.width / bounds.width > size.height / bounds.height {
                    if nextShouldFromLeft {
                        fromLeftToRight(view: image, duration: duration)
                    } else {
                        fromRightToLeft(view: image, duration: duration)
                    }
                    nextShouldFromLeft = !nextShouldFromLeft
                } else {
                    if nextShouldFromTop {
                        fromTopToBottom(view: image, duration: duration)
                    } else {
                        fromBottomToTop(view: image, duration: duration)
                    }
                    nextShouldFromTop = !nextShouldFromTop
                }
            }
        }
    }
    
    var presentationLayer: CALayer?
    func fadeIn(view: UIView) {
        let fadeAnim = CABasicAnimation(keyPath: "opacity")
        fadeAnim.fromValue = 0
        fadeAnim.toValue = 1
        fadeAnim.duration = 4
        fadeAnim.delegate = self
        view.layer.add(fadeAnim, forKey: "opacity")
        view.layer.opacity = 1
        
        presentationLayer = view.layer
    }
    
    func fromLeftToRight(view: UIView, duration: CFTimeInterval) {
        let transition = CATransition()
        transition.duration = duration
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        transition.delegate = self
        view.layer.add(transition, forKey: nil)
        
        presentationLayer = view.layer
    }
    
    func fromRightToLeft(view: UIView, duration: CFTimeInterval) {
        let transition = CATransition()
        transition.duration = duration
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        transition.delegate = self
        view.layer.add(transition, forKey: nil)
        
        presentationLayer = view.layer
    }
    
    func fromTopToBottom(view: UIView, duration: CFTimeInterval) {
        let transition = CATransition()
        transition.duration = duration
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        transition.delegate = self
        view.layer.add(transition, forKey: nil)
        
        presentationLayer = view.layer
    }
    
    func fromBottomToTop(view: UIView, duration: CFTimeInterval) {
        let transition = CATransition()
        transition.duration = duration
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromBottom
        transition.delegate = self
        view.layer.add(transition, forKey: nil)
        
        presentationLayer = view.layer
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        while self.imageHolder.subviews.count > 2 {
            self.imageHolder.subviews.first?.removeFromSuperview()
        }
        
        if anim.duration > 1 {
            showImage(step: 1, duration: slidingDuration)
        }
    }
}
