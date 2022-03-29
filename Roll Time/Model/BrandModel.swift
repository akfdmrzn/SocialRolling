//
//  BrandModel.swift
//  Roll Time
//
//  Created by Akif Demirezen on 13.03.2022.
//

class BrandModel {
    var idBrand : Int64 = 0
    var name: String = ""

    init() {
        
    }
    
    init(idBrand: Int64,name : String) { // Constructor
        self.idBrand = idBrand
        self.name = name
    }
}
