//
//  ExtensionUITableView.swift
//  Roll Time
//
//  Created by Akif Demirezen on 11.06.2022.
//

import UIKit

extension UITableViewCell {
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
}

