//
//  Place.swift
//  DriftWatchAR
//
//  Created by Govindarajan Anand on 12/8/17.
//  Copyright © 2017 Govindarajan Anand. All rights reserved.
//

import Foundation
import CoreLocation

class Place {
    let name: String
    let location: CLLocation
    var identifer: UUID?
    var distance: Double?
    
    init(name: String, location: CLLocation) {
        self.name = name
        self.location = location
    }
}
