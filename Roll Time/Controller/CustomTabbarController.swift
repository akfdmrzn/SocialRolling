//
//  CustomTabbarController.swift
//  Roll Time
//
//  Created by Akif Demirezen on 19.06.2022.
//

import UIKit

class CustomTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .fullScreen
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle  = .light
        }
        delegate = self
        self.setViewColor()
        let indicatorView = IndicatorView.init(frame: view.bounds)
        view.addSubview(indicatorView)
        FirebaseManager.shared.getIsSocialTabTrue { isOpenTab in
            self.prepareViewControllers(isOpenTab : isOpenTab)
            indicatorView.removeFromSuperview()
        }
    }
    
    func setViewColor(){
        self.tabBar.tintColor = UIColor.white
        self.tabBar.unselectedItemTintColor = UIColor.lightGray.withAlphaComponent(0.8)
        self.tabBar.barTintColor = UIColor.init(hexString: "#081017")
        self.tabBar.backgroundColor = UIColor.init(hexString: "#081017")
        
    }
    
    func prepareViewControllers(isOpenTab : Bool) {
        var viewControllers: [UIViewController] = []
        let storyBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let homeViewController = storyBoard.instantiateViewController(withIdentifier: "MainViewController")
        let homeNavigationVC = createNavigationcontroller(viewController: homeViewController, image: UIImage.init(named: "fastblack")!, selected:UIImage.init(named: "fast")!)
        viewControllers.append(homeNavigationVC)
        if isOpenTab {
            let socialViewController = storyBoard.instantiateViewController(withIdentifier: "SocialUsersViewController")
            let socialNavigationVC = createNavigationcontroller(viewController: socialViewController, image: UIImage.init(named: "peopleblack")! , selected: UIImage.init(named: "people")!)
            viewControllers.append(socialNavigationVC)
        }
        
        let profileViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileCarViewController")
        let myTripsNavigationVC = createNavigationcontroller(viewController: profileViewController, image: UIImage.init(named: "maintenanceblack")! , selected: UIImage.init(named: "maintenance")!)
        viewControllers.append(myTripsNavigationVC)
                setViewControllers(viewControllers, animated: true)
        
    }
    
    func createNavigationcontroller(viewController: UIViewController, image: UIImage, selected: UIImage) -> UINavigationController {
        let vc = UINavigationController(rootViewController: viewController)
        vc.interactivePopGestureRecognizer?.isEnabled = true
        vc.navigationBar.isHidden = true
        vc.tabBarItem.imageInsets = UIEdgeInsets.init(top: 5,left: 0,bottom: 0,right: 0)
        vc.tabBarItem.image = image
        vc.tabBarItem.selectedImage = selected
        return vc
    }
    
}
extension CustomTabbarController: UITabBarControllerDelegate  {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
       return true
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
            
    }
}
