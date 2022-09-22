//
//  LocationManager.swift
//  Roll Time
//
//  Created by Akif Demirezen on 16.06.2022.
//

import UIKit
import CoreLocation

class LocationManager {
    
    init() {
        
    }
    
    func locationAuthorizationStatus() -> CLAuthorizationStatus {
        let locationManager = CLLocationManager()
        var locationAuthorizationStatus : CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            locationAuthorizationStatus =  locationManager.authorizationStatus
        } else {
            // Fallback on earlier versions
            locationAuthorizationStatus = CLLocationManager.authorizationStatus()
        }
        return locationAuthorizationStatus
    }
    
    func hasLocationPermission() -> Bool {
        var hasPermission = false
        let manager = self.locationAuthorizationStatus()
        
        if CLLocationManager.locationServicesEnabled() {
            switch manager {
            case .notDetermined, .restricted, .denied:
                hasPermission = false
            case .authorizedAlways, .authorizedWhenInUse:
                hasPermission = true
            @unknown default:
                break
            }
        } else {
            hasPermission = false
        }
        
        return hasPermission
    }
    func routePermissionScreen(){
            let alertController = UIAlertController(title: "Location Permission", message: "You have to allow location permission to meausure your speed", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
                //Redirect to Settings app
                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel,handler: {(cAlertAction) in
                //Redirect to Settings app
                self.routePermissionScreen()
            })
            alertController.addAction(cancelAction)
            
            alertController.addAction(okAction)
            
            UIApplication.getTopViewController()?.present(alertController, animated: true, completion: nil)
    }
    
}

