//
//  ExtensionViewController.swift
//  Roll Time
//
//  Created by Akif Demirezen on 14.06.2022.
//

import UIKit

extension UIViewController {
    func showAlertMsg(msg : String, finished: @escaping () -> Void){
        let alert = UIAlertController(title: "Message", message : msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                finished()
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            default: break
            }}))
        self.navigationController?.present(alert, animated: true, completion: {
            
        })
    }
}
