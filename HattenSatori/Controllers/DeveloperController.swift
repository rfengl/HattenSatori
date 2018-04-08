//
//  DeveloperController.swift
//  HattenSatori
//
//  Created by Developer on 08/04/2018.
//  Copyright © 2018 Silvertech Solution. All rights reserved.
//

import Foundation
import UIKit

class DeveloperController: BaseMenuController {
    override func getMenu() -> MenuItem? {
        return MenuItem.Developer
    }

    override func getSubMenu() -> SubMenuItem? {
        return nil
    }
    
}
