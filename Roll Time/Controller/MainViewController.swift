//
//  ViewController.swift
//  Roll Time
//
//  Created by Akif Demirezen on 3.01.2021.
//

import UIKit
import MapKit
import CoreLocation

class MainViewController: BaseUIViewController, CLLocationManagerDelegate {
    //MARK: Global Var's
    var locationManager: CLLocationManager = CLLocationManager()
    var switchSpeed = "KPH"
    var startLocation:CLLocation!
    var lastLocation: CLLocation!
    var traveledDistance:Double = 0
    var arrayMPH: [Double]! = []
    var arrayKPH: [Double]! = []
    var timer = Timer()
    
    
    //MARK: IBoutlets
    @IBOutlet weak var speedDisplay: UILabel!
    @IBOutlet weak var headingDisplay: UILabel!
    @IBOutlet weak var distanceTraveled: UILabel!
    @IBOutlet weak var minSpeedLabel: UILabel!
    @IBOutlet weak var maxSpeedLabel: UILabel!
    @IBOutlet weak var avgSpeedLabel: UILabel!
    @IBOutlet weak var labelTimer: UILabel!
    
    @IBOutlet weak var view0100Timer: UIView!
    @IBOutlet weak var view100200Timer: UIView!
    @IBOutlet weak var viewSpeed: UIView!
    
    var minutes = 0
    var seconds = 0
    var milliseconds = 0
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        minSpeedLabel.text = "Minimum Speed : 0"
        maxSpeedLabel.text = "Maximum Speed : 0"
        // Ask for Authorisation from the User.
        self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerIsRunning), userInfo: nil, repeats: true)
        self.timer.invalidate()
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        self.setUI()
    }
    
    func setUI(){
        self.view0100Timer.addShadow()
        self.view100200Timer.addShadow()
        self.viewSpeed.addShadow()
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    @objc func timerIsRunning() {
        
        showTimer()
        milliseconds += 1
        if milliseconds > 100 {
            milliseconds = 0
            seconds += 1
        }
        
    }
    
    func showTimer(){
        self.labelTimer.text = "\(self.seconds):\(self.milliseconds)"
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        if (location!.horizontalAccuracy > 0) {
            updateLocationInfo(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude, speed: location!.speed, direction: location!.course)
        };
        if lastLocation != nil {
            traveledDistance += lastLocation.distance(from: locations.last!)
            if switchSpeed == "MPH" {
                if traveledDistance < 1609 {
                    let tdF = traveledDistance / 3.28084
                    distanceTraveled.text = (String(format: "%.1f Feet", tdF))
                } else if traveledDistance > 1609 {
                    let tdM = traveledDistance * 0.00062137
                    distanceTraveled.text = (String(format: "%.1f Miles", tdM))
                }
            }
            if switchSpeed == "KPH" {
                if traveledDistance < 1609 {
                    let tdMeter = traveledDistance
                    distanceTraveled.text = (String(format: "%.0f Meters", tdMeter))
                } else if traveledDistance > 1609 {
                    let tdKm = traveledDistance / 1000
                    distanceTraveled.text = (String(format: "%.1f Km", tdKm))
                }
            }
        }
        lastLocation = locations.last
        
    }
    
    func updateLocationInfo(latitude: CLLocationDegrees, longitude: CLLocationDegrees, speed: CLLocationSpeed, direction: CLLocationDirection) {
        let speedToMPH = (speed * 2.23694)
        let speedToKPH = (speed * 3.6)
        let val = ((direction / 22.5) + 0.5);
        var arr = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"];
        let dir = arr[Int(val.truncatingRemainder(dividingBy: 16))]
        //lonDisplay.text = coordinateString(latitude, longitude: longitude)
        
        //        lonDisplay.text = (String(format: "%.3f", longitude))
        //        latDisplay.text = (String(format: "%.3f", latitude))
        if switchSpeed == "MPH" {
            // Chekcing if speed is less than zero or a negitave number to display a zero
            if (speedToMPH > 0) {
                speedDisplay.text = (String(format: "%.0f mph", speedToMPH))
                arrayMPH.append(speedToMPH)
                let lowSpeed = arrayMPH.min()
                let highSpeed = arrayMPH.max()
                minSpeedLabel.text = (String(format: "Minumum - %.0f mph", lowSpeed!))
                maxSpeedLabel.text = (String(format: "Maximum -%.0f mph", highSpeed!))
                avgSpeed()
            } else {
                speedDisplay.text = "Speed : 0 mph"
            }
        }
        
        if switchSpeed == "KPH" {
            // Checking if speed is less than zero
            if (speedToKPH > 0) {
                speedDisplay.text = (String(format: "%.0f", speedToKPH))
                arrayKPH.append(speedToKPH)
                let lowSpeed = arrayKPH.min()
                let highSpeed = arrayKPH.max()
                minSpeedLabel.text = (String(format: "Minumum - %.0f km/h", lowSpeed!))
                maxSpeedLabel.text = (String(format: "Maximum - %.0f km/h", highSpeed!))
                avgSpeed()
                
                if speedToKPH >= 100.0 {
                    self.timer.invalidate()
                }
                //                print("Low: \(lowSpeed!) - High: \(highSpeed!)")
            } else {
                speedDisplay.text = "0"
            }
        }
        
        
        // Shows the N - E - S W
        headingDisplay.text = "Heading : \(dir)"
        
    }
    
    func avgSpeed(){
        if switchSpeed == "MPH" {
            let speed:[Double] = arrayMPH
            let speedAvg = speed.reduce(0, +) / Double(speed.count)
            avgSpeedLabel.text = (String(format: "%.0f", speedAvg))
            //print( votesAvg )
        } else if switchSpeed == "KPH" {
            let speed:[Double] = arrayKPH
            let speedAvg = speed.reduce(0, +) / Double(speed.count)
            avgSpeedLabel.text = (String(format: "%.0f", speedAvg))
            //print( votesAvg
        }
    }
    
    @IBAction func startTrip(sender: AnyObject) {
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func endTrip(sender: AnyObject) {
        locationManager.stopUpdatingLocation()
        minutes = 0
        seconds = 0
        milliseconds = 0
        print(minutes) // prints 0
        print(seconds) // prints 0
        print(milliseconds) // prints 0
        
        showTimer()
        
        self.timer.invalidate()
    }
}
extension TimeInterval {
    var hourMinuteSecondMS: String {
        String(format:"%d:%02d:%02d.%03d", hour, minute, second, millisecond)
    }
    var minuteSecondMS: String {
        String(format:"%d:%02d.%03d", minute, second, millisecond)
    }
    var hour: Int {
        Int((self/3600).truncatingRemainder(dividingBy: 3600))
    }
    var minute: Int {
        Int((self/60).truncatingRemainder(dividingBy: 60))
    }
    var second: Int {
        Int(truncatingRemainder(dividingBy: 60))
    }
    var millisecond: Int {
        Int((self*1000).truncatingRemainder(dividingBy: 1000))
    }
}
extension Int {
    var msToSeconds: Double { Double(self) / 1000 }
}
