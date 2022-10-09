//
//  MyCarListViewController.swift
//  Roll Time
//
//  Created by Akif Demirezen on 2.10.2022.
//

import UIKit

class MyCarListViewController: UIViewController {

    @IBOutlet weak var tableViewCars: UITableView!
    @IBOutlet weak var viewAddCar: UIView!
    var tapGesture: UITapGestureRecognizer?
    
    var myCarList : [MyCarModel] = []{
        didSet{
            self.tableViewCars.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.tappedAddCar))
        self.viewAddCar.addGestureRecognizer(self.tapGesture!)
        self.viewAddCar.layer.cornerRadius = CornerRadiusButton
        self.viewAddCar.layer.borderWidth = 1.0
        self.viewAddCar.layer.borderColor = UIColor.lightGray.cgColor
        self.tableViewCars.register(SocialUsersTableViewCell.nib, forCellReuseIdentifier: SocialUsersTableViewCell.identifier)
        self.tableViewCars.delegate = self
        self.tableViewCars.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getAllCars()
    }
    
    @objc func tappedAddCar(){
        self.navigationController?.pushViewController(AddCarViewController(), animated: true)
    }
    
    private func getAllCars() {
        FirebaseManager.shared.getMyAllCarsProfile(userId: Defaults().getUserId()) { carList in
            self.myCarList = carList
        }
    }
    
}
extension MyCarListViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myCarList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SocialUsersTableViewCell.identifier, for: indexPath) as! SocialUsersTableViewCell
        cell.setData(model: self.myCarList[indexPath.row],row: indexPath.row + 1,selectedIndex: 2, isYourProfileListCar: true)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileCarViewController") as! ProfileCarViewController
        vc.carModel = self.myCarList[indexPath.row]
        vc.isYourCar = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}
