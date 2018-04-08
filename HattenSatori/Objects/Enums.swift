//
//  ImageEnum.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 17/11/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

enum RootPath: String {
    case My = "http://www.inframobile.com"
}

enum HattenColor: Int {
    case primary = 0xEC5454
    case primaryDark = 0xA90F15
    case green = 0x69BA6D
    case accent = 0xFDA639
    case gray100 = 0xF5F5F5
    case gray200 = 0xEEEEEE
    case gray300 = 0xEDEDED
    case gray500 = 0x999999
    case gray700 = 0x616161
    case gray800 = 0x424242
    case black = 0x000000
    case white = 0xFFFFFF
    case yellow = 0xFFF44F
    case orange = 0xB08A4E
    case orangeHighlight = 0xC8AD83
    case orangeBackground = 0xE7DCC9
    
    case shadow = 0xAAAAAA
    case transparent
    
    var color: UIColor {
        get {
            switch self {
            case .transparent:
                return UIColor.clear
            default:
                return UIColor(netHex: self.rawValue)
            }
        }
    }
}

enum Segue: String {
    case segueHome
    case segueNotification
}

enum MyError: Error {
    case InternetError(String)
    case MismatchResposeError(String)
}

enum MenuItem: String {
    case Home
    case Developer
    case USP
    case Gallery
    case Plan
    case Design
    case Location
    case Enquiry
    
    static var items: [MenuItem] {
        get {
            return [MenuItem.Home, MenuItem.Developer, MenuItem.USP, MenuItem.Gallery, MenuItem.Plan, MenuItem.Design, MenuItem.Location, MenuItem.Enquiry]
        }
    }
    
    var subMenu: [SubMenuItem] {
        get {
            switch self {
//            case .Home:
//                return [SubMenuItem.Developer]
            case .Plan:
                return [SubMenuItem.FacilityPlan, SubMenuItem.LayoutPlan, SubMenuItem.LevelPlan]
            default:
                return []
            }
        }
    }
}

enum SubMenuItem: String {
//    case Developer
    case FacilityPlan
    case LayoutPlan
    case LevelPlan
}
