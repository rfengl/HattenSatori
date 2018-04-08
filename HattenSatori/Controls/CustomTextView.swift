//
//  CustomTextView.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 17/11/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class CustomTextView: UITextView, Required, UITextViewDelegate {
    override func initView() -> CustomTextView {
        if let font = self.font {
            self.font = font.withSize(Config.editFontSize)
        } else {
            self.font = Config.editFont
        }
        self.tintColor = HattenColor.gray700.color
        textContainerInset = .init(top: 2, left: 2, bottom: 2, right: 2)
        textContainer.lineFragmentPadding = 0
        
        if self.delegate.isEmpty {
            self.delegate = self
        }
        return self
    }
    
    override func becomeFirstResponder() -> Bool {
        initToolbar()
        return super.becomeFirstResponder()
    }
    
    var placeholderLabel: CustomLabel?
    var mPlaceholder: String?
    var placeholder: String {
        get {
            return mPlaceholder ?? ""
        }
        set {
            mPlaceholder = newValue
            
            DispatchQueue.main.async {
                self.placeholderLabel?.removeFromSuperview()
                self.placeholderLabel = CustomLabel(frame: CGRect(x: self.textContainerInset.left, y: self.textContainerInset.top, width: self.bounds.width - self.textContainerInset.left - self.textContainerInset.right, height: Config.lineHeight - self.textContainerInset.top
                    - self.textContainerInset.bottom)).initView()
                self.placeholderLabel?.lineBreakMode = .byWordWrapping
                self.placeholderLabel?.numberOfLines = 0
                self.placeholderLabel?.text = newValue
                self.placeholderLabel?.font = self.font
                self.placeholderLabel?.textColor = HattenColor.gray500.color
                self.placeholderLabel?.isHidden = !self.text.isEmpty
                self.addSubview(self.placeholderLabel!)
                _ = self.placeholderLabel?.fitHeight()
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel?.isHidden = !textView.text.isEmpty
    }
    
    func initToolbar() {
        var doneButtonLabel = "Next"
        
        var nextField = self.nextField
        while nextField != nil
        {
            if let textField = nextField as? CustomTextField {
                if textField.isEnabled {
                    break
                }
                else {
                    nextField = textField.nextField
                }
            }
            else if let textField = nextField as? CustomTextView {
                if textField.isHidden == false {
                    break
                }
                else {
                    nextField = textField.nextField
                }
            }
        }
        
        if self.doneButton != nil {
            doneButtonLabel = "Done"
        }
        
        let closeButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(CustomTextView.closeTextField))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        var title = self.placeholder
        if title.characters.count > 50 {
            title = title.substring(to: title.index(title.startIndex, offsetBy: 50))
        }
        let titleItem = UIBarButtonItem(title: title, style: .plain, target: self, action: nil)
        titleItem.tintColor = HattenColor.gray800.color
        
        let doneButton = UIBarButtonItem(title: doneButtonLabel, style: .plain, target: self, action: #selector(CustomTextView.doneTextField))
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = HattenColor.accent.color
        toolBar.sizeToFit()
        toolBar.setItems([closeButton, spaceButton, titleItem, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.inputAccessoryView = toolBar
    }
    
    //    public var underlineOnly: Bool = true
    //    override func draw(_ rect: CGRect) {
    //        if underlineOnly {
    //            let startingPoint = CGPoint(x: rect.minX, y: rect.maxY)
    //            let endingPoint = CGPoint(x: rect.maxX, y: rect.maxY)
    //
    //            let path = UIBezierPath()
    //
    //            path.move(to: startingPoint)
    //            path.addLine(to: endingPoint)
    //            path.lineWidth = 2.0
    //
    //            tintColor.setStroke()
    //
    //            path.stroke()
    //        } else {
    //            super.draw(rect)
    //        }
    //    }
    
    func closeTextField(){
        self.resignFirstResponder()
    }
    
    func doneTextField() {
        if self.nextField != nil
        {
            if let textField = self.nextField as? CustomTextField {
                if textField.isEnabled == false {
                    textField.doneTextField()
                    return
                }
            }
            else if let textField = self.nextField as? CustomTextView {
                if textField.isHidden {
                    textField.doneTextField()
                    return
                }
            }
            
            self.nextField?.becomeFirstResponder()
        }
        else if self.doneButton != nil && self.doneButton is UIControl
        {
            closeTextField()
            (self.doneButton as! UIControl).sendActions(for: .touchUpInside)
        }
        else
        {
            closeTextField()
        }
    }
    
    private var mIsRequired: Bool = false
    var isRequired: Bool {
        get {
            return mIsRequired
        }
        set {
            mIsRequired = newValue
        }
    }
    
    
}
