//
//  SpeedManager.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 23/11/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import CoreLocation

class SpeedManager: NSObject, CLLocationManagerDelegate {
    var last:CLLocation?
    var localtionManager: CLLocationManager!
    override init() {
        super.init()
        
        localtionManager = CLLocationManager();
        localtionManager.delegate = self
        localtionManager.startUpdatingLocation()
    }
    
    func destroy() {
        localtionManager.stopUpdatingLocation()        
    }
    
    func processLocation(_ current:CLLocation) {
        guard last != nil else {
            last = current
            return
        }
        var speed = current.speed
        if (speed > 0) {
            print(speed) // or whatever
        } else {
            speed = last!.distance(from: current) / (current.timestamp.timeIntervalSince(last!.timestamp))
            print(speed)
        }
        last = current
    }
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            processLocation(location)
        }
    }
}
