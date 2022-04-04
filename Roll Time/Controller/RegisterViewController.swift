//
//  RegisterViewController.swift
//  Roll Time
//
//  Created by Akif Demirezen on 13.03.2022.
//

import UIKit

class RegisterViewController: BaseUIViewController {

    @IBOutlet weak var imageViewCar: UIImageView!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var imageViewAdd: UIImageView!
    @IBOutlet weak var imageViewTempCar: UIImageView!
    
    @IBOutlet weak var textFieldCarBrand: UITextField!
    @IBOutlet weak var textFieldCarModel: UITextField!
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldAgainPassword: UITextField!
    
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
        
        self.textFieldCarBrand.setUIConfigure()
        self.textFieldCarModel.setUIConfigure()
    }

    @IBAction func btnActAddCarImage(_ sender: Any) {
        ImagePickerManager().pickImage(self){ image in
            self.choosedImage = image
        }
    }
    
    @IBAction func btnActRegister(_ sender: Any) {
        let registerModel = RegisterModel.init(username: self.textFieldUsername.text?.lowercased() ?? "", password: self.textFieldPassword.text ?? "", passwordAgain: self.textFieldAgainPassword.text ?? "", carBrand: self.textFieldCarBrand.text ?? "", carModel: self.textFieldCarModel.text ?? "",carImage: (self.imageViewCar.image ?? UIImage.init(named: "electric-car"))!)
        FirebaseManager.shared.registerUser(model: registerModel) { documentId in
            if !documentId.isEmpty {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    let storyBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let tabbarVC = storyBoard.instantiateViewController(withIdentifier: "CustomTabViewController")
                    self.navigationController?.present(tabbarVC, animated: true, completion: {
                        Defaults().saveUserName(data: self.textFieldUsername.text ?? "")
                    })
                }
            }
        }
    }
    
}
extension RegisterViewController : UIPickerViewDelegate,UIPickerViewDataSource{
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
