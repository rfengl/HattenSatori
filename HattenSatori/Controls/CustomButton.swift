//
//  CustomButton.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 24/11/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class CustomButton: UIButton {
    override func initView() -> CustomButton {
        _ = super.initView()
        
        if self.backgroundColor.isEmpty {
            self.backgroundColor = HattenColor.primary.color
        }
        
        self.tintColor = HattenColor.white.color
        self.titleLabel?.font = self.titleLabel?.font.withSize(Config.buttonFontSize)
        
        return self
    }
}
