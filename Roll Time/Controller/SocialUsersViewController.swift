//
//  SocialUsersViewController.swift
//  Roll Time
//
//  Created by Akif Demirezen on 11.06.2022.
//

import UIKit
import GoogleMobileAds

class SocialUsersViewController: UIViewController {

    @IBOutlet weak var tableViewScores: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var adLoader: GADAdLoader!
    var selectedIndex = 0
    var carList : [Presentation] = []{
        didSet{
            self.tableViewScores.reloadData()
        }
    }
    var adsProvider : ADSProvider?
    var fullscrennAd: GADInterstitialAd?
    var countTapSegment = 0
    var isShowedAds = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupADS()
        self.tableViewScores.register(SocialUsersTableViewCell.nib, forCellReuseIdentifier: SocialUsersTableViewCell.identifier)
        self.tableViewScores.delegate = self
        self.tableViewScores.dataSource = self
        self.tableViewScores.reloadData()
        self.segmentControl.addTarget(self, action: #selector(segmentSelected(sender:)), for: .valueChanged)
        self.segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        self.segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.lightGray], for: .normal)
        self.segmentControl.tintColor = UIColor.init(hexString: "#70A8F8")
        FirebaseManager.shared.getAllUsers(by0100Seconds: true) { response in
            self.carList = response
            self.applyAdsIfPossible()
        }
    }
    
    func applyAdsIfPossible() {
        if !MainViewController.isPremiumUser {
            let numberOfLoadAds = self.carList.count / 9
            adsProvider = ADSProvider(rootViewController: self, tableView: self.tableViewScores, adInsertionEvery: 10,toLoadADS: numberOfLoadAds)
                adsProvider?.insertionOperation = { [weak self] ad, i in
                    self?.carList.insert(ad, at: i)
            }
        }
    }
    
    func setupADS() {
        let multipleAdsOptions = GADMultipleAdsAdLoaderOptions()
            multipleAdsOptions.numberOfAds = 5

            adLoader = GADAdLoader(adUnitID: CELLSCREEN_ID, rootViewController: self,
                adTypes: [.native],
                options: [multipleAdsOptions])
            adLoader.delegate = self
            adLoader.load(GADRequest())
    }
        
    @objc func segmentSelected(sender: UISegmentedControl){
        countTapSegment += 1
        let index = sender.selectedSegmentIndex
        if index == 0 {
            self.selectedIndex = 0
            FirebaseManager.shared.getAllUsers(by0100Seconds: true) { response in
                self.carList = response
                self.applyAdsIfPossible()
            }
        }
        else if index == 1{
            self.selectedIndex = 1
            FirebaseManager.shared.getAllUsers(by100200Seconds: true) { response in
                self.carList = response
                self.applyAdsIfPossible()
            }
        }
        else if index == 2{
            self.selectedIndex = 2
            FirebaseManager.shared.getAllUsers(byTopSpeed: true) { response in
                self.carList = response
                self.applyAdsIfPossible()
            }
        }
        if countTapSegment == 7 && !self.isShowedAds {
            countTapSegment = 0
            self.createAd()
        }
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
               self.isShowedAds = true
        })
    }
}
extension SocialUsersViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.carList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let nativeAd = adsProvider?.adForRowAr(indexPath: indexPath) {
            return nativeAd
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SocialUsersTableViewCell.identifier, for: indexPath) as! SocialUsersTableViewCell
        if let carItem = self.carList[indexPath.row] as? RegisterModel {
            cell.setData(model: carItem,row: indexPath.row + 1,selectedIndex: self.selectedIndex)
            return cell
        }
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileCarViewController") as! ProfileCarViewController
        if let carItem = self.carList[indexPath.row] as? RegisterModel{
            vc.userModel = carItem
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}
extension SocialUsersViewController : GADNativeAdLoaderDelegate{
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        
    }

}
extension SocialUsersViewController : GADFullScreenContentDelegate{
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
