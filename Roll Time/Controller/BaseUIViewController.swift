//
//  BaseUIViewController.swift
//  Roll Time
//
//  Created by Akif Demirezen on 13.03.2022.
//

import UIKit

class BaseUIViewController: UIViewController {
    
    var carBrandPickerToolBar: UIView = {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBtnTapped))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(carBrandTapped))
        toolBar.setItems([cancelButton, flexSpace, doneButton], animated: false)
        return toolBar
    }()
    
    var carModalPickerToolBar: UIView = {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBtnTapped))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(carModelTapped))
        toolBar.setItems([cancelButton, flexSpace, doneButton], animated: false)
        return toolBar
    }()
    
    func carBrandPicker() -> UIPickerView {
        let carBrandPicker = UIPickerView.init()
        return carBrandPicker
    }
    
    func carModelPicker() -> UIPickerView {
        let carModelPicker = UIPickerView.init()
        return carModelPicker
    }
    
    @objc func cancelBtnTapped() {
        self.view.endEditing(true)
    }
    
    @objc func carModelTapped() {
        self.view.endEditing(true)
    }
    
    @objc func carBrandTapped() {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        modalPresentationStyle = .fullScreen
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle  = .light
        }
    }
    
}
