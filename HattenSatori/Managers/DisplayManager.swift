//
//  DisplayType.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 22/12/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

public enum DisplayType {
    case unknown
    case iphone4
    case iphone5
    case iphone6
    case iphone6plus
    static let iphone7 = iphone6
    static let iphone7plus = iphone6plus
    case ipad
}

public final class DisplayManager {
    class var width:CGFloat { return UIScreen.main.bounds.size.width }
    class var height:CGFloat { return UIScreen.main.bounds.size.height }
    class var maxLength:CGFloat { return max(width, height) }
    class var minLength:CGFloat { return min(width, height) }
    class var zoomed:Bool { return UIScreen.main.nativeScale >= UIScreen.main.scale }
    class var retina:Bool { return UIScreen.main.scale >= 2.0 }
    class var phone:Bool { return UIDevice.current.userInterfaceIdiom == .phone }
    class var pad:Bool { return UIDevice.current.userInterfaceIdiom == .pad }
    class var carplay:Bool { return UIDevice.current.userInterfaceIdiom == .carPlay }
    class var tv:Bool { return UIDevice.current.userInterfaceIdiom == .tv }
    class var typeIsLike:DisplayType {
        if phone {
            if maxLength < 568 {
                return .iphone4
            }
            else if maxLength == 568 {
                return .iphone5
            }
            else if maxLength == 667 {
                return .iphone6
            }
            else if maxLength == 736 {
                return .iphone6plus
            }
        }
        else if maxLength == 1024 {
            return .ipad
        }
        return .unknown
    }
}
