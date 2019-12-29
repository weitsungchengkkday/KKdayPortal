//
//  AppDelegate.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/21.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    setupLanguage()
    
    #if SIT_VERSION
    print("1️⃣ sit_version")
    #elseif STAGE_VERSION
    print("2️⃣ stage_version")
    #elseif PRODUCTION_VERSION
    print("3️⃣ production_version")
    #elseif TEST_VERSION
    print("4️⃣ test_version")
    #else
    print("❗️target not exist")
    #endif
    
    #if DEBUG
    print("🐛 Debug")
    #elseif RELEASE
    print("🦋 Release")
    #else
    print("❗️configuration not exist")
    #endif
    
        return true
    }
    
    private func setupLanguage() {
        LanguageManager.shared.setup()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

