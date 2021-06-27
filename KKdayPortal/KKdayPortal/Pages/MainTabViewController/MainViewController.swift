//
//  MainViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/15.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit

final class MainViewController: UITabBarController, Localizable {
    
    var observerLanguageChangedNotification: NSObjectProtocol?
    
    func refreshLanguage(_ nofification: Notification) {
//        localizedText()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarItems()
        registerLanguageManager()
    }
    
    deinit {
        unregisterLanguageManager()
    }
    
    private func setupTabBarItems() {
        
        let homeVC = HomeViewController(nibName: nil, bundle: nil)
        
        let homeItem = UITabBarItem(title: "home_title".localize("主頁", defaultValue: "Home"), image: #imageLiteral(resourceName: "icTabHomeDafault"), selectedImage: #imageLiteral(resourceName: "icTabHomePrimary"))
        homeVC.tabBarItem = homeItem

        let homeNav = UINavigationController(rootViewController: homeVC)
        let homeBarbuttonItem = UIBarButtonItem()
        homeBarbuttonItem.title = ""
        homeNav.navigationBar.topItem?.backBarButtonItem = homeBarbuttonItem
        homeNav.navigationBar.barTintColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        homeNav.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        
        let portalVC = PortalViewController(nibName: nil, bundle: nil)
        
        let portalItem = UITabBarItem(title: "portal_title".localize("入口網站", defaultValue: "Portal"), image: #imageLiteral(resourceName: "icListPrimaryDefault"), selectedImage: #imageLiteral(resourceName: "icListPrimary"))
        portalVC.tabBarItem = portalItem

        let portalNav = UINavigationController(rootViewController: portalVC)
        let portalBarbuttonItem = UIBarButtonItem()
        portalBarbuttonItem.title = ""
        portalNav.navigationBar.topItem?.backBarButtonItem = portalBarbuttonItem
        portalNav.navigationBar.barTintColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        portalNav.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        
        let settingVC = SettingViewController(nibName: nil, bundle: nil)
        
        let settingItem = UITabBarItem(title: "setting_title".localize("設定", defaultValue: "Setting"), image: #imageLiteral(resourceName: "icTabUserDafault"), selectedImage: #imageLiteral(resourceName: "icTabUserPrimary"))
        settingVC.tabBarItem = settingItem

        let settingNav = UINavigationController(rootViewController: settingVC)
        let settingBarbuttonItem = UIBarButtonItem()
        settingBarbuttonItem.title = ""
        settingNav.navigationBar.topItem?.backBarButtonItem = settingBarbuttonItem
        settingNav.navigationBar.barTintColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        settingNav.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        
        let applicationsEntryVC = ServiceListViewController(nibName: nil, bundle: nil)
        
        let applicationsEntryImage = UIImage(systemName: "signpost.right") ?? #imageLiteral(resourceName: "icPicture")
        let applicationsEntryItem = UITabBarItem(title: "service_list_title".localize("服務列表", defaultValue: "Service List"), image: applicationsEntryImage, selectedImage: applicationsEntryImage)
        applicationsEntryVC.tabBarItem = applicationsEntryItem

        let applicationsEntryNav = UINavigationController(rootViewController: applicationsEntryVC)
        let applicationsButtonItem = UIBarButtonItem()
        applicationsButtonItem.title = ""
        applicationsEntryNav.navigationBar.topItem?.backBarButtonItem = applicationsButtonItem
        applicationsEntryNav.navigationBar.barTintColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        applicationsEntryNav.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        
        self.tabBar.barTintColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        self.tabBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        self.viewControllers = [homeNav, portalNav, applicationsEntryNav, settingNav]
        self.selectedViewController = homeNav
        
        
    }
    
    // 🧾 localization
    private func localizedText() {
        guard let viewControllers = viewControllers, viewControllers.count > 0 else {
            return
        }
        
        guard let navC = viewControllers as? [UINavigationController] else {
            return
        }
        
        let homeItem = UITabBarItem(title: "home_title".localize("主頁", defaultValue: "Home"), image: #imageLiteral(resourceName: "icTabHomeDafault"), selectedImage: #imageLiteral(resourceName: "icTabHomePrimary"))
        
        let portalItem = UITabBarItem(title: "portal_title".localize("入口網站", defaultValue: "Portal"), image: #imageLiteral(resourceName: "icListPrimaryDefault"), selectedImage: #imageLiteral(resourceName: "icListPrimary"))
        
        let settingItem = UITabBarItem(title: "setting_title".localize("設定", defaultValue: "Setting"), image: #imageLiteral(resourceName: "icTabUserDafault"), selectedImage: #imageLiteral(resourceName: "icTabUserPrimary"))
        
        let applicationsEntryImage = UIImage(systemName: "signpost.right") ?? #imageLiteral(resourceName: "icPicture")
        let applicationsEntryItem = UITabBarItem(title: "service_list_title".localize("服務列表", defaultValue: "Service List"), image: applicationsEntryImage, selectedImage: applicationsEntryImage)
        
        navC[0].viewControllers.first?.tabBarItem = homeItem
        navC[1].viewControllers.first?.tabBarItem = portalItem
        navC[2].viewControllers.first?.tabBarItem = settingItem
        navC[3].viewControllers.first?.tabBarItem = applicationsEntryItem
    }
}
