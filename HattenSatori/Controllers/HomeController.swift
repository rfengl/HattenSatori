//
//  HomeController.swift
//  HattenSatori
//
//  Created by Re Foong Lim on 07/04/2018.
//  Copyright © 2018 Silvertech Solution. All rights reserved.
//

import Foundation
import AVKit
import AVFoundation

private enum State {
    case closed
    case open
}

extension State {
    var opposite: State {
        switch self {
        case .open: return .closed
        case .closed: return .open
        }
    }
}

class HomeController: BaseController, UIGestureRecognizerDelegate {
    private lazy var popupView: UIView = {
        let view = UIView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        popupView.addGestureRecognizer(tapRecognizer)
        popupView.addGestureRecognizer(panRecognizer)
    }
    
    private var topConstraint = NSLayoutConstraint()
    
    var popupOffset: CGFloat = 30
    var topMenuHeight: CGFloat = 45
    var allMenus: [CustomLabel] = []
    private func layout() {
        popupView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(popupView)
        popupView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        popupView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topConstraint = popupView.topAnchor.constraint(equalTo: view.topAnchor, constant: -popupOffset)
        topConstraint.isActive = true
        popupView.heightAnchor.constraint(equalToConstant: topMenuHeight).isActive = true
        let background = popupView.addBackground(image: #imageLiteral(resourceName: "top-bar"))
        background.frame = CGRect(origin: background.frame.origin, size: CGSize(width: self.view.bounds.width, height: topMenuHeight))
        
        let font = Config.font
        var x: CGFloat = self.view.bounds.width
        let y: CGFloat = (topMenuHeight - font.lineHeight - 5) / 2
        let rightMargin: CGFloat = 30
        allMenus = []
        for menu in MenuItem.items.reversed() {
            let width = menu.rawValue.width(with: font.lineHeight, font: font)
            x -= width + rightMargin
            let menuView = UIView(frame: CGRect(x: x, y: y, width: width, height: font.lineHeight)).initView()
            let field = CustomLabel(frame: CGRect(x: 0, y: 0, width: width, height: font.lineHeight)).initView()
            menuView.addSubview(field)
            field.textColor = HattenColor.white.color
            field.text = menu.rawValue
            field.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self, action: #selector(menuTapped(sender:)))
            gesture.delegate = self
            field.addGestureRecognizer(gesture)
            popupView.addSubview(menuView)
            allMenus.append(field)
            menuView.clipsToBounds = false
            
            if menu.subMenu.count > 0 {
                let subMenuView = UIView(frame: CGRect(x: -rightMargin, y: y + menuView.bounds.height - 5, width: 200, height: CGFloat(menu.subMenu.count * 30)))
                let subMenuMargin: CGFloat = 10
                var subMenuY = subMenuMargin
                for subMenu in menu.subMenu {
                    let label = CustomLabel(frame: CGRect(x: subMenuMargin, y: subMenuY, width: 200, height: font.lineHeight)).initView()
                    label.text = subMenu.rawValue.beautify()
                    label.textColor = HattenColor.orange.color
                    subMenuView.addSubview(label)
                    
                    subMenuY += label.font.lineHeight + subMenuMargin
                    
                    label.isUserInteractionEnabled = true
                    let gesture = UITapGestureRecognizer(target: self, action: #selector(subMenuTapped(sender:)))
                    gesture.delegate = self
                    label.addGestureRecognizer(gesture)
                }
                menuView.addSubview(subMenuView)
                subMenuView.tag = 99
                subMenuView.isHidden = true
                subMenuView.backgroundColor = HattenColor.orangeBackground.color
                subMenuView.adjustSize(extendRight: subMenuMargin, extendBottom: subMenuMargin)
            }
        }
    }
    
    func menuTapped(sender: UIGestureRecognizer) {
        resetMenu()
        
        if let label = sender.view as? CustomLabel {
            label.textColor = HattenColor.yellow.color
            if let menuItem = MenuItem(rawValue: label.text!) {
                if menuItem.subMenu.count > 0 {
                    if let subMenu = label.superview?.viewWithTag(99) {
                        subMenu.isHidden = false
                    }
                }
            }
        }
    }
    
    func subMenuTapped(sender: UIGestureRecognizer) {
        resetMenu()
        
        if let label = sender.view as? CustomLabel {
            label.textColor = HattenColor.yellow.color
        }
    }
    
    func resetMenu(){
        for menu in allMenus {
            if let views: [CustomLabel] = menu.superview?.getAllViews() {
                for view in views {
                    view.textColor = HattenColor.orange.color
                }
            }
            if let subMenu = menu.superview?.viewWithTag(99) {
                subMenu.isHidden = true
            }
            menu.textColor = HattenColor.white.color
        }
    }
    
    private var currentState: State = .closed
    
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(popupViewTapped(recognizer:)))
        return recognizer
    }()
    
    private lazy var panRecognizer: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(popupViewPanned(recognizer:)))
        return recognizer
    }()
    
    @objc private func popupViewTapped(recognizer: UITapGestureRecognizer) {
        resetMenu()
        _ = animateTransitionIfNeeded(to: currentState.opposite, duration: 1)
    }
    
    private var animationProgress: CGFloat = 0
    
    private var transitionAnimator: UIViewPropertyAnimator? = nil
    private func animateTransitionIfNeeded(to: State, duration: TimeInterval) -> UIViewPropertyAnimator? {
        transitionAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1, animations: {
            switch to {
            case .open:
                self.topConstraint.constant = 0
            case .closed:
                self.topConstraint.constant = -self.popupOffset
            }
            self.view.layoutIfNeeded()
        })
        transitionAnimator?.addCompletion { position in
            switch position {
            case .start:
                self.currentState = to.opposite
            case .end:
                self.currentState = to
            case .current:
                ()
            }
            switch self.currentState {
            case .open:
                self.topConstraint.constant = 0
            case .closed:
                self.topConstraint.constant = -self.popupOffset
            }
        }
        transitionAnimator?.startAnimation()
        
        return transitionAnimator
    }
    
    @objc private func popupViewPanned(recognizer: UIPanGestureRecognizer) {
        resetMenu()
        
        switch recognizer.state {
        case .began:
            self.transitionAnimator = self.animateTransitionIfNeeded(to: currentState.opposite, duration: 1.5)
            self.animationProgress = self.transitionAnimator!.fractionComplete
            self.transitionAnimator?.pauseAnimation()
        case .changed:
            let translation = recognizer.translation(in: popupView)
            var fraction = -translation.y / popupOffset
            if currentState == .open { fraction *= -1 }
            self.transitionAnimator?.fractionComplete = fraction + animationProgress
        case .ended:
            self.transitionAnimator?.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        default:
            ()
        }
    }
    
    
}
