//
//  RegisterModel.swift
//  Roll Time
//
//  Created by Akif Demirezen on 27.03.2022.
//

import UIKit

class RegisterModel {
    var username : String = ""
    var password: String = ""
    var passwordAgain: String = ""
    var carBrand: String = ""
    var carModel: String = ""
    var carImage: UIImage?
    
    init() {
        
    }
    
    init(username: String,password : String,passwordAgain : String,carBrand : String,carModel : String,carImage : UIImage) { // Constructor
        self.username = username.lowercased()
        self.password = password
        self.passwordAgain = passwordAgain
        self.carBrand = carBrand
        self.carModel = carModel
        self.carImage = carImage
    }
    
    func toJsonString() -> [String : Any]{
        return ["username" : self.username,
                "password" : self.password,
                "passwordAgain" : self.passwordAgain,
                "carBrand" : self.carBrand,
                "carModel" : self.carModel]
    }
    
}
