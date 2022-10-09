//
//  RegisterViewController.swift
//  Roll Time
//
//  Created by Akif Demirezen on 13.03.2022.
//

import UIKit
import Photos

class AddCarViewController: BaseUIViewController {

    @IBOutlet weak var imageViewCar: UIImageView!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var imageViewAdd: UIImageView!
    @IBOutlet weak var imageViewTempCar: UIImageView!
    
    @IBOutlet weak var textFieldCarBrand: UITextField!
    @IBOutlet weak var textFieldCarModel: UITextField!
    
    var choosedImage : UIImage = UIImage.init(named: "electric-car")!{
        didSet{
            self.imageViewCar.image = choosedImage
            self.imageViewTempCar.isHidden = true
            self.imageViewAdd.isHidden = true
        }
    }
    var choosenBrandId = 0
    var carBrandList : [BrandModel] = []
    var carModelList : [CarModel] = []
    var pickerCarBrand : UIPickerView!
    var pickerCarModel : UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .fullScreen
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle  = .light
        }
        self.btnRegister.makeUIButton()
        
        self.imageViewCar.layer.cornerRadius = CornerRadiusButton
        self.imageViewCar.layer.borderWidth = 1.0
        self.imageViewCar.layer.borderColor = UIColor.lightGray.cgColor
        self.imageViewCar.layer.shadowColor = UIColor.lightGray.cgColor
        self.imageViewCar.layer.shadowOpacity = 1.0
        self.imageViewCar.layer.shadowOffset = .zero
        self.imageViewCar.layer.shadowRadius = 3
        
        self.textFieldCarBrand.inputAccessoryView = carBrandPickerToolBar
        self.pickerCarBrand = self.carBrandPicker()
        self.pickerCarBrand.delegate = self
        self.pickerCarBrand.dataSource = self
        self.textFieldCarBrand.inputView = self.pickerCarBrand
        
        self.textFieldCarModel.inputAccessoryView = carModalPickerToolBar
        self.pickerCarModel = self.carModelPicker()
        self.pickerCarModel.delegate = self
        self.pickerCarModel.dataSource = self
        self.textFieldCarModel.inputView = self.pickerCarModel
        
        self.carBrandList = DBConnection().getBrandList()
        self.textFieldCarBrand.text = self.carBrandList.first?.name ?? ""
        self.choosenBrandId = Int(self.carBrandList.first?.idBrand ?? 0)
        self.carModelList = DBConnection().getCarList(fkBrandId: self.choosenBrandId)
        
        self.textFieldCarBrand.setUIConfigure()
        self.textFieldCarModel.setUIConfigure()
    }

    @IBAction func btnActAddCarImage(_ sender: Any) {
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
                        self.choosedImage = image
                    }
                }
            case .limited:
                DispatchQueue.main.async {
                    ImagePickerManager().pickImage(self){ image in
                        self.choosedImage = image
                    }
                }
            @unknown default:
                fatalError("PHPhotoLibrary::execute - \"Unknown case\"")
            }
        })
    }
    
    @IBAction func btnActRegister(_ sender: Any) {
        let carBrand = self.textFieldCarBrand.text ?? ""
        let carModel = self.textFieldCarModel.text ?? ""
        
        if carBrand.isEmpty {
            self.showAlertMsg(msg: "Please Fill The Car Brand Field") {
                
            }
            return
        }
        else if carModel.isEmpty {
            self.showAlertMsg(msg: "Please Fill The Car Brand Field") {
                
            }
            return
        }
        IndicatorManager.shared.showIndicator()
        let myCarModel = MyCarModel.init(topSpeed: 0.0, seconds0100: 0.0, seconds100200: 0.0, carBrand: self.textFieldCarBrand.text ?? "", carModel: self.textFieldCarModel.text ?? "", carImage: (self.imageViewCar.image ?? UIImage.init(named: "carPhoto"))!,userdocumentId: Defaults().getUserId(), isChoosenCar: false)
        FirebaseManager.shared.registerCar(model: myCarModel) { documentId in
            IndicatorManager.shared.hideIndicator()
            FirebaseManager.shared.updateChoosenCar(carId: documentId) {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.showAlertMsg(msg: "Car succesfully added") {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    @IBAction func btnActBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension AddCarViewController : UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.pickerCarBrand {
            return self.carBrandList.count
        }
        else{
            return self.carModelList.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.pickerCarBrand {
            self.textFieldCarBrand.text = self.carBrandList[row].name
            self.choosenBrandId = Int(self.carBrandList[row].idBrand)
            self.carModelList = DBConnection().getCarList(fkBrandId: self.choosenBrandId)
            self.textFieldCarModel.text = self.carModelList.first?.name ?? ""
        }
        else{
            self.textFieldCarModel.text = self.carModelList[row].name
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.pickerCarBrand {
            return self.carBrandList[row].name
        }
        else{
            return self.carModelList[row].name
        }
    }
}