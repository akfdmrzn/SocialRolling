//
//  ExtensionUIView.swift
//  Roll Time
//
//  Created by Akif Demirezen on 29.03.2022.
//

import UIKit

extension UIView{
    func addShadow(){
        self.layer.cornerRadius = CornerRadiusButton
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 3.0
        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        
    }
    
}
