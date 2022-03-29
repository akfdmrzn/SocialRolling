//
//  ExtensionString.swift
//  Roll Time
//
//  Created by Akif Demirezen on 29.03.2022.
//

import UIKit

extension String {

    func compare(_ with : String)->Bool{
        return self.caseInsensitiveCompare(with) == .orderedSame
    }
}
