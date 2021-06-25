//
//  AppDelegate.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/21.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import DolphinHTTP

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        #if SIT
        print("1️⃣ sit")
        
        #elseif PRODUCTION
        print("2️⃣ production")
        
        #elseif OPEN
        print("0️⃣ open")
        
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
        
        LanguageManager.shared.setup()
        NetStatusManager.sharedIntance?.startMonitoring()

        loadLocalizationFileFromWebService()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }
    
    private func loadLocalizationFileFromWebService() {
        
        let api = LocalizationAPI(loader: URLSessionLoader())
        
        guard let url = URL(string: "https://chamoisee-millipede-6821.twil.io") else {
            print("localization files host not exist")
            return
        }
        
        let group = DispatchGroup()
        let langs: [String] = ["en", "zh-Hans", "zh-Hant", "zh-HK", "ja", "ko", "vi"]
        
        for lang in langs {
            
            group.enter()
            api.getLocalizationFile(url: url, language: lang) { result in
                
                switch result {
                case .success(let data):
                    
                    let fileAdmin = FileAdministrator()
                    let locationURL = FileManager.documentDirectoryURL
                        .appendingPathComponent("Localization")
                    _ = fileAdmin.createDirectoryWithURL(withName: "\(lang).lproj", withURL: locationURL)
                    
                    let url = locationURL
                        .appendingPathComponent("\(lang).lproj")
                        .appendingPathComponent("Localizable")
                        .appendingPathExtension("strings")
                    
                    do {
                        try data.write(to: url)
                        
                    } catch {
                        print("⚠️ write localization \(lang)  file failed, error: \(error)")
                    }
                    
                case .failure(let error):
                    print("⚠️ get localization \(lang) file failed, error: \(error)")
                }
                
                group.leave()
                
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            NotificationCenter.default.post(name: LanguageManager.NotificationChangeLanguageName, object: LanguageManager.shared.currentLanguage, userInfo: nil)
        }
    }
    
}
