//
//  NSMutableDataExtension.swift
//  Carfix2
//
//  Created by Re Foong Lim on 20/04/2016.
//  Copyright © 2016 Oneworks Sdn. Bhd. All rights reserved.
//

import Foundation

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
