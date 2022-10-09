//
//  RegisterModel.swift
//  Roll Time
//
//  Created by Akif Demirezen on 27.03.2022.
//

import UIKit
import Firebase

protocol Presentation {

}

class RegisterModel : Presentation {
    var username : String = ""
    var password: String = ""
    var passwordAgain: String = ""
    var documentId : String = ""
    var isPremiumUser : Bool?
    var order = 0
    
    init() {
        
    }
    
    init(username: String,password : String,passwordAgain : String,documentID : String = "",isPremiumUser : Bool) { // Constructor
        self.username = username.lowercased()
        self.password = password
        self.passwordAgain = passwordAgain
        self.documentId = documentID
        self.isPremiumUser = isPremiumUser
    }
    
    init(snapshot: QueryDocumentSnapshot) {
        documentId = snapshot.documentID
        let snapshotValue = snapshot.data()
        username = snapshotValue["username"] as? String ?? ""
        password = snapshotValue["password"] as? String ?? ""
        passwordAgain = snapshotValue["passwordAgain"] as? String ?? ""
        isPremiumUser = snapshotValue["isPremiumUser"] as? Bool ?? false
    }
    
    func toJsonString() -> [String : Any]{
        return ["username" : self.username,
                "password" : self.password,
                "passwordAgain" : self.passwordAgain,
                "isPremiumUser" : self.isPremiumUser]
    }
    
}
class MyCarModel : Presentation {
    var _id = ""
    var topSpeed: Double = 0.0
    var seconds0100: Double = 0.0
    var seconds100200: Double = 0.0
    var carBrand: String = ""
    var carModel: String = ""
    var carImage: UIImage?
    var userdocumentId : String = ""
    var carImageString : String = ""
    var isChoosenCar : Bool = false
    var order = 0
    
    init() {
        
    }
    
    init(topSpeed: Double,seconds0100 : Double,seconds100200 : Double,carBrand : String,carModel : String,carImage : UIImage,userdocumentId : String,isChoosenCar : Bool) { // Constructor
        self.carBrand = carBrand
        self.carModel = carModel
        self.carImage = carImage
        self.topSpeed = topSpeed
        self.seconds0100 = seconds0100
        self.seconds100200 = seconds100200
        self.userdocumentId = userdocumentId
        self.isChoosenCar = isChoosenCar
    }
    
    init(snapshot: QueryDocumentSnapshot) {
        let snapshotValue = snapshot.data()
        carBrand = snapshotValue["carBrand"] as? String ?? ""
        carModel = snapshotValue["carModel"] as? String ?? ""
        topSpeed = snapshotValue["topSpeed"] as? Double ?? 0.0
        seconds0100 = snapshotValue["seconds0100"] as? Double ?? 0.0
        seconds100200 = snapshotValue["seconds100200"] as? Double ?? 0.0
        isChoosenCar = snapshotValue["isChoosenCar"] as? Bool ?? false
        userdocumentId = snapshotValue["userdocumentId"] as? String ?? ""
    }
    
    func toJsonString() -> [String : Any]{
        return ["carBrand" : self.carBrand,
                "carModel" : self.carModel,
                "topSpeed" : self.topSpeed,
                "seconds0100" : self.seconds0100,
                "seconds100200" : self.seconds100200,
                "isChoosenCar" : self.isChoosenCar,
                "userdocumentId" : self.userdocumentId]
    }
    
}
