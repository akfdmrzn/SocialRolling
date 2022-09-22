//
//  ProfileCarViewController.swift
//  Roll Time
//
//  Created by Akif Demirezen on 12.06.2022.
//

import UIKit
import SDWebImage
import Photos

class ProfileCarViewController: UIViewController {

    @IBOutlet weak var labelBrand: UILabel!
    @IBOutlet weak var labelModel: UILabel!
    @IBOutlet weak var imageViewCar: UIImageView!
    @IBOutlet weak var labelTopSpeed: UILabel!
    @IBOutlet weak var label0100: UILabel!
    @IBOutlet weak var label100200: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var viewLogout: UIView!
    @IBOutlet weak var btnLogOut: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var viewDelete: UIView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var labelUsername: UILabel!
    
    var userModel : RegisterModel?
    var myCarModel : RegisterModel?
    
    @IBOutlet weak var viewScores: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnLogOut.makeUIButton()
        self.btnDelete.makeUIButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setData()
    }
    
    func setData(){
        if userModel != nil {
            self.btnEdit.isHidden = true
            self.labelBrand.text = userModel?.carBrand ?? ""
            self.labelModel.text = userModel?.carModel ?? ""
            self.imageViewCar.sd_setImage(with: URL.init(string: "https://firebasestorage.googleapis.com/v0/b/social-rolling.appspot.com/o/\(userModel?.documentId ?? "").jpeg?alt=media&token=9cc8c61f-8622-4eee-abf4-7e9676de7360"), placeholderImage: nil, options: .refreshCached, progress: nil, completed: nil)
            self.labelTopSpeed.text = "\(Int(userModel?.topSpeed ?? 0.0)) KM/H"
            self.label0100.text = "\(userModel?.seconds0100 ?? 0.0) second"
            self.label100200.text = "\(userModel?.seconds100200 ?? 0.0) second"
            self.viewScores.isHidden = false
            self.labelUsername.text = userModel?.username ?? ""
            self.viewDelete.isHidden = true
        }
        else{
            self.getUserProfile()
            self.btnEdit.isHidden = false
            self.btnBack.isHidden = true
            self.viewDelete.isHidden = false
        }
    }
    
    func getUserProfile(){
        FirebaseManager.shared.getMyProfile { response in
            self.myCarModel = response
            self.labelBrand.text = self.myCarModel?.carBrand ?? ""
            self.labelModel.text = self.myCarModel?.carModel ?? ""
            self.imageViewCar.sd_setImage(with: URL.init(string: "https://firebasestorage.googleapis.com/v0/b/social-rolling.appspot.com/o/\(self.myCarModel?.documentId ?? "").jpeg?alt=media&token=9cc8c61f-8622-4eee-abf4-7e9676de7360"), placeholderImage: nil, options: .refreshCached, progress: nil, completed: nil)
            self.labelTopSpeed.text = "\(Int(self.myCarModel?.topSpeed ?? 0.0)) KM/H"
            self.label0100.text = "\(self.myCarModel?.seconds0100 ?? 0.0) second"
            self.label100200.text = "\(self.myCarModel?.seconds100200 ?? 0.0) second"
            self.viewScores.isHidden = false
            self.labelUsername.text = self.myCarModel?.username ?? ""
        }
    }
    
    @IBAction func btnActDelete(_ sender: Any) {
        FirebaseManager.shared.deleteUserAccount(username: Defaults().getUserId()) { isDeleted in
            if isDeleted{
                Defaults().clearData()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "MainLaunchNavigationController")
                AppDelegate.window?.rootViewController = vc
                AppDelegate.window?.makeKeyAndVisible()
            }
            else{
                
            }
        }
    }
    
    @IBAction func btnActEdit(_ sender: Any) {
        PHPhotoLibrary.requestAuthorization({ status in
            switch status {
            case .notDetermined:
                DispatchQueue.main.async {
                    let alert = UIAlertController(
                        title: "We were unable to load your album groups. Sorry!",
                        message: "You can enable access in Privacy Settings",
                        preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsURL)
                        }
                    }))
                    self.present(alert, animated: true)
                }
                
            case .denied, .restricted:
                DispatchQueue.main.async {
                    let alert = UIAlertController(
                        title: "We were unable to load your album groups. Sorry!",
                        message: "You can enable access in Privacy Settings",
                        preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsURL)
                        }
                    }))
                    self.present(alert, animated: true)
                }
                
            case .authorized:
                DispatchQueue.main.async {
                    ImagePickerManager().pickImage(self){ image in
                        FirebaseManager.shared.uploadPhotoForRegister(carImage: image, documentId: Defaults().getUserId()) { finished in
                            self.getUserProfile()
                        }
                    }
                }
            case .limited:
                DispatchQueue.main.async {
                    ImagePickerManager().pickImage(self){ image in
                        FirebaseManager.shared.uploadPhotoForRegister(carImage: image, documentId: Defaults().getUserId()) { finished in
                            self.getUserProfile()
                        }
                    }
                }
            @unknown default:
                fatalError("PHPhotoLibrary::execute - \"Unknown case\"")
            }
        })
    }
    
    @IBAction func btnActLogOut(_ sender: Any) {
        Defaults().clearData()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainLaunchNavigationController")
        AppDelegate.window?.rootViewController = vc
        AppDelegate.window?.makeKeyAndVisible()
    }
    
    override func viewDidLayoutSubviews() {
        self.imageViewCar.layer.cornerRadius = 15.0
        self.viewLogout.layer.cornerRadius = 10.0
        self.viewDelete.layer.cornerRadius = 10.0
    }
    
    @IBAction func btnActBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
