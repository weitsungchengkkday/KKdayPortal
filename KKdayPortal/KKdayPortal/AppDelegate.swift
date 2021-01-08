//
//  AppDelegate.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/21.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import PushKit
import TwilioVoice
import DolphinHTTP

protocol PushKitEventDelegate: AnyObject {
    func credentialsUpdated(credentials: PKPushCredentials) -> Void
    func credentialsInvalidated() -> Void
    func incomingPushReceived(payload: PKPushPayload, completion: @escaping () -> Void) -> Void
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var pushKitEventDelegate: PushKitEventDelegate?
    var voipRegistry = PKPushRegistry.init(queue: .main)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Twilio Call Service
        self.pushKitEventDelegate = TwilioServiceManager.shared.twiVC
        initializePushKit()
        
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
        
        // Get Plone andc Odoo Service Host
        ConfigManager.shared.setup()
        
        // Note must after ConfigManager.shared.setup(), because Odoo host most be decided first
        PortalApplicationsAPI(loader: URLSessionLoader()).loadApplicationServers()
       
        LanguageManager.shared.setup()
        
        return true
    }
    
    func initializePushKit() {
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = Set([PKPushType.voIP])
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
            print("〽️ update push credentials")
            delegate.credentialsUpdated(credentials: pushCredentials)
        } else {
            print("〽️⚠️ pushKitEventDelegate is not set")
        }
        
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        print("〽️ pushRegistry:didInvalidatePushTokenForType:")
        
        if let delegate = self.pushKitEventDelegate {
            print("〽️⚠️ Invalidate Push Token")
            delegate.credentialsInvalidated()
        } else {
            print("〽️⚠️ pushKitEventDelegate is not set")
        }
        
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        print("〽️ pushRegistry:didReceiveIncomingPushWithPayload:forType:completion:")
        print(type.rawValue)

        if let delegate = self.pushKitEventDelegate {
            print("〽️recieve payload: \(payload) ")
            delegate.incomingPushReceived(payload: payload, completion: completion)
            
        } else {
            print("〽️⚠️ pushKitEventDelegate is not set")
        }

    }
    
}
