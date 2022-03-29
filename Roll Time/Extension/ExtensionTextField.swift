//
//  ExtensionTextField.swift
//  Roll Time
//
//  Created by Akif Demirezen on 26.03.2022.
//

import UIKit

extension UITextField{
    func setUIConfigure(){
        self.layer.cornerRadius = CornerRadiusTextField
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 1
    }
}
