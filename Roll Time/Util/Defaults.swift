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
    }
    
   public init(){}
    
    
    
   public func clearData(){
    
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }
        
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
    
    public func saveSeconds100200(data:String){
        let preferences = UserDefaults.standard
        preferences.set( data , forKey:getIdentifier(type: .Seconds100200))
        preferences.synchronize()
    }
    
    public func getSeconds100200() -> String! {
        let preferences = UserDefaults.standard
        if preferences.object(forKey: getIdentifier(type: .Seconds100200)) == nil {
            return ""
        }
        let data:String = preferences.value(forKey: getIdentifier(type: .Seconds100200)) as! String
        return data
    }
    
    public func saveSeconds0100(data:String){
        let preferences = UserDefaults.standard
        preferences.set( data , forKey:getIdentifier(type: .Seconds0100))
        preferences.synchronize()
    }
    
    public func getSeconds0100() -> String! {
        let preferences = UserDefaults.standard
        if preferences.object(forKey: getIdentifier(type: .Seconds0100)) == nil {
            return ""
        }
        let data:String = preferences.value(forKey: getIdentifier(type: .Seconds0100)) as! String
        return data
    }
    
    public func saveTopSpeed(data:String){
        let preferences = UserDefaults.standard
        preferences.set( data , forKey:getIdentifier(type: .TopSpeed))
        preferences.synchronize()
    }
    
    public func getTopSpeed() -> String! {
        let preferences = UserDefaults.standard
        if preferences.object(forKey: getIdentifier(type: .TopSpeed)) == nil {
            return ""
        }
        let data:String = preferences.value(forKey: getIdentifier(type: .TopSpeed)) as! String
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
        }
    }
}

