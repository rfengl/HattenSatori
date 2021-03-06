//
//  BorderView.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 28/07/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class BorderView: UIView {
    var viewBorder: CAShapeLayer!
    
    override func initView() -> BorderView {
        _ = super.initView()
        
        DispatchQueue.main.async {
            self.viewBorder = CAShapeLayer()
            self.viewBorder.strokeColor = HattenColor.gray500.color.cgColor
            self.viewBorder.fillColor = HattenColor.transparent.color.cgColor
            self.viewBorder.frame = self.bounds
            self.viewBorder.path = UIBezierPath(rect: self.bounds).cgPath
            self.layer.addSublayer(self.viewBorder)
        }
        
        return self
    }
}
