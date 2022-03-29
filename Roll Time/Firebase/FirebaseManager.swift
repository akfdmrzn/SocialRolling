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


