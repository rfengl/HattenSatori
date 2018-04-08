//
//  BaseFormController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 23/11/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class BaseController: UIViewController {
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //MARK: - Keyboard Management Methods
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self,
                                       selector: #selector(BaseFormController.keyboardWillBeShown(sender:)),
                                       name: .UIKeyboardWillShow,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(BaseFormController.keyboardWillBeHidden(sender:)),
                                       name: .UIKeyboardWillHide,
                                       object: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var scrollView: UIScrollView?
    var scrollViewRect: CGRect?
    var keyboardSize: CGSize?
    // Called when the UIKeyboardDidShowNotification is sent.
    func keyboardWillBeShown(sender: Notification) {
        let info = sender.userInfo!
        let value = info[UIKeyboardFrameBeginUserInfoKey] as! NSValue
        keyboardSize = value.cgRectValue.size
        updateScrollViewRect()
    }
    
    func getSuperScrollView(view: UIView?) -> UIScrollView? {
        if let view = view {
            if view is UIScrollView {
                guard view is UITextView else {
                    return view as? UIScrollView
                }
            }
            
            return getSuperScrollView(view: view.superview)
        } else {
            return nil
        }
    }
    
    // Called when the UIKeyboardWillHideNotification is sent
    func keyboardWillBeHidden(sender: Notification) {
        self.scrollView?.frame = self.scrollViewRect!
        let aRect: CGRect = self.view.frame
        animateViewMoving(up: false, moveValue: -aRect.origin.y)
        
        self.scrollView?.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        self.scrollView?.scrollIndicatorInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
    }
    
    var activeTextField: UIView?
    func textFieldDidBeginEditing(_ textField: UITextField!) {
        activeTextField = textField
    }
    func textFieldDidEndEditing(_ textField: UITextField!) {
        activeTextField = nil
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        activeTextField = textView
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        activeTextField = nil
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        updateScrollViewRect()
        if let textView = textView as? CustomTextView {
            textView.textViewDidChange(textView)
        }
    }
    
    func updateScrollViewRect() {
        if let keyboardSize = keyboardSize {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                self.updateScrollViewRect(keyboardSize)
            }
        }
    }
    
    func updateScrollViewRect(_ keyboardSize: CGSize) {
        if let activeTextField = self.activeTextField {
            self.scrollView = self.getSuperScrollView(view: activeTextField)
            if let view = self.scrollView {
                if self.scrollViewRect.isEmpty {
                    self.scrollViewRect = view.frame
                }
                
                let keyboardMinY = UIScreen.main.bounds.height - keyboardSize.height
                let scrollViewExtraHeight = self.scrollViewRect!.maxY - keyboardMinY
                
                let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, scrollViewExtraHeight, 0.0)
                
                self.scrollView?.contentInset = contentInsets
                self.scrollView?.scrollIndicatorInsets = contentInsets
                
                var rc = activeTextField.bounds
                rc = activeTextField.convert(rc, to: view)
                self.scrollView?.scrollRectToVisible(rc, animated: true)
            }
        }
    }
    
    func animateViewMoving(up: Bool, moveValue: CGFloat){
        let movementDuration: TimeInterval = 0.3
        let movement = up ? -moveValue : moveValue
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
        UIView.commitAnimations()
    }
}
