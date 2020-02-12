//
//  MemberManager.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/2/12.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

final class MemberManager {
    
    static let shared = MemberManager()
    var alertErrorInfo: AlertEventInfo?

    private init() {}
    
    func notifyAlertEvent(_ error: Error, userInfo: [AnyHashable : Any]? = nil) {
        
        if let error = error as? HTTPError {
            self.alertErrorInfo = AlertEventInfo(error: error,
                                             message: error.message)
        } else {
            self.alertErrorInfo = AlertEventInfo(error: error, message: error.localizedDescription)
        }
         
        NotificationCenter.default.post(name: Notification.Name.alertEvent, object: self, userInfo: userInfo)
    }
    
    func showAlertController(_ presentedViewController: UIViewController, with disposeBag: DisposeBag) {
        
        guard let alertErrorInfo = self.alertErrorInfo else {
            return
        }
        
        self.alertErrorInfo = nil
        
        let alertControlloer = UIAlertController(title: "Warning", message: alertErrorInfo.message, preferredStyle: .alert)
        
        let okAlertAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            if let error = alertErrorInfo.error as? HTTPError {
                switch error {
                case .unauthorized, .forbidden, .notFound, .clientError:
                    self?.logout(disposeBag: disposeBag)
                default:
                    break
                }
            }
        }
        
        alertControlloer.addAction(okAlertAction)
        presentedViewController.present(alertControlloer, animated: true, completion: nil)
    }
    
    func logout(disposeBag: DisposeBag) {
        
        // Logout from Plone
        ModelLoader.PortalLoader()
            .logout()
            .subscribe(onSuccess: { generalUser in
                debugPrint("👥 Logout -> General User: \(generalUser)")
                
            }) { error in
                
                debugPrint("🚨 logout -> error is \(error)")}
            .disposed(by: disposeBag)
        
        // Clear UserDefault
        StorageManager.shared.removeAll()
        // Clear WebCache
        WebCacheCleaner.clean()
        
        // 👶🏻 Restart from login page
        let loginController = LoginViewController(viewModel: LoginViewModel())
        Utilities.appDelegateWindow?.rootViewController = loginController
    }
}
