//
//  FacilitiesPlanController.swift
//  HattenSatori
//
//  Created by Re Foong Lim on 08/04/2018.
//  Copyright © 2018 Silvertech Solution. All rights reserved.
//

import Foundation
import UIKit

class FacilityPlanController: BaseMenuController {
    override func getMenu() -> MenuItem? {
        return MenuItem.Plan
    }
    
    override func getSubMenu() -> SubMenuItem? {
        return SubMenuItem.FacilityPlan
    }
}
