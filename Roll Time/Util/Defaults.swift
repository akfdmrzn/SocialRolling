//
//  Defaults.swift
//  Roll Time
//
//  Created by Akif Demirezen on 4.04.2022.
//

import Foundation

public class Defaults{
    public enum DefaultsType {
        case UserName
        case Seconds100200
        case Seconds0100
        case TopSpeed
        case UserId
        case TappedAnyButtonLocation
        case AllowedCameraAccess
        case SaveChoosenCarId
        case LaunchAppCount
    }
    
   public init(){}
    
    
    
   public func clearData(){
    
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }
        
    }
    
    public func saveUserId(data:String){
        let preferences = UserDefaults.standard
        preferences.set( data , forKey:getIdentifier(type: .UserId))
        preferences.synchronize()
    }
    
    public func getUserId() -> String! {
        let preferences = UserDefaults.standard
        if preferences.object(forKey: getIdentifier(type: .UserId)) == nil {
            return ""
        }
        let data:String = preferences.value(forKey: getIdentifier(type: .UserId)) as! String
        return data
    }
    
    public func saveTappedAnyLocationButton(data:Bool){
        let preferences = UserDefaults.standard
        preferences.set( data , forKey:getIdentifier(type: .TappedAnyButtonLocation))
        preferences.synchronize()
    }
    
    public func getTappedAnyLocationButton() -> Bool! {
        let preferences = UserDefaults.standard
        if preferences.object(forKey: getIdentifier(type: .TappedAnyButtonLocation)) == nil {
            return false
        }
        let data:Bool = preferences.value(forKey: getIdentifier(type: .TappedAnyButtonLocation)) as! Bool
        return data
    }
    
    public func saveUserName(data:String){
        let preferences = UserDefaults.standard
        preferences.set( data , forKey:getIdentifier(type: .UserName))
        preferences.synchronize()
    }
    
    public func getUserName() -> String! {
        let preferences = UserDefaults.standard
        if preferences.object(forKey: getIdentifier(type: .UserName)) == nil {
            return ""
        }
        let data:String = preferences.value(forKey: getIdentifier(type: .UserName)) as! String
        return data
    }
    
    public func saveSeconds100200(data:Double){
        let preferences = UserDefaults.standard
        preferences.set( data , forKey:getIdentifier(type: .Seconds100200))
        preferences.synchronize()
    }
    
    public func getSeconds100200() -> Double! {
        let preferences = UserDefaults.standard
        if preferences.object(forKey: getIdentifier(type: .Seconds100200)) == nil {
            return 0.0
        }
        let data:Double = preferences.value(forKey: getIdentifier(type: .Seconds100200)) as! Double
        return data
    }
    
    public func saveSeconds0100(data:Double){
        let preferences = UserDefaults.standard
        preferences.set( data , forKey:getIdentifier(type: .Seconds0100))
        preferences.synchronize()
    }
    
    public func getSeconds0100() -> Double! {
        let preferences = UserDefaults.standard
        if preferences.object(forKey: getIdentifier(type: .Seconds0100)) == nil {
            return 0.0
        }
        let data:Double = preferences.value(forKey: getIdentifier(type: .Seconds0100)) as! Double
        return data
    }
    
    public func saveTopSpeed(data:Double){
        let preferences = UserDefaults.standard
        preferences.set( data , forKey:getIdentifier(type: .TopSpeed))
        preferences.synchronize()
    }
    
    public func getTopSpeed() -> Double! {
        let preferences = UserDefaults.standard
        if preferences.object(forKey: getIdentifier(type: .TopSpeed)) == nil {
            return 0.0
        }
        let data:Double = preferences.value(forKey: getIdentifier(type: .TopSpeed)) as! Double
        return data
    }

    public func saveChoosenCarId(data:String){
        let preferences = UserDefaults.standard
        preferences.set( data , forKey:getIdentifier(type: .SaveChoosenCarId))
        preferences.synchronize()
    }
    
    public func getChoosenCarId() -> String! {
        let preferences = UserDefaults.standard
        if preferences.object(forKey: getIdentifier(type: .SaveChoosenCarId)) == nil {
            return ""
        }
        let data:String = preferences.value(forKey: getIdentifier(type: .SaveChoosenCarId)) as! String
        return data
    }
    
    public func saveLaunchCount(data:Int){
        let preferences = UserDefaults.standard
        preferences.set( data , forKey:getIdentifier(type: .LaunchAppCount))
        preferences.synchronize()
    }
    
    public func getLaunchCount() -> Int! {
        let preferences = UserDefaults.standard
        if preferences.object(forKey: getIdentifier(type: .LaunchAppCount)) == nil {
            return 0
        }
        let data:Int = preferences.value(forKey: getIdentifier(type: .LaunchAppCount)) as! Int
        return data
    }
    
    public func saveAllowedCamera(data:Bool){
        let preferences = UserDefaults.standard
        preferences.set( data , forKey:getIdentifier(type: .AllowedCameraAccess))
        preferences.synchronize()
    }
    
    public func getAllowedCamera() -> Bool! {
        let preferences = UserDefaults.standard
        if preferences.object(forKey: getIdentifier(type: .AllowedCameraAccess)) == nil {
            return false
        }
        let data:Bool = preferences.value(forKey: getIdentifier(type: .AllowedCameraAccess)) as! Bool
        return data
    }
    
    private  func  getIdentifier(type:DefaultsType)->String {
        switch type {
        case .UserName:
            return "UserName"
        case .Seconds100200:
            return "Seconds100200"
        case .Seconds0100:
            return "Seconds0100"
        case .TopSpeed:
            return "TopSpeed"
        case .UserId:
            return "UserId"
        case .TappedAnyButtonLocation:
            return "TappedAnyButtonLocation"
        case .AllowedCameraAccess:
            return "AllowedCameraAccess"
        case .SaveChoosenCarId:
            return "SaveChoosenCarId"
        case .LaunchAppCount:
            return "LaunchAppCount"
        }
    }
}

