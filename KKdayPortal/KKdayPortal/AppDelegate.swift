//
//  AppDelegate.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/21.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import PushKit

protocol PushKitEventDelegate: AnyObject {
    func credentialsUpdated(credentials: PKPushCredentials) -> Void
    func credentialsInvalidated() -> Void
    func incomingPushReceived(payload: PKPushPayload, completion: @escaping () -> Void) -> Void
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    weak var pushKitEventDelegate: PushKitEventDelegate?
    var voipRegistry = PKPushRegistry(queue: DispatchQueue.main)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
#if SIT
    print("1️⃣ sit")
#elseif PRODUCTION
    print("2️⃣ production")
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
        LanguageManager.shared.setup()
        
        // Initialize PushKit
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = Set([PKPushType.voIP])
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
}

// MARK: PKPushRegistryDelegate
extension AppDelegate: PKPushRegistryDelegate {
    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        print("〽️ pushRegistry:didUpdatePushCredentials:forType:")
        
        if let delegate = self.pushKitEventDelegate {
            delegate.credentialsUpdated(credentials: pushCredentials)
        } else {
            print("〽️⚠️ pushKitEventDelegate is not set")
        }
        
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        print("〽️ pushRegistry:didInvalidatePushTokenForType:")
        
        if let delegate = self.pushKitEventDelegate {
            delegate.credentialsInvalidated()
        } else {
            print("〽️⚠️ pushKitEventDelegate is not set")
        }
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        print("〽️ pushRegistry:didReceiveIncomingPushWithPayload:forType:completion:")
        
        if let delegate = self.pushKitEventDelegate {
            delegate.incomingPushReceived(payload: payload, completion: completion)
        } else {
            print("〽️⚠️ pushKitEventDelegate is not set")
        }
        
        completion()
    }
    
}
