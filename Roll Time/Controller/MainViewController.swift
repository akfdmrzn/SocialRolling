//
//  ViewController.swift
//  Roll Time
//
//  Created by Akif Demirezen on 3.01.2021.
//

import UIKit
import MapKit
import CoreLocation
import GoogleMobileAds
import StoreKit

class MainViewController: BaseUIViewController, CLLocationManagerDelegate {
    public static var isPremiumUser : Bool = false
    //MARK: Global Var's
    var customLocationManager = LocationManager()
    var locationManager: CLLocationManager = CLLocationManager()
    var switchSpeed = "KPH"
    var startLocation:CLLocation!
    var lastLocation: CLLocation!
    var traveledDistance:Double = 0
    var arrayMPH: [Double]! = []
    var arrayKPH: [Double]! = []
    var timer0100 = Timer()
    var timer100200 = Timer()
    var lastSpeedKMH : Double = 0.0
    var fullscrennAd: GADInterstitialAd?
    
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
    @IBOutlet weak var labelTopSpeed: UILabel!
    @IBOutlet weak var label0100: UILabel!
    @IBOutlet weak var label100200: UILabel!
    @IBOutlet weak var viewBanner: GADBannerView!
    
    
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
        self.createAd()
        self.viewBanner.adUnitID = BANNERSCREEN_ID
        self.viewBanner.rootViewController = self
        self.viewBanner.delegate = self
        let request = GADRequest()

