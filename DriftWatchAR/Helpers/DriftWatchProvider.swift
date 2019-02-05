//
//  MockLocationProvider.swift
//  MockLocations
//
//  Created by Govindarajan Anand on 11/21/17.
//  Copyright © 2017 Govindarajan Anand. All rights reserved.
//

import Foundation
import CoreLocation

let NAME_KEY = "Name"
let LATITUDE_KEY = "Latitude"
let LONGITUDE_KEY = "Longitude"
let PLIST_FILENAME = "DriftwatchList"

protocol DriftWatchProviderProtocol: class {
    func getDriftWatches() -> [Place]
}

class DriftWatchProvider {
    private var driftWatches: [Place] = []
    
    init() {
        initializeLocationsFromPlist()
    }
}

extension DriftWatchProvider: DriftWatchProviderProtocol {
    func getDriftWatches() -> [Place] {
        return driftWatches
    }
}

private extension DriftWatchProvider {
    
    func initializeLocationsFromPlist() {
        
        if let path = Bundle.main.path(forResource: PLIST_FILENAME, ofType: "plist") {
            if let list = NSArray(contentsOfFile: path) as? [[String: Any]] {
                for locationDict in list {
                    if let latitude = locationDict[LATITUDE_KEY] as? NSNumber,
                        let longitude = locationDict[LONGITUDE_KEY] as? NSNumber, let name = locationDict[NAME_KEY] as? String {
                        
                        let coordinate = CLLocation(latitude: latitude.doubleValue, longitude: longitude.doubleValue)
                        let place = Place(name: name, location: coordinate)
                        driftWatches.append(place)
                    }
                    
                }
            }
        }
     }
    
}
