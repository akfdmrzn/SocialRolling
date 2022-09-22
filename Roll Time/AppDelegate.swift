//
//  AppDelegate.swift
//  Roll Time
//
//  Created by Akif Demirezen on 3.01.2021.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase

let BANNERSCREEN_ID = "ca-app-pub-6875060834963859/6664145301" //real id
//let BANNERSCREEN_ID = "ca-app-pub-3940256099942544/2934735716" //test id
let CELLSCREEN_ID = "ca-app-pub-6875060834963859/7657926108" //real id
//let CELLSCREEN_ID = "ca-app-pub-3940256099942544/3986624511" //test id
let FULLSCREEN_ID = "ca-app-pub-6875060834963859/8296978522" //real id
//let FULLSCREEN_ID = "ca-app-pub-3940256099942544/4411468910" //test id

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    static var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
        AppDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        if Defaults().getUserName().isEmpty { //Login olmayan
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MainLaunchNavigationController")
            AppDelegate.window?.rootViewController = vc
            AppDelegate.window?.makeKeyAndVisible()
        }
        else{ //Önceden Login olan
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CustomTabViewController")
            AppDelegate.window?.rootViewController = vc
            AppDelegate.window?.makeKeyAndVisible()
        }
        return true
    }
}
