//
//  AppDelegate.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/21.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
#if TEST_VERSION
    print("1️⃣ test_version")
    
#elseif SIT_VERSION
    print("2️⃣ sit_version")
    
#elseif STAGE_VERSION
    print("3️⃣ stage_version")
    
#elseif PRODUCTION_VERSION
    print("4️⃣ production_version")
    
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
    
    ConfigManager.shared.setup()
    APIManager.default.httpErrorHandler = WebAPIManager.shared
    setupLanguage()
    
        return true
    }
    
    private func setupLanguage() {
        LanguageManager.shared.setup()
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

