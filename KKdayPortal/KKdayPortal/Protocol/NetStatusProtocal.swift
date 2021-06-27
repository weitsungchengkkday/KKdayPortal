//
//  NetStatusProtocal.swift
//  Network-Framework-Notification-Version
//
//  Created by KKday on 2021/6/25.
//

import Foundation
import UIKit

protocol NetStatusProtocal: AnyObject {
    var observerNetStatusChangedNotification: NSObjectProtocol? { get set }
    func noticeNetStatusChanged(_ nofification: Notification)
}

extension NetStatusProtocal where Self: UIViewController {
    
    func registerNetStatusManager() {
        let notificationCenter = NotificationCenter.default
        observerNetStatusChangedNotification = notificationCenter.addObserver(forName: NetStatusManager.NotificationChangeNetStatusName, object: nil, queue: nil, using: { [weak self] notification in
            
            self?.noticeNetStatusChanged(notification)
        })
    }
    
    func unregisterNetStatusManager() {
        guard let observerNetStatusChangedNotification = observerNetStatusChangedNotification else {
            return
        }

        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(observerNetStatusChangedNotification)
    }
    
    
    func checkNetStatusAlert() {
        
        DispatchQueue.main.async {
            if !(NetStatusManager.sharedIntance!.isConnected) {
                
                let alertController = UIAlertController(title:"general_notice".localize("注意", defaultValue: "Notice"), message: "general_alert_no_internet_connection_message".localize("目前無法偵測到網路連線, 請檢查您的網路環境是否正常", defaultValue: "The network connection cannot be detected at the moment, please check whether your network environment is normal"), preferredStyle: .alert)
                let confirmAlertAction = UIAlertAction(title: "general_confrim".localize("確認", defaultValue: "Confirm"), style: .default) { _ in
                    self.checkNetStatusAlert()
                }
                let cancelAlertAction = UIAlertAction(title: "general_ignore".localize("忽略", defaultValue: "Ignore"), style: .cancel, handler: nil)
                
                alertController.addAction(confirmAlertAction)
                alertController.addAction(cancelAlertAction)
                
                if self.presentedViewController == nil {
                    self.present(alertController, animated: false, completion: nil)
                }
            }
        }
    }
    
    func checkNetStatusSnackBar() {
        DispatchQueue.main.async {
            if !(NetStatusManager.sharedIntance!.isConnected) {
                SnackBarManager.shared.update(mainLabelText: "general_alert_no_internet_connection_label_main".localize("", defaultValue: ""), subLabelText: "general_alert_no_internet_connection_label_sub".localize("無法偵測到網路連線", defaultValue: "請檢查您的網路環境是否正常"), buttonIcon: nil)
            } else {
                SnackBarManager.shared.dismiss()
            }
        }
        
    }
}
