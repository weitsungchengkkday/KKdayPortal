//
//  MainViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/15.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBarItems()
    }
    
    private func setupTabBarItems() {
        let homeVC = HomeViewController(nibName: nil, bundle: nil)
    
        homeVC.view.backgroundColor = UIColor.white
        let homeItem = UITabBarItem(title: "Home", image: #imageLiteral(resourceName: "icTabHomeDafault"), selectedImage: #imageLiteral(resourceName: "icTabHomePrimary"))
        homeVC.tabBarItem = homeItem
    
        let homeNav = UINavigationController(rootViewController: homeVC)
        
        
        homeNav.navigationBar.barTintColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        homeNav.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        
        let settingVC = SettingViewController(nibName: nil, bundle: nil)
        settingVC.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let settingItem = UITabBarItem(title: "Setting", image: #imageLiteral(resourceName: "icTabUserDafault"), selectedImage: #imageLiteral(resourceName: "icTabUserPrimary"))
        settingVC.tabBarItem = settingItem
        let settingNav = UINavigationController(rootViewController: settingVC)
        settingNav.navigationBar.barTintColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        settingNav.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        
        let applicationsEntryVC = ApplicationsEntryViewController(nibName: nil, bundle: nil)
        let applicationsEntryItem = UITabBarItem(title: "Application Entry", image: #imageLiteral(resourceName: "icListPrimaryDefault"), selectedImage: #imageLiteral(resourceName: "icListPrimary"))
        applicationsEntryVC.tabBarItem = applicationsEntryItem
        let applicationsEntryNav = UINavigationController(rootViewController: applicationsEntryVC)
        applicationsEntryNav.navigationBar.barTintColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        applicationsEntryNav.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        
        self.tabBar.barTintColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        self.tabBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.viewControllers = [applicationsEntryNav, homeNav, settingNav]
        self.selectedViewController = homeNav
    }
}
