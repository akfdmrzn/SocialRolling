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
                self.uploadPhotoForRegister(carImage: (model.carImage ?? UIImage.init(named: "electric-car"))!, documentId: self.ref!.documentID, userName: "")
                //                print("Document added with ID: \(self.ref!.documentID)")
            }
        }
    }
    
    func updateUserInfoWithSeconds100200(username : String,seconds100200 : String,completionBlock:((Bool) -> Void)?) {
        var prefArr : [String] = []
        if Defaults().getSeconds100200() == "" {
            prefArr = ["3000","0"]
        }
        else{
            prefArr = Defaults().getSeconds100200().components(separatedBy: ":")
        }
        let prefSeconds = Double("\(prefArr[0]).\(prefArr[1])")
        
        let nowArr = seconds100200.components(separatedBy: ":")
        let nowSeconds = Double("\(nowArr[0]).\(nowArr[1])")
        
        if (nowSeconds ?? 0.0 <  prefSeconds ?? 0.0) {
            db.collection("users").whereField("username", isEqualTo: username)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                        completionBlock!(true)
                    } else {
                        for document in querySnapshot!.documents {
                            let registerModel = RegisterModel.init(snapshot: document)
                            registerModel.seconds100200 = seconds100200
                            document.reference.updateData(registerModel.toJsonString())
                            Defaults().saveSeconds100200(data: seconds100200)
                        }
                    }
                }
        }
    }
        
    func updateUserInfoWithSeconds0100(username : String,seconds0100 : String,completionBlock:((Bool) -> Void)?) {
        var prefArr : [String] = []
        if Defaults().getSeconds0100() == "" {
            prefArr = ["3000","0"]
        }
        else{
            prefArr = Defaults().getSeconds0100().components(separatedBy: ":")
        }
        let prefSeconds = Double("\(prefArr[0]).\(prefArr[1])")
        
        let nowArr = seconds0100.components(separatedBy: ":")
        let nowSeconds = Double("\(nowArr[0]).\(nowArr[1])")
        
        if (nowSeconds ?? 0.0 <  prefSeconds ?? 0.0) {
            db.collection("users").whereField("username", isEqualTo: username)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                        completionBlock!(true)
                    } else {
                        for document in querySnapshot!.documents {
                            let registerModel = RegisterModel.init(snapshot: document)
                            registerModel.seconds0100 = seconds0100
                            document.reference.updateData(registerModel.toJsonString())
                            Defaults().saveSeconds0100(data: seconds0100)
                        }
                    }
                }
        }
    }
    
    func updateUserInfoWithTopSpeed(username : String,topSpeed : String,completionBlock:((Bool) -> Void)?) {
        var prefTopSpeed = ""
        if Defaults().getTopSpeed() == "" {
            prefTopSpeed = "0"
        }
        if topSpeed > prefTopSpeed  {
            db.collection("users").whereField("username", isEqualTo: username)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                        completionBlock!(true)
                    } else {
                        for document in querySnapshot!.documents {
                            let registerModel = RegisterModel.init(snapshot: document)
                            registerModel.topSpeed = topSpeed
                            document.reference.updateData(registerModel.toJsonString())
                        }
                    }
            }
        }
    }
    
    func uploadPhotoForRegister(carImage : UIImage,documentId : String, userName : String) {
        let storageRef = Storage.storage(url: "gs://social-rolling.appspot.com/").reference().child("\(documentId).jpeg")
        let imgData = carImage.jpegData(compressionQuality: 0.2)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        storageRef.putData(imgData!, metadata: metaData) { (metadata, error) in
            if error == nil{
                
            }else{
                print("error in save image")
                
            }
        }
    }
    
    func loginUser(username : String,password : String,completionBlock:((Bool) -> Void)?) {
        db.collection("users").whereField("username", isEqualTo: username)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    completionBlock!(true)
                } else {
                    for document in querySnapshot!.documents {
                        if password.compare((document["password"] as? String ?? "")){
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


