//
//  Utility.swift
//  DriftWatchAR
//
//  Created by Govindarajan Anand on 12/7/17.
//  Copyright © 2017 Govindarajan Anand. All rights reserved.
//

import Foundation
import CoreLocation

class Utility {
    
    class func deg2rad(_ degrees: Double) -> Double {
        return degrees * Double.pi / 180
    }
    
    class func rad2Deg(_ radians: Double)-> Double {
        return radians * 180 / Double.pi
    }
    
   class func direction(from pl: CLLocation, to p2: CLLocation) -> Double {
        
        let lat1 = Utility.deg2rad(pl.coordinate.latitude)
        let lon1 = Utility.deg2rad(pl.coordinate.longitude)
        let lat2 = Utility.deg2rad(p2.coordinate.latitude)
        let lon2 = Utility.deg2rad(p2.coordinate.longitude)
        
        let dLon = lon2 - lon1;
        
        let y = sin(dLon) * cos(lat2);
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
        let radiansBearing = atan2(y, x);
        
        return Utility.rad2Deg(radiansBearing)
    }
}

