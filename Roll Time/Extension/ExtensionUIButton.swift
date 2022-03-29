//
//  ExtensionUIButton.swift
//  Roll Time
//
//  Created by Akif Demirezen on 13.03.2022.
//

import UIKit

extension UIButton {
    
    
    func makeUIButton() {
        self.layer.cornerRadius = CornerRadiusButton
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 3
    }
    
}
