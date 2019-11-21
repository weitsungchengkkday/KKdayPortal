//
//  SceneDelegate.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/21.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
            
          guard let windowScence = (scene as? UIWindowScene) else { return }
          window = UIWindow(frame: windowScence.coordinateSpace.bounds)
          window?.windowScene = windowScence
          
          // 🏗 set TabBarViewController as rootViewController
          // TabBarViewController -> homeNav, settingNav
          // homeNav -> HomeViewController
          // settingNav -> SettingViewControlle
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
          
          let tabBarController = UITabBarController(nibName: nil, bundle: nil)
          tabBarController.viewControllers = [homeNav, settingNav]
          tabBarController.tabBar.barTintColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
          tabBarController.tabBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
          
          window?.rootViewController = tabBarController
          window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

