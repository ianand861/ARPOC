//
//  MainViewController.swift
//  DriftWatchAR
//
//  Created by Govindarajan Anand on 12/7/17.
//  Copyright © 2017 Govindarajan Anand. All rights reserved.
//

import UIKit
import CoreLocation

class DashboardViewController: UIViewController {
    let locationManager = CLLocationManager()
    var userLocation = CLLocation()
    var userHeading: Double = 0.0
    var headingCount = 0
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func showDriftWatches(_ sender: Any) {
        self.activityIndicator.startAnimating()
        initiateLocationManager()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? UINavigationController {
            
            if let arVC = destinationVC.viewControllers.first as? ARViewController {
                arVC.userLocation = userLocation
                arVC.userHeading = userHeading
            }
        }
    }
}

private extension DashboardViewController {
    func initiateLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension DashboardViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        DispatchQueue.main.async {
            
            self.userHeading = newHeading.magneticHeading
            self.locationManager.stopUpdatingHeading()
            self.activityIndicator.stopAnimating()
            self.performSegue(withIdentifier: "showDriftWatches", sender: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        
    //    if (location.horizontalAccuracy > 0 && location.horizontalAccuracy < 20) {
            locationManager.stopUpdatingLocation()
            userLocation = location
            DispatchQueue.global().async {
                self.locationManager.startUpdatingHeading()
            }
     //   }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
}

