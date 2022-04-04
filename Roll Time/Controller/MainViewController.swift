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
    var timer0100 = Timer()
    var timer100200 = Timer()
    
    @IBOutlet weak var viewTopSpeed: UIView!
    @IBOutlet weak var viewScores0100: UIView!
    @IBOutlet weak var viewScores100200: UIView!
    //MARK: IBoutlets
    @IBOutlet weak var speedDisplay: UILabel!
    @IBOutlet weak var headingDisplay: UILabel!
    @IBOutlet weak var distanceTraveled: UILabel!
    @IBOutlet weak var minSpeedLabel: UILabel!
    @IBOutlet weak var maxSpeedLabel: UILabel!
    @IBOutlet weak var avgSpeedLabel: UILabel!
    @IBOutlet weak var labelTimer0100: UILabel!
    @IBOutlet weak var labelTimer100200: UILabel!
    @IBOutlet weak var view0100Timer: UIView!
    @IBOutlet weak var view100200Timer: UIView!
    @IBOutlet weak var viewSpeed: UIView!
    
    var minutes0100 = 0
    var seconds0100 = 0
    var milliseconds0100 = 0
    
    var minutes100200 = 0
    var seconds100200 = 0
    var milliseconds100200 = 0
    
    var isClicled0100 = false
    var isClicled100200 = false
    
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        minSpeedLabel.text = "Minimum Speed : 0"
        maxSpeedLabel.text = "Maximum Speed : 0"
        // Ask for Authorisation from the User.
        
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
        self.viewScores0100.addShadow()
        self.viewScores100200.addShadow()
        self.viewTopSpeed.addShadow()
    }
    
    @IBAction func btn0100(_ sender: Any) {
        if self.isClicled0100 {
            self.stopTimer0100()
        }
        else{
            self.startTimer0100()
        }
        self.isClicled0100 = !self.isClicled0100
    }
    
    @IBAction func btn100200(_ sender: Any) {
        if self.isClicled100200 {
            self.stopTimer100200()
        }
        else{
            self.startTimer100200()
        }
        self.isClicled100200 = !self.isClicled100200
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    @objc func timerIsRunning0100() {
        
        showTimer0100()
        milliseconds0100 += 1
        if milliseconds0100 > 100 {
            milliseconds0100 = 0
            seconds0100 += 1
        }
        
    }
    
    @objc func timerIsRunning100200() {
        
        showTimer100200()
        milliseconds100200 += 1
        if milliseconds100200 > 100 {
            milliseconds100200 = 0
            seconds100200 += 1
        }
        
    }
    
    func showTimer0100(){
        self.labelTimer0100.text = "\(self.seconds0100):\(self.milliseconds0100)"
    }
    
    func showTimer100200(){
        self.labelTimer100200.text = "\(self.seconds100200):\(self.milliseconds100200)"
    }
    
    func stopTimer0100(){
        self.timer0100.invalidate()
        FirebaseManager.shared.updateUserInfoWithSeconds0100(username: Defaults().getUserName(), seconds0100: "\(self.seconds0100):\(self.milliseconds0100)"){ success in
            
        }
        self.seconds0100 = 0
        self.milliseconds0100 = 0
        self.minutes0100 = 0
    }
    
    func stopTimer100200(){
        self.timer100200.invalidate()
        FirebaseManager.shared.updateUserInfoWithSeconds100200(username: Defaults().getUserName(), seconds100200: "\(self.seconds100200):\(self.milliseconds100200)"){ success in
            
        }
        self.seconds100200 = 0
        self.milliseconds100200 = 0
        self.minutes100200 = 0
    }
    
    func startTimer0100(){
        self.timer0100 = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerIsRunning0100), userInfo: nil, repeats: true)
    }
    
    func startTimer100200(){
        self.timer100200 = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerIsRunning100200), userInfo: nil, repeats: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        if (location!.horizontalAccuracy > 0) {
            updateLocationInfo(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude, speed: location!.speed, direction: location!.course)
        };
        if lastLocation != nil {
            traveledDistance += lastLocation.distance(from: locations.last!)
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
                if self.milliseconds0100 == 0 {
                    self.startTimer0100()
                }
                
                if speedToKPH > 100.0 {
                    self.stopTimer0100()
                    self.startTimer100200()
                }
                
                if speedToKPH < 100.0 {
                    self.stopTimer100200()
                }
                
                if speedToKPH > 200.0 {
                    self.stopTimer100200()
                }
                
            } else {
                speedDisplay.text = "0"
                self.stopTimer100200()
                self.stopTimer0100()
            }
        }
        
        
        // Shows the N - E - S W
        headingDisplay.text = "Heading : \(dir)"
        
    }
    
    func avgSpeed(){
            let speed:[Double] = arrayKPH
            let speedAvg = speed.reduce(0, +) / Double(speed.count)
            avgSpeedLabel.text = (String(format: "%.0f", speedAvg))
            //print( votesAvg
    }
    
    @IBAction func startTrip(sender: AnyObject) {
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func endTrip(sender: AnyObject) {
        locationManager.stopUpdatingLocation()
        minutes0100 = 0
        seconds0100 = 0
        milliseconds0100 = 0
        minutes100200 = 0
        seconds100200 = 0
        milliseconds100200 = 0
        
        showTimer0100()
        showTimer100200()
        
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
