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
        modalPresentationStyle = .fullScreen
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle  = .light
        }
        self.btnLogin.makeUIButton()
        self.btnRegister.makeUIButton()
        
        self.viewAnimation.animation = Animation.named("speedmeter")
        self.viewAnimation.play()
        
        self.textFieldUsername.setUIConfigure()
        self.textFieldPassword.setUIConfigure()
        self.textFieldPassword.isSecureTextEntry = true
    }
    @IBAction func btnActRegister(_ sender: Any) {
        self.navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
    
    @IBAction func btnActLogin(_ sender: Any) {
        let username = self.textFieldUsername.text ?? ""
        let password = self.textFieldPassword.text ?? ""
        if username.isEmpty {
            self.showAlertMsg(msg: "Please Fill The Username Field") {
                
            }
            return
        }
        else if password.isEmpty {
            self.showAlertMsg(msg: "Please Fill The Password Field") {
                
            }
            return
        }
        FirebaseManager.shared.loginUser(username: username, password: password) { success in
            if success {
                Defaults().saveUserName(data: username)
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    let storyBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let tabbarVC = storyBoard.instantiateViewController(withIdentifier: "CustomTabViewController")
                    self.navigationController?.present(tabbarVC, animated: true, completion: {
                    })
                }
            }
            else{
                self.showAlertMsg(msg: "Wrong Password Or Username.Please Check The Fields") {
                    
                }
            }
        }
    }
    
}
