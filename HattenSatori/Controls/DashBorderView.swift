//
//  DashBorderView.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 19/10/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class DashBorderView: BorderView {
    override func initView() -> DashBorderView {
        _ = super.initView()
        
        DispatchQueue.main.async {
            self.viewBorder.lineDashPattern = [8, 6]
            self.viewBorder.lineWidth = 1
        }
        
        return self
    }
}
