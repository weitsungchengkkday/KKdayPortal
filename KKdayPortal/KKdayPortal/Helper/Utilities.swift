//
//  Utilities.swift
//  KKdayPortal-Sit
//
//  Created by WEI-TSUNG CHENG on 2020/1/1.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit

struct Utilities {
    
    public static var appDelegateWindow: UIWindow? {

        guard let window: UIWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first else {
                return nil
        }

        return window
    }
    
    public static var rootViewController: UIViewController? {
        
        guard let rootViewController: UIViewController = appDelegateWindow?.rootViewController else {
            return nil
        }
        
        return rootViewController
    }
    
    public static var currentViewController: UIViewController? {
        return getCurrentViewController(viewController: rootViewController)
    }

    private static func getCurrentViewController(viewController: UIViewController?) -> UIViewController? {

        switch viewController {
        case let navigationController as UINavigationController:
            return getCurrentViewController(viewController: navigationController.visibleViewController)

        case let tabBarViewController as UITabBarController:
            return getCurrentViewController(viewController: tabBarViewController.selectedViewController)

        default:

            guard let presentedViewController: UIViewController = viewController?.presentedViewController else {
                return viewController
            }

            return getCurrentViewController(viewController: presentedViewController)
        }
    }
}
