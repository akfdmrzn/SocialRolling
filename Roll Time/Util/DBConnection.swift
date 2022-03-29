//
//  DBConnection.swift
//  Roll Time
//
//  Created by Akif Demirezen on 13.03.2022.
//

import UIKit
import SQLite
import SQLite3

class DBConnection: NSObject {
    
    
    var db : Connection?
    let modelTable = Table("model")
    let brandTable = Table("brand")
    
    override init() {
        do {
            super.init()
            
            if let fileURL = Bundle(for: type(of: self)).path(forResource: "carBrandList", ofType: "db"){
                print("Database Bağlandı")
                db = try Connection(self.prepareDatabaseFile())
                
            }
            
        }catch {
            print("Json file error atom detailvc")
        }
    }
    
    func prepareDatabaseFile() -> String {
        let fileName: String = "carBrandList.db"
        
        let fileManager:FileManager = FileManager.default
        let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let documentUrl = directory.appendingPathComponent(fileName)
        let bundleUrl = Bundle.main.resourceURL?.appendingPathComponent(fileName)
        
        // here check if file already exists on simulator
        if fileManager.fileExists(atPath: (documentUrl.path)) {
            print("document file exists!")
            
            return documentUrl.path
        }else if fileManager.fileExists(atPath: (bundleUrl?.path)!) {
            print("document file does not exist, copy from bundle!")
            do{
                try fileManager.copyItem(at:bundleUrl!, to:documentUrl)
            }catch{
                print("erorr")
            }
            
        }
        
        return documentUrl.path
    }
    
    func getBrandList()-> [BrandModel]{
        var brandList : [BrandModel] = []
        do{
            let queryStringAll = "SELECT * from brand"
            let array = try db?.prepare(queryStringAll)
            for item in array!{
                let brand = BrandModel.init()
                if let item = item[0] as? Int.Datatype{ //IDBrand
                    brand.idBrand =  item
                }
                if let item = item[1] as? String{ //BrandName
                    brand.name =  item
                }
                brandList.append(brand)
            }
        }catch{
            print("error Database")
        }
        return brandList
    }
    
    func getCarList(fkBrandId : Int)-> [CarModel]{
        var carList : [CarModel] = []
        do{
            let queryStringAll = "Select * from model where model.fk_brand is \(fkBrandId)"
            let array = try db?.prepare(queryStringAll)
            for item in array!{
                let car = CarModel.init()
                if let item = item[0] as? Int.Datatype{ //IDBrand
                    car.idModel =  item
                }
                if let item = item[1] as? String{ //BrandName
                    car.name =  item
                }
                if let item = item[2] as? Int.Datatype{ //IDBrand
                    car.fkBrand =  item
                }
                carList.append(car)
            }
        }catch{
            print("error Database")
        }
        return carList
    }
    
}
