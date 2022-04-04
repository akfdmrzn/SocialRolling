//
//  RegisterModel.swift
//  Roll Time
//
//  Created by Akif Demirezen on 27.03.2022.
//

import UIKit
import Firebase

class RegisterModel {
    var username : String = ""
    var password: String = ""
    var passwordAgain: String = ""
    var carBrand: String = ""
    var carModel: String = ""
    var carImage: UIImage?
    var topSpeed: String = ""
    var seconds0100: String = ""
    var seconds100200: String = ""
    var documentId : String = ""
    
    init() {
        
    }
    
    init(username: String,password : String,passwordAgain : String,carBrand : String,carModel : String,carImage : UIImage,topSpeed : String = "",seconds0100 : String = "",seconds100200 : String = "") { // Constructor
        self.username = username.lowercased()
        self.password = password
        self.passwordAgain = passwordAgain
        self.carBrand = carBrand
        self.carModel = carModel
        self.carImage = carImage
        self.topSpeed = topSpeed
        self.seconds0100 = seconds0100
        self.seconds100200 = seconds100200
    }
    
    init(snapshot: QueryDocumentSnapshot) {
        documentId = snapshot.documentID
        let snapshotValue = snapshot.data()
        username = snapshotValue["username"] as? String ?? ""
        password = snapshotValue["password"] as? String ?? ""
        passwordAgain = snapshotValue["passwordAgain"] as? String ?? ""
        carBrand = snapshotValue["carBrand"] as? String ?? ""
        carModel = snapshotValue["carModel"] as? String ?? ""
        topSpeed = snapshotValue["topSpeed"] as? String ?? ""
        seconds0100 = snapshotValue["seconds0100"] as? String ?? ""
        seconds100200 = snapshotValue["seconds100200"] as? String ?? ""
    }
    
    func toJsonString() -> [String : Any]{
        return ["username" : self.username,
                "password" : self.password,
                "passwordAgain" : self.passwordAgain,
                "carBrand" : self.carBrand,
                "carModel" : self.carModel,
                "topSpeed" : self.topSpeed,
                "seconds0100" : self.seconds0100,
                "seconds100200" : self.seconds100200]
    }
    
}
