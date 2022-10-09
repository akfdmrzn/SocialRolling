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
    @IBOutlet weak var viewMakeDefaultCar: UIView!
    
    var carModel : MyCarModel?
    var isYourCar : Bool = false
    
    @IBOutlet weak var viewScores: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnLogOut.makeUIButton()
        self.btnDelete.makeUIButton()
        self.viewMakeDefaultCar.layer.cornerRadius = CornerRadiusButton
        self.viewMakeDefaultCar.layer.borderWidth = 1.0
        self.viewMakeDefaultCar.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setData()
    }
    
    func setData(){
        if self.isYourCar{
            self.btnEdit.isHidden = false
            self.btnBack.isHidden = false
            self.viewDelete.isHidden = false
        }else{
            self.btnEdit.isHidden = true
            self.btnBack.isHidden = false
            self.viewDelete.isHidden = true
        }
        self.getCarProfile()
    }
    
    func getCarProfile(){
        FirebaseManager.shared.getCarProfile(carId: self.carModel?._id ?? "", completionBlock: { carModel in
            self.labelBrand.text = carModel.carBrand
            self.labelModel.text = carModel.carModel
            self.imageViewCar.sd_setImage(with: URL.init(string: carModel.carImageString), placeholderImage: nil, options: .refreshCached, progress: nil, completed: nil)
            self.labelTopSpeed.text = "\(Int(carModel.topSpeed)) KM/H"
            self.label0100.text = "\(carModel.seconds0100) second"
            self.label100200.text = "\(carModel.seconds100200) second"
            self.viewScores.isHidden = false
            self.labelUsername.text = Defaults().getUserName()
            if self.isYourCar {
                self.viewMakeDefaultCar.isHidden = carModel.isChoosenCar
            }else{
                self.viewMakeDefaultCar.isHidden = true
            }
        })
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
    private func setImageByStatus(status: PHAuthorizationStatus){
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
                    FirebaseManager.shared.uploadPhotoForCar(carImage: image, documentId: self.carModel?._id ?? "") { finished in
                        self.getCarProfile()
                    }
                }
            }
        case .limited:
            DispatchQueue.main.async {
                ImagePickerManager().pickImage(self){ image in
                    FirebaseManager.shared.uploadPhotoForCar(carImage: image, documentId: self.carModel?._id ?? "") { finished in
                        self.getCarProfile()
                    }
                }
            }
        @unknown default:
            fatalError("PHPhotoLibrary::execute - \"Unknown case\"")
        }
    }
    
    @IBAction func btnActEdit(_ sender: Any) {
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
                self.setImageByStatus(status: status)
            }
        } else {
            PHPhotoLibrary.requestAuthorization({ status in
                self.setImageByStatus(status: status)
            })
        }
        
    }
    
    @IBAction func btnActLogOut(_ sender: Any) {
        Defaults().clearData()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainLaunchNavigationController")
        AppDelegate.window?.rootViewController = vc
        AppDelegate.window?.makeKeyAndVisible()
    }
    
    @IBAction func btnActMakeDefault(_ sender: Any) {
        FirebaseManager.shared.updateChoosenCar(carId: self.carModel?._id ?? "") {
            self.showAlertMsg(msg: "Your Default Car Changed") {
                self.navigationController?.popViewController(animated: true)
            }
        }
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
