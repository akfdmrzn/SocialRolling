//
//  FirebaseManager.swift
//  Roll Time
//
//  Created by Akif Demirezen on 27.03.2022.
//

import Foundation
import Firebase
import FirebaseStorage

public class FirebaseManager{
    
    public static let shared = FirebaseManager()
    var ref: DocumentReference? = nil
    var db = Firestore.firestore()
    
    public init(){
        
    }
    
    func registerUser(model : RegisterModel,completionBlock:((String) -> Void)?) {
        ref = db.collection("users").addDocument(data: model.toJsonString()) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                Defaults().saveUserId(data: "\(self.ref!.documentID)")
                completionBlock!("\(self.ref!.documentID)")
            }
        }
    }
    
    func registerCar(model : MyCarModel,completionBlock:((String) -> Void)?) {
        ref = db.collection("cars").addDocument(data: model.toJsonString()) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                Defaults().saveChoosenCarId(data: "\(self.ref!.documentID)")
                completionBlock!("\(self.ref!.documentID)")
                self.uploadPhotoForCar(carImage: (model.carImage ?? UIImage.init(named: "carPhoto"))!, documentId: self.ref!.documentID) { finished in
                    
                }
            }
        }
    }
    
    func updateUserInfoWithSeconds100200(seconds100200 : Double,completionBlock:((Bool) -> Void)?) {
        
        let prefSeconds = Defaults().getSeconds100200()
        let nowSeconds = seconds100200
        
        if (prefSeconds ?? 0.0 < 1) || (nowSeconds < prefSeconds ?? 0.0) {
            let docRef = db.collection("cars").document(Defaults().getChoosenCarId())
            db.collection("cars").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    completionBlock!(true)
                } else {
                    var userFound : Bool = false
                    for document in querySnapshot!.documents {
                        if document.documentID.compare((Defaults().getChoosenCarId() ?? "")){
                            userFound = true
                            let carModel = MyCarModel.init(snapshot: document)
                            carModel.seconds100200 = seconds100200
                            document.reference.updateData(carModel.toJsonString())
                        }
                    if userFound {
                        completionBlock!(true)
                    }
                    else{
                        completionBlock!(false)
                    }
                  }
                }
            }
        }
    }
        
    func updateUserInfoWithSeconds0100(username : String,seconds0100 : Double,completionBlock:((Bool) -> Void)?) {
        let prefSeconds = Defaults().getSeconds0100()
        let nowSeconds = seconds0100
        if nowSeconds < 2.2{
            return
        }
        if (prefSeconds ?? 0.0 < 1) || (nowSeconds < prefSeconds ?? 0.0) {
            db.collection("cars").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    completionBlock!(true)
                } else {
                    var userFound : Bool = false
                    for document in querySnapshot!.documents {
                        if document.documentID.compare((Defaults().getChoosenCarId() ?? "")){
                            userFound = true
                            let carModel = MyCarModel.init(snapshot: document)
                            carModel.seconds0100 = seconds0100
                            document.reference.updateData(carModel.toJsonString())
                        }
                    if userFound {
                        completionBlock!(true)
                    }
                    else{
                        completionBlock!(false)
                    }
                  }
                }
            }
        }
    }
    
    func updateUserInfoWithTopSpeed(username : String,topSpeed : Double,completionBlock:((Bool) -> Void)?) {
        let prefSeconds = Defaults().getTopSpeed()
        if topSpeed > 380.0 {
            return
        }
        if (topSpeed > prefSeconds ?? 0.0) {
            db.collection("cars").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    completionBlock!(true)
                } else {
                    var userFound : Bool = false
                    for document in querySnapshot!.documents {
                        if document.documentID.compare((Defaults().getChoosenCarId() ?? "")){
                            userFound = true
                            let carModel = MyCarModel.init(snapshot: document)
                            carModel.topSpeed = topSpeed
                            document.reference.updateData(carModel.toJsonString())
                        }
                    if userFound {
                        completionBlock!(true)
                    }
                    else{
                        completionBlock!(false)
                    }
                  }
                }
            }
        }
    }
    
    func uploadPhotoForCar(carImage : UIImage,documentId : String,completionBlock:((Bool) -> Void)?) {
        let storageRef = Storage.storage(url: "gs://social-rolling.appspot.com/").reference().child("\(documentId).jpeg")
        let imgData = carImage.jpegData(compressionQuality: 0.2)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        storageRef.putData(imgData!, metadata: metaData) { (metadata, error) in
            if error == nil{
                completionBlock!(true)
            }else{
                print("error in save image")
                completionBlock!(false)
            }
        }
    }
    
    func updateChoosenCar(carId: String,completionBlock:(() -> Void)?) {
        db.collection("cars").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completionBlock!()
            } else {
                for document in querySnapshot!.documents {
                    if document.documentID.compare((carId)){
                        let carModel = MyCarModel.init(snapshot: document)
                        carModel.isChoosenCar = true
                        document.reference.updateData(carModel.toJsonString())
                        Defaults().saveChoosenCarId(data: document.documentID)
                    }else{
                        let carModel = MyCarModel.init(snapshot: document)
                        carModel.isChoosenCar = false
                        document.reference.updateData(carModel.toJsonString())
                    }
                }
                completionBlock!()
            }
        }
    }
    
    
    func loginUser(username : String,password : String,completionBlock:((Bool) -> Void)?) {
        IndicatorManager.shared.showIndicator()
        db.collection("users").getDocuments() { (querySnapshot, err) in
                IndicatorManager.shared.hideIndicator()
                if let err = err {
                    print("Error getting documents: \(err)")
                    completionBlock!(true)
                } else {
                    var userFound : Bool = false
                    for document in querySnapshot!.documents {
                        let responseUsername = (document["username"] as? String ?? "")
                        let responsePassword = (document["password"] as? String ?? "")
                        if responseUsername.compare(username) && responsePassword.compare(password){
                            userFound = true
                            Defaults().saveUserId(data: document.documentID)
                        }
                    }
                    if userFound {
                        completionBlock!(true)
                    }
                    else{
                        completionBlock!(false)
                    }
                }
        }
    }
    
    func checkValidUserName(username : String,completionBlock:((Bool) -> Void)?) {
        db.collection("users").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    completionBlock!(false)
                } else {
                    var userFound : Bool = false
                    for document in querySnapshot!.documents {
                        let responseUsername = (document["username"] as? String ?? "")
                        if responseUsername.compare(username){
                            userFound = true
                        }
                    }
                    if userFound {
                        completionBlock!(true)
                    }
                    else{
                        completionBlock!(false)
                    }
                }
        }
    }
    
    func deleteUserAccount(username : String,completionBlock:((Bool) -> Void)?) {
        IndicatorManager.shared.showIndicator()
        db.collection("users").document(username).delete { error in
            IndicatorManager.shared.hideIndicator()
            if let err = error {
                print("Error getting documents: \(err)")
                completionBlock!(false)
            } else {
                completionBlock!(true)
            }
        }
    }
    
    func getAllCars(by0100Seconds : Bool = false,by100200Seconds : Bool = false,byTopSpeed : Bool = false,completionBlock:(([MyCarModel]) -> Void)?) {
        IndicatorManager.shared.showIndicator()
        var orderedKey = ""
        if by0100Seconds {
            orderedKey = "seconds0100"
        }
        else if by100200Seconds {
            orderedKey = "seconds100200"
        }
        else if byTopSpeed {
            orderedKey = "topSpeed"
        }
        db.collection("cars").order(by: orderedKey).getDocuments() { (querySnapshot, err) in
            IndicatorManager.shared.hideIndicator()
                if let err = err {
                    print("Error getting documents: \(err)")
                    completionBlock!([])
                }else {
                    var tempList : [MyCarModel] = []
                    var indexOrder = 1
                    if byTopSpeed {
                        indexOrder = querySnapshot!.documents.count
                    }
                    for document in querySnapshot!.documents {
                        let carModel = MyCarModel.init(snapshot: document)
                        carModel._id = document.documentID
                        carModel.carImageString = "https://firebasestorage.googleapis.com/v0/b/social-rolling.appspot.com/o/\(document.documentID).jpeg?alt=media&token=9cc8c61f-8622-4eee-abf4-7e9676de7360"
                        
                        if by0100Seconds {
                            if carModel.seconds0100 > 0 {
                                carModel.order = indexOrder
                                tempList.append(carModel)
                                indexOrder += 1
                            }
                        }
                        else if by100200Seconds {
                            if carModel.seconds100200 > 0 {
                                carModel.order = indexOrder
                                tempList.append(carModel)
                                indexOrder += 1
                            }
                        }
                        else if byTopSpeed {
                            carModel.order = indexOrder
                            tempList.append(carModel)
                            indexOrder -= 1
                        }
                    }
                    if byTopSpeed {
                        completionBlock!(tempList.reversed())
                    }
                    else{
                        completionBlock!(tempList)
                    }
                }
        }
    }
    
    func getMyProfile(completionBlock:((RegisterModel) -> Void)?) {
        IndicatorManager.shared.showIndicator()
        db.collection("users").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    IndicatorManager.shared.hideIndicator()
                } else {
                    for document in querySnapshot!.documents {
                        let responseUsername = (document["username"] as? String ?? "")
                        if responseUsername.compare(Defaults().getUserName() ?? ""){
                            Defaults().saveUserId(data: document.documentID)
                            let username = document["username"] as? String ?? ""
                            let password = document["password"] as? String ?? ""
                            let passwordAgain = document["passwordAgain"] as? String ?? ""
                            let isPremiumUser = document["isPremiumUser"] as? Bool ?? false
                            let userModel = RegisterModel.init(username: username, password: password, passwordAgain: passwordAgain, isPremiumUser: isPremiumUser)
                            completionBlock!(userModel)
                            IndicatorManager.shared.hideIndicator()
                        }
                    }
                    IndicatorManager.shared.hideIndicator()
                }
        }
    }
    
    func getCarProfile(carId: String, completionBlock:((MyCarModel) -> Void)?) {
        IndicatorManager.shared.showIndicator()
        db.collection("cars").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    IndicatorManager.shared.hideIndicator()
                } else {
                    for document in querySnapshot!.documents {
                        let carModel = MyCarModel.init(snapshot: document)
                        if document.documentID.compare(carId){
                            carModel.carImageString = "https://firebasestorage.googleapis.com/v0/b/social-rolling.appspot.com/o/\(document.documentID).jpeg?alt=media&token=9cc8c61f-8622-4eee-abf4-7e9676de7360"
                            carModel._id = document.documentID
                            completionBlock!(carModel)
                            IndicatorManager.shared.hideIndicator()
                        }
                    }
                    IndicatorManager.shared.hideIndicator()
                }
        }
    }
    
    func getMyAllCarsProfile(userId: String, completionBlock:(([MyCarModel]) -> Void)?) {
        IndicatorManager.shared.showIndicator()
        var tempCarList: [MyCarModel] = []
        db.collection("cars").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    IndicatorManager.shared.hideIndicator()
                } else {
                    for document in querySnapshot!.documents {
                        let carModel = MyCarModel.init(snapshot: document)
                        carModel.carImageString = "https://firebasestorage.googleapis.com/v0/b/social-rolling.appspot.com/o/\(document.documentID).jpeg?alt=media&token=9cc8c61f-8622-4eee-abf4-7e9676de7360"
                        carModel._id = document.documentID
                        if Defaults().getUserId().compare(carModel.userdocumentId){
                            tempCarList.append(carModel)
                        }
                        IndicatorManager.shared.hideIndicator()
                    }
                    completionBlock!(tempCarList)
                    IndicatorManager.shared.hideIndicator()
                }
        }
    }
    
    func getIsSocialTabTrue(completionBlock:((Bool) -> Void)?) {
        db.collection("settings").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    completionBlock!(false)
                } else {
                    for document in querySnapshot!.documents {
                        let isOpenTab = (document["isSocialTabOpen"] as? Bool ?? false)
                        if isOpenTab {
                            completionBlock!(true)
                        }
                        else{
                            completionBlock!(false)
                        }
                    }
                }
        }
    }
    
    func getUserNameWithUserId(userId : String,completionBlock:((String) -> Void)?) {
        db.collection("users").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    completionBlock!("")
                } else {
                    for document in querySnapshot!.documents {
                        if document.documentID.elementsEqual(userId){
                            let username = document["username"] as? String ?? ""
                            completionBlock!(username)
                            break
                        }
                    }
                }
        }
    }
    
}


