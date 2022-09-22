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
                completionBlock!("\(self.ref!.documentID)")
                self.uploadPhotoForRegister(carImage: (model.carImage ?? UIImage.init(named: "carPhoto"))!, documentId: self.ref!.documentID) { finished in
                    
                }
            }
        }
    }
    
    func updateUserInfoWithSeconds100200(username : String,seconds100200 : Double,completionBlock:((Bool) -> Void)?) {
        
        let prefSeconds = Defaults().getSeconds100200()
        let nowSeconds = seconds100200
        
        if (prefSeconds ?? 0.0 < 1) || (nowSeconds < prefSeconds ?? 0.0) {
            db.collection("users").getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                        completionBlock!(true)
                    } else {
                        var userFound : Bool = false
                        for document in querySnapshot!.documents {
                            let responseUsername = (document["username"] as? String ?? "")
                            if responseUsername.compare(username){
                                userFound = true
                                let registerModel = RegisterModel.init(snapshot: document)
                                registerModel.seconds100200 = seconds100200
                                document.reference.updateData(registerModel.toJsonString())
                                Defaults().saveSeconds100200(data: seconds100200)
                                break
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
    }
        
    func updateUserInfoWithSeconds0100(username : String,seconds0100 : Double,completionBlock:((Bool) -> Void)?) {
        let prefSeconds = Defaults().getSeconds0100()
        let nowSeconds = seconds0100
        if nowSeconds < 2.2{
            return
        }
        if (prefSeconds ?? 0.0 < 1) || (nowSeconds < prefSeconds ?? 0.0) {
            db.collection("users").getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                        completionBlock!(true)
                    } else {
                        var userFound : Bool = false
                        for document in querySnapshot!.documents {
                            let responseUsername = (document["username"] as? String ?? "")
                            if responseUsername.compare(username){
                                userFound = true
                                let registerModel = RegisterModel.init(snapshot: document)
                                registerModel.seconds0100 = seconds0100
                                document.reference.updateData(registerModel.toJsonString())
                                Defaults().saveSeconds0100(data: seconds0100)
                                break
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
    }
    
    func updateUserInfoWithTopSpeed(username : String,topSpeed : Double,completionBlock:((Bool) -> Void)?) {
        let prefSeconds = Defaults().getTopSpeed()
        if topSpeed > 380.0 {
            return
        }
        if (topSpeed > prefSeconds ?? 0.0) {
            db.collection("users").getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                        completionBlock!(true)
                    } else {
                        var userFound : Bool = false
                        for document in querySnapshot!.documents {
                            let responseUsername = (document["username"] as? String ?? "")
                            if responseUsername.compare(username){
                                userFound = true
                                let registerModel = RegisterModel.init(snapshot: document)
                                registerModel.topSpeed = topSpeed
                                document.reference.updateData(registerModel.toJsonString())
                                completionBlock!(true)
                                break
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
    }
    
    func uploadPhotoForRegister(carImage : UIImage,documentId : String,completionBlock:((Bool) -> Void)?) {
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
    
    func getAllUsers(by0100Seconds : Bool = false,by100200Seconds : Bool = false,byTopSpeed : Bool = false,completionBlock:(([RegisterModel]) -> Void)?) {
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
        db.collection("users").order(by: orderedKey).getDocuments() { (querySnapshot, err) in
            IndicatorManager.shared.hideIndicator()
                if let err = err {
                    print("Error getting documents: \(err)")
                    completionBlock!([])
                }else {
                    var tempList : [RegisterModel] = []
                    var indexOrder = 1
                    if byTopSpeed {
                        indexOrder = querySnapshot!.documents.count
                    }
                    for document in querySnapshot!.documents {
                        let username = document["username"] as? String ?? ""
                        let password = document["password"] as? String ?? ""
                        let passwordAgain = document["passwordAgain"] as? String ?? ""
                        let carBrand = document["carBrand"] as? String ?? ""
                        let carModel = document["carModel"] as? String ?? ""
                        let topSpeed = document["topSpeed"] as? Double ?? 0.0
                        let seconds0100 = document["seconds0100"] as? Double ?? 0.0
                        let seconds100200 = document["seconds100200"] as? Double ?? 0.0
                        let isPremiumUser = document["isPremiumUser"] as? Bool ?? false
                        
                        let userModel = RegisterModel.init(username: username, password: password, passwordAgain: passwordAgain, carBrand: carBrand, carModel: carModel, carImage: UIImage.init(named: "carPhoto")!, topSpeed: topSpeed, seconds0100: seconds0100, seconds100200: seconds100200, documentID: document.documentID, isPremiumUser: isPremiumUser)
                        if by0100Seconds {
                            print(username)
                            print(seconds0100)
                            if seconds0100 > 0 {
                                userModel.order = indexOrder
                                tempList.append(userModel)
                                indexOrder += 1
                            }
                        }
                        else if by100200Seconds {
                            if seconds100200 > 0 {
                                userModel.order = indexOrder
                                tempList.append(userModel)
                                indexOrder += 1
                            }
                        }
                        else if byTopSpeed {
                            userModel.order = indexOrder
                            tempList.append(userModel)
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
                            let carBrand = document["carBrand"] as? String ?? ""
                            let carModel = document["carModel"] as? String ?? ""
                            let topSpeed = document["topSpeed"] as? Double ?? 0.0
                            let seconds0100 = document["seconds0100"] as? Double ?? 0.0
                            let seconds100200 = document["seconds100200"] as? Double ?? 0.0
                            let isPremiumUser = document["isPremiumUser"] as? Bool ?? false
                            let userModel = RegisterModel.init(username: username, password: password, passwordAgain: passwordAgain, carBrand: carBrand, carModel: carModel, carImage: UIImage.init(named: "carPhoto")!, topSpeed: topSpeed, seconds0100: seconds0100, seconds100200: seconds100200, documentID: document.documentID, isPremiumUser: isPremiumUser)
                            completionBlock!(userModel)
                            IndicatorManager.shared.hideIndicator()
                        }
                    }
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
    
}


