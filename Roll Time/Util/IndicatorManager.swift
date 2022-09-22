//
//  IndicatorManager.swift
//  Roll Time
//
//  Created by Akif Demirezen on 12.06.2022.
//

import UIKit


public class IndicatorManager{

    public static let shared = IndicatorManager()
    var indicatorView : IndicatorView?
    
    public init(){
        
    }
    
    func showIndicator(){
        if let wnd = UIApplication.shared.keyWindow {
            indicatorView = IndicatorView.init(frame: wnd.bounds)
            wnd.addSubview(indicatorView!)
        }
    }
    
    func hideIndicator(){
        if let indicator = indicatorView{
            indicator.removeFromSuperview()
        }
    }
    
}
