//
//  MainViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/15.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import RxSwift

final class MainViewController: UITabBarController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBarItems()
    }
    
    private func setupTabBarItems() {
        
        let homeVC = HomeViewController(nibName: nil, bundle: nil)
        let homeItem = UITabBarItem(title: "Home", image: #imageLiteral(resourceName: "icTabHomeDafault"), selectedImage: #imageLiteral(resourceName: "icTabHomePrimary"))
        homeVC.tabBarItem = homeItem
        
        let homeNav = UINavigationController(rootViewController: homeVC)
        let homeBarbuttonItem = UIBarButtonItem()
        homeBarbuttonItem.title = ""
        homeNav.navigationBar.topItem?.backBarButtonItem = homeBarbuttonItem
        homeNav.navigationBar.barTintColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        homeNav.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        
        let portalVC = PortalViewController(nibName: nil, bundle: nil)
        let portalItem = UITabBarItem(title: "Portal", image: #imageLiteral(resourceName: "icListPrimaryDefault"), selectedImage: #imageLiteral(resourceName: "icListPrimary"))
        portalVC.tabBarItem = portalItem
    
        let portalNav = UINavigationController(rootViewController: portalVC)
        let portalBarbuttonItem = UIBarButtonItem()
        portalBarbuttonItem.title = ""
        portalNav.navigationBar.topItem?.backBarButtonItem = portalBarbuttonItem
        portalNav.navigationBar.barTintColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        portalNav.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        
        let settingVC = SettingViewController(nibName: nil, bundle: nil)
        let settingItem = UITabBarItem(title: "Setting", image: #imageLiteral(resourceName: "icTabUserDafault"), selectedImage: #imageLiteral(resourceName: "icTabUserPrimary"))
        settingVC.tabBarItem = settingItem
        
        let settingNav = UINavigationController(rootViewController: settingVC)
        let settingBarbuttonItem = UIBarButtonItem()
        settingBarbuttonItem.title = ""
        settingNav.navigationBar.topItem?.backBarButtonItem = settingBarbuttonItem
        settingNav.navigationBar.barTintColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        settingNav.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        
        let applicationsEntryVC = ApplicationsEntryViewController(nibName: nil, bundle: nil)
        let image = UIImage(systemName: "rectangle.grid.2x2")
        let applicationsEntryItem = UITabBarItem(title: "Service Links", image: image, selectedImage: image)
        applicationsEntryVC.tabBarItem = applicationsEntryItem
        
        let applicationsEntryNav = UINavigationController(rootViewController: applicationsEntryVC)
        let applicationsButtonItem = UIBarButtonItem()
        applicationsButtonItem.title = ""
        applicationsEntryNav.navigationBar.topItem?.backBarButtonItem = applicationsButtonItem
        applicationsEntryNav.navigationBar.barTintColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        applicationsEntryNav.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        
        self.tabBar.barTintColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        self.tabBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        let resourceType = PloneResourceManager.shared.resourceType
        
        switch resourceType {
        case .kkMember:
             self.viewControllers = [homeNav, portalNav, applicationsEntryNav, settingNav]
            
        case .normal(url: _):
             self.viewControllers = [homeNav, portalNav, settingNav]
            
        case .none:
            self.viewControllers = []
            print("❌, resourceType must be defined")
        }
        
        self.selectedViewController = homeNav
    }
    
    func logout() {
        MemberManager.shared.logoutForSwitchServer()
    }
}
