//
//  CarModel.swift
//  Roll Time
//
//  Created by Akif Demirezen on 13.03.2022.
//

class CarModel {
    var idModel : Int64 = 0
    var name: String = ""
    var fkBrand: Int64 = 0
    
    init() {
        
    }
    
    init(idModel: Int64,name : String,fkBrand : Int64) { // Constructor
        self.idModel = idModel
        self.name = name
        self.fkBrand = fkBrand
    }
}