        modalPresentationStyle = .fullScreen
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle  = .light
        }
        minSpeedLabel.text = "Minimum Speed : 0"
        maxSpeedLabel.text = "Maximum Speed : 0"
        self.setUI()
        self.startLocationProcess()
    }
    
    func startLocationProcess() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func makeRequestLocation() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Defaults().getLaunchCount() == 3 || Defaults().getLaunchCount() == 10 || Defaults().getLaunchCount() == 20 {
            self.rateAppStore()
        }
        self.getUserProfile()
            if !LocationManager().hasLocationPermission(){
                if Defaults().getTappedAnyLocationButton() {
                    LocationManager().routePermissionScreen()
                }
                else{
                    self.makeRequestLocation()
                    self.startLocationProcess()
                }
            }
            else{
                self.startLocationProcess()
            }
    }

    func getUserProfile(){
        FirebaseManager.shared.getCarProfile(carId: Defaults().getChoosenCarId()) { carModel in
            Defaults().saveTopSpeed(data: carModel.topSpeed)
            Defaults().saveSeconds0100(data: carModel.seconds0100)
            Defaults().saveSeconds100200(data: carModel.seconds100200)
            if carModel.seconds0100 == 0 {
                self.label0100.text = "-"
            }
            else{
                self.label0100.text = "\(carModel.seconds0100) second"
            }
            if carModel.seconds100200 == 0{
                self.label100200.text = "-"
            }
            else{
                self.label100200.text = "\(carModel.seconds100200) second"
            }
            self.labelTopSpeed.text = "\(Int(carModel.topSpeed)) km/h"
        }
    }
    
    func setUI(){
        self.view0100Timer.addShadow()
        self.view100200Timer.addShadow()
        self.viewSpeed.addShadow()
        self.viewScores0100.addShadow()
        self.viewScores100200.addShadow()
        self.viewTopSpeed.addShadow()
        
    }
    
    func triggeredClosedAds(){
        
    }
    
    func createAd(){
        let request = GADRequest()
           GADInterstitialAd.load(withAdUnitID:FULLSCREEN_ID,
                                       request: request,
                             completionHandler: { [self] ad, error in
                               if let error = error {
                                 print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                                 return
                               }
               self.fullscrennAd = ad
               self.fullscrennAd?.fullScreenContentDelegate = self
               self.fullscrennAd?.present(fromRootViewController: self)
        })
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
    
    func stopTimer0100(isReachTarget : Bool){
        self.timer0100.invalidate()
        let timeFormatDouble = Double("\(self.seconds0100).\(self.milliseconds0100)") ?? 0.0
        if timeFormatDouble == 0 {
            return
        }
        if isReachTarget{
            self.showAlertViewTimer(msg: "Last 0-100: \(timeFormatDouble)")
        }
        if timeFormatDouble < Defaults().getSeconds0100() || Defaults().getSeconds0100() == 0{
            if isReachTarget {
                FirebaseManager.shared.updateUserInfoWithSeconds0100(username: Defaults().getUserName(), seconds0100: timeFormatDouble){ success in
                    Defaults().saveSeconds0100(data: timeFormatDouble)
                    self.label0100.text = "\(timeFormatDouble) second"
                }
            }
            else{
                
            }
        }
        self.seconds0100 = 0
        self.milliseconds0100 = 0
        self.minutes0100 = 0
        self.showTimer0100()
    }
    
    func stopTimer100200(isReachTarget : Bool){
        self.timer100200.invalidate()
        let timeFormatDouble = Double("\(self.seconds100200).\(self.milliseconds100200)") ?? 0.0
        if timeFormatDouble == 0 {
            return
        }
        if isReachTarget{
            self.showAlertViewTimer(msg: "Last 100-200: \(timeFormatDouble)")
        }
        if timeFormatDouble < Defaults().getSeconds100200() {
            if isReachTarget{
                FirebaseManager.shared.updateUserInfoWithSeconds100200(seconds100200: timeFormatDouble) { success in
                    Defaults().saveSeconds100200(data: timeFormatDouble)
                    self.label100200.text = "\(timeFormatDouble) second"
                }
            }
            else{
                
            }
        }
        self.seconds100200 = 0
        self.milliseconds100200 = 0
        self.minutes100200 = 0
        self.showTimer100200()
    }
    
    func rateAppStore() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()

        } else if let url = URL(string: "itms-apps://itunes.apple.com/app/id1629980218") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)

            } else {
                UIApplication.shared.openURL(url)
            }
        }
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
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Defaults().saveTappedAnyLocationButton(data: true)
        switch CLLocationManager.authorizationStatus() {
                case .notDetermined:
                    //Ask for permission
                LocationManager().routePermissionScreen()
                    break
                case .restricted:
            LocationManager().routePermissionScreen()
                    break
                case .denied:
                    //user denied location service
                LocationManager().routePermissionScreen()
                    break
                case .authorizedAlways:
            self.startLocationProcess()
                    break
                case .authorizedWhenInUse:
            self.startLocationProcess()
                    break
                @unknown default:
                    break
                }
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
                let topSpeed = String(format: "%.0f", speedToKPH)
                if Double(topSpeed) ?? 0.0 > Defaults().getTopSpeed()  {
                    FirebaseManager.shared.updateUserInfoWithTopSpeed(username: Defaults().getUserName(), topSpeed: Double(topSpeed) ?? 0.0) { finished in
                        Defaults().saveTopSpeed(data: Double(topSpeed) ?? 0.0)
                        self.labelTopSpeed.text = "\(Int(topSpeed) ?? 0) km/h"
                    }
                }
                if self.lastSpeedKMH <= 0 && speedToKPH > 0 && speedToKPH < 100{ //0 dan sonra ilk kez 0 dan büyükse yapılcak
                    if !self.timer0100.isValid {
                        self.startTimer0100()
                    }
                }
                else if speedToKPH > 200.0 {
                    self.stopTimer100200(isReachTarget: true)
                }
                else if speedToKPH < 100.0 {
                    self.stopTimer100200(isReachTarget: false)
                }
                if (self.lastSpeedKMH > 60) && (self.lastSpeedKMH < 100) && speedToKPH >= 100 && speedToKPH < 200 { //100 den sonra ilk kez 100 den büyükse yapılcak
                    self.stopTimer0100(isReachTarget: true)
                    if !self.timer100200.isValid {
                        self.startTimer100200()
                    }
                }
                
            } else {
                speedDisplay.text = "0"
                self.stopTimer100200(isReachTarget: false)
                self.stopTimer0100(isReachTarget: false)
            }
            self.lastSpeedKMH = speedToKPH
        }
        // Shows the N - E - S W
        headingDisplay.text = "Heading : \(dir)"
        
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
    
    private func showAlertViewTimer(msg: String){
        let viewAlert = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: 0))
        viewAlert.backgroundColor = UIColor.init(red: 35.0/255.0, green: 220.0/255.0, blue: 110.0/255.0, alpha: 1.0)
        let labelAlert = UILabel.init(frame: CGRect.init(x: 0, y: 60, width: self.view.bounds.width, height: 30))
        labelAlert.textAlignment = .center
        labelAlert.font = UIFont.init(name: "Helvetica-Bold", size: 20)
        labelAlert.text = msg
        viewAlert.addSubview(labelAlert)
        viewAlert.layer.cornerRadius = 15.0
        self.view.addSubview(viewAlert)
        UIView.animate(withDuration: 0.8, delay: 0.0, options: [.curveEaseInOut], animations: {
            viewAlert.frame = CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: 100)
            }) { (finished) in
                if finished {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
                        viewAlert.removeFromSuperview()
                    })
                }
            }
        
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
extension MainViewController : GADBannerViewDelegate{
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        
    }
}
extension MainViewController : GADFullScreenContentDelegate{
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
      }

      /// Tells the delegate that the ad will present full screen content.
      func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
      }

      /// Tells the delegate that the ad dismissed full screen content.
      func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
          self.triggeredClosedAds()
          
      }
}
