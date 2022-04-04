//
//  RouteViewController.swift
//  Roll Time
//
//  Created by Akif Demirezen on 12.03.2022.
//

import UIKit
import Lottie

class RouteViewController: BaseUIViewController {

    @IBOutlet weak var viewAnimation: AnimationView!
    @IBOutlet weak var viewLogin: UIView!
    @IBOutlet weak var viewRegister: UIView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnLogin.makeUIButton()
        self.btnRegister.makeUIButton()
        
        self.viewAnimation.animation = Animation.named("speedmeter")
        self.viewAnimation.play()
        
        self.textFieldUsername.setUIConfigure()
        self.textFieldPassword.setUIConfigure()
        self.textFieldUsername.text = "akif"
        self.textFieldPassword.text = "123"
    }
    @IBAction func btnActRegister(_ sender: Any) {
        self.navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
    
    @IBAction func btnActLogin(_ sender: Any) {
        FirebaseManager.shared.loginUser(username: self.textFieldUsername.text ?? "", password: self.textFieldPassword.text ?? "") { success in
            if success {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    let storyBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let tabbarVC = storyBoard.instantiateViewController(withIdentifier: "CustomTabViewController")
                    self.navigationController?.present(tabbarVC, animated: true, completion: {
                        Defaults().saveUserName(data: self.textFieldUsername.text ?? "")
                    })
                }
            }
            else{
                print("e")
            }
        }
    }
    
}
