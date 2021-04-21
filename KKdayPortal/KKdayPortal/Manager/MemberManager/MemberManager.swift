//
//  MemberManager.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/2/12.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import UIKit
import DolphinHTTP

final class MemberManager {
    
    static let shared = MemberManager()
    var alertErrorInfo: AlertEventInfo?
    
    private init() {}
    
    func notifyAlertEvent(_ error: Error, userInfo: [AnyHashable : Any]? = nil) {
        
        if let error = error as? HTTPError {
            self.alertErrorInfo = AlertEventInfo(error: error,
                                                 message: error.localizedDescription)
        } else {
            self.alertErrorInfo = AlertEventInfo(error: error, message: error.localizedDescription)
        }
        
        NotificationCenter.default.post(name: Notification.Name.alertEvent, object: self, userInfo: userInfo)
    }
    
    func showAlertController(_ presentedViewController: UIViewController) {
        
        guard let alertErrorInfo = self.alertErrorInfo else {
            return
        }
        
        self.alertErrorInfo = nil
        
        let alertControlloer = UIAlertController(title: "Warning", message: alertErrorInfo.message, preferredStyle: .alert)
        
        let okAlertAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            if let error = alertErrorInfo.error as? HTTPError {
                print(error)
            }
            self?.logout()
        }
        
        alertControlloer.addAction(okAlertAction)
        presentedViewController.present(alertControlloer, animated: true, completion: nil)
    }
    
    func logout() {
        
        logoutHandler()
 
    }
    
    // Must clear UserDefualt after logout request finishing, or it might cause logout error
    private func logoutHandler() {

        // 👶🏻 Restart from signin page
        let loginController = UserGuideViewController(viewModel: UserGuideViewModel())
        Utilities.appDelegateWindow?.rootViewController = loginController
        
        // Clear UserDefault
        StorageManager.shared.removeAll()
        
        // Clear WebCache
        WebCacheCleaner.clean()
        
        // Reset serverType & language after clear UserDefault
        ConfigManager.shared.setup()
        LanguageManager.shared.setup()
    }
    
    func logoutForSwitchServer() {
        
        logoutForSwitchServerHandler()
        
    }
    
    private func logoutForSwitchServerHandler() {
        
        // 👶🏻 Restart from signin page
        let loginController = UserGuideViewController(viewModel: UserGuideViewModel())
        Utilities.appDelegateWindow?.rootViewController = loginController
        
        // Clear UserDefault(keep language, Region)
        // Should not clear StorageKeys .serverEnv, or changed serverEnv info would disappear.
        StorageManager.shared.remove(for: .generalUser)
        StorageManager.shared.remove(for: .ploneResourceType)
        
        StorageManager.shared.remove(for: .portalConfig)
        
        // Clear WebCache
        WebCacheCleaner.clean()
        
        // Must setup after logout, or it would logout wrong server
        ConfigManager.shared.setup()
    }
}
