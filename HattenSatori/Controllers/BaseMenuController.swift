//
//  BaseMenuController.swift
//  HattenSatori
//
//  Created by Re Foong Lim on 08/04/2018.
//  Copyright © 2018 Silvertech Solution. All rights reserved.
//

import Foundation
import UIKit

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

class BaseMenuController: BaseController {
    private lazy var popupView: UIView = {
        let view = UIView()
        return view
    }()
    
    func getMenu() -> MenuItem? {
        return nil
    }
    
    func getSubMenu() -> SubMenuItem? {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        popupView.addGestureRecognizer(tapRecognizer)
        popupView.addGestureRecognizer(panRecognizer)
    }
    
    private var topConstraint = NSLayoutConstraint()
    
    var allMenus: [CustomLabel] = []
    var popupOffset: CGFloat!
    private func layout() {
        let font = Config.font
        let verticalMargin: CGFloat = 10
        let topMenuHeight: CGFloat = font.lineHeight + verticalMargin * 2 + 5
        popupOffset = font.lineHeight + verticalMargin
        
        popupView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(popupView)
        popupView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        popupView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topConstraint = popupView.topAnchor.constraint(equalTo: view.topAnchor, constant: -popupOffset)
        topConstraint.isActive = true
        popupView.heightAnchor.constraint(equalToConstant: topMenuHeight).isActive = true
        let background = popupView.addBackground(image: #imageLiteral(resourceName: "top-bar"))
        background.frame = CGRect(origin: background.frame.origin, size: CGSize(width: self.view.bounds.width, height: topMenuHeight))
        
        var x: CGFloat = self.view.bounds.width
        let y: CGFloat = verticalMargin
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
            field.addGestureRecognizer(gesture)
            popupView.addSubview(menuView)
            allMenus.append(field)
            
            if menu.subMenu.count > 0 {
                let subMenuMargin: CGFloat = 10
                let subMenuWidth: CGFloat = 200
                var subMenuY: CGFloat = 0
                let subMenuView = UIView(frame: CGRect(x: subMenuMargin - rightMargin, y: y + menuView.bounds.height - 5, width: 200, height: CGFloat(menu.subMenu.count * 30)))
                for subMenu in menu.subMenu {
                    let labelView = SubMenuView(frame: CGRect(x: 0, y: subMenuY, width: subMenuWidth, height: font.lineHeight + subMenuMargin * 2)).initView()
                    let label = CustomLabel(frame: CGRect(x: subMenuMargin, y: subMenuMargin, width: subMenuWidth - subMenuMargin * 2, height: font.lineHeight)).initView()
                    label.text = subMenu.rawValue.beautify()
                    label.textColor = HattenColor.orange.color
                    labelView.addSubview(label)
                    subMenuView.addSubview(labelView)
                    
                    subMenuY += labelView.bounds.height
                }
                menuView.addSubview(subMenuView)
                subMenuView.tag = 99
                subMenuView.isHidden = true
                subMenuView.backgroundColor = HattenColor.orangeBackground.color
                subMenuView.adjustSize()
            }
        }
    }
    
    class SubMenuView: UIView {
        override func initView() -> UIView {
            return super.initView()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            for menu in allMenus {
                for subMenu: SubMenuView in menu.superview!.getAllViews() {
                    if subMenu.superview?.isHidden == false {
                        let position = touch.location(in: subMenu.superview)
                        if subMenu.frame.contains(position) {
                            resetMenu()
                            if let label: CustomLabel = subMenu.getView() {
                                gotoPage(name: label.text!)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func menuTapped(sender: UIGestureRecognizer) {
        resetMenu()
        
        if let label = sender.view as? CustomLabel {
            if let name = label.text {
                if let menuItem = MenuItem(rawValue: name) {
                    if menuItem.subMenu.count > 0 {
                        label.textColor = HattenColor.yellow.color
                        if let subMenu = label.superview?.viewWithTag(99) {
                            subMenu.isHidden = false
                        }
                    } else {
                        gotoPage(name: name)
                    }
                }
            }
        }
    }
    
    func gotoPage(name: String) {
        if let subMenu = getSubMenu() {
            if subMenu.rawValue.beautify() == name {
                return
            }
        } else if let menu = getMenu() {
            if menu.rawValue == name {
                return
            }
        }
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name)
        present(viewController, animated: true, completion: nil)
    }
    
    func resetMenu(){
        let menuItem = getMenu()
        let subMenuItem = getSubMenu()
        
        for menu in allMenus {
            if menu.text == menuItem?.rawValue {
                menu.textColor = HattenColor.yellow.color
            } else {
                menu.textColor = HattenColor.white.color
            }
            
            if let subMenu = menu.superview?.viewWithTag(99) {
                subMenu.isHidden = true
            }
            
            if let views: [SubMenuView] = menu.superview?.getAllViews() {
                for view in views {
                    if let label: CustomLabel = view.getView() {
                        if label.text == subMenuItem?.rawValue.beautify() {
                            view.backgroundColor = HattenColor.orangeHighlight.color
                            label.textColor = HattenColor.yellow.color
                        } else {
                            label.textColor = HattenColor.orange.color
                        }
                    }
                }
            }
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
