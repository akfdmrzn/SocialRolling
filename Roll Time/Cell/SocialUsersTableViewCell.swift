//
//  SocialUsersTableViewCell.swift
//  Roll Time
//
//  Created by Akif Demirezen on 11.06.2022.
//

import UIKit
import SDWebImage

class SocialUsersTableViewCell: UITableViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewContainerSpeed: UIView!
    @IBOutlet weak var imageViewCar: UIImageView!
    @IBOutlet weak var viewContainerNumber: UIView!
    @IBOutlet weak var labelOrder: UILabel!
    @IBOutlet weak var labelCar: UILabel!
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelTimeTitle: UILabel!
    @IBOutlet weak var viewChoosenCar: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    func setData(model : MyCarModel,row : Int,selectedIndex : Int,isYourProfileListCar: Bool){
        self.imageViewCar.sd_setImage(with: URL.init(string: model.carImageString), placeholderImage: nil, options: .refreshCached, progress: nil, completed: nil)
        self.labelCar.text = "\(model.carBrand) - \(model.carModel)"
        self.labelUsername.text = "Akif"
        self.labelOrder.text = "\(model.order)"
        if selectedIndex == 0 {
            self.labelTimeTitle.text = "Seconds"
            self.labelTime.text = "\(model.seconds0100)"
        }
        else if selectedIndex == 1 {
            self.labelTimeTitle.text = "Seconds"
            self.labelTime.text = "\(model.seconds100200)"
        }
        else if selectedIndex == 2 {
            self.labelTimeTitle.text = "KM/H"
            self.labelTime.text = "\(model.topSpeed)"
        }
        if isYourProfileListCar && model.isChoosenCar{
            self.viewChoosenCar.isHidden = false
            self.labelOrder.text = "\(row)"
        } else {
            self.viewChoosenCar.isHidden = true
        }
    }
    
    override func layoutSubviews() {
        self.viewContainer.layer.borderColor = UIColor.lightGray.cgColor
        self.viewContainer.layer.borderWidth = 1.0
        self.viewContainer.layer.cornerRadius = 20.0
        
        self.viewContainerSpeed.layer.borderColor = UIColor.lightGray.cgColor
        self.viewContainerSpeed.layer.borderWidth = 0.3
        self.viewContainerSpeed.layer.cornerRadius = 10.0
        self.viewContainerNumber.layer.cornerRadius = self.viewContainerNumber.frame.size.width / 2.0
    }
}
