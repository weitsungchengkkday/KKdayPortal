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
    
    var portalservices: [PortalService] = []
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
    
        
        
#if OPEN
    print("0️⃣ open")
#elseif SIT
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
        
        // Twilio Call Service
        self.pushKitEventDelegate = TwilioServiceManager.shared.twiVC
        initializePushKit()
        
        // Get Plone andc Odoo Service Host
        ConfigManager.shared.setup()
        
        getPorServices()
        
        LanguageManager.shared.setup()
        
        return true
    }
    
    
    private func getPorServices() {
        
        PortalServiceAPI(loader: URLSessionLoader()).loadPortalService { result in
        
            switch result {
            case .success(let services):
                self.portalservices = services
                self.getServiceElements()
                
            case .failure(let error):
                print("Load Portal Services Error: \(error)")
                break
            }
            
        }
    }
    
    private func getServiceElements() {
        
        let group = DispatchGroup()
        
        for service in self.portalservices {
            
            group.enter()
            PortalServiceElementAPI(loader: URLSessionLoader()).loadPortalServiceElement(serviceID: service.id) { result in
                
                switch result {
                case .success(let response):
                    let index = self.portalservices.firstIndex { $0.id == service.id }
                    
                    if index == nil {
                        print("❌ cant get portal service index")
                        return
                    }
                    self.portalservices[index!].elements = response
                    
                case .failure(let error):
                    print("❌ get portal service element failed. \(error)")
                }
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            
            for service in self.portalservices {
             
                switch service.name {
                case "Plone":
                    StorageManager.shared.saveObject(for: .plonePortalService, value: service)
                    
                    let ser: PortalService? = StorageManager.shared.loadObject(for: .plonePortalService)
                    print(ser!.elements)
                default:
                    break
                }
            }
        }
        
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
            print("〽️recieve payload: \(payload.dictionaryPayload) ")
           
            delegate.incomingPushReceived(payload: payload, completion: completion)
            
        } else {
            print("〽️⚠️ pushKitEventDelegate is not set")
        }

    }
    
}
