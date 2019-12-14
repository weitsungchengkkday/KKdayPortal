//
//  Localizable.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/15.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit

protocol Localizable: class {
    var observerLanguageChangedNotification: NSObjectProtocol? { get set }
    func refreshLanguage(_ nofification: Notification)
}

extension Localizable where Self: UIViewController {

    func reigisterLanguageManager() {
        let notificationCenter = NotificationCenter.default

        observerLanguageChangedNotification = notificationCenter.addObserver(forName: LanguageManager.NotificationChangeLanguageName, object: nil, queue: nil, using: { [weak self] (notification) in
            self?.refreshLanguage(notification)
        })
    }

    func unregisterLanguageManager() {
        guard let observerLanguageChangedNotification = observerLanguageChangedNotification else {
            return
        }

        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(observerLanguageChangedNotification)
    }
}
