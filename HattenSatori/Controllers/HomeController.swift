//
//  HomeController.swift
//  HattenSatori
//
//  Created by Re Foong Lim on 07/04/2018.
//  Copyright © 2018 Silvertech Solution. All rights reserved.
//

import Foundation
import UIKit

class HomeController: BaseMenuController {
    override func getMenu() -> MenuItem? {
        return MenuItem.Home
    }
    
    override func getSubMenu() -> SubMenuItem? {
        return SubMenuItem.Developer
    }
}
