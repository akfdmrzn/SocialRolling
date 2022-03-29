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
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 3
        
    }
    
}
