//
//  BaseFormController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 23/11/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class BaseFormController: BaseController {
    override func getBackgroundImage() -> UIImage? {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = HattenColor.primary.color
        self.navigationController?.navigationBar.backgroundColor = HattenColor.gray200.color
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: HattenColor.primary.color]
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
}
