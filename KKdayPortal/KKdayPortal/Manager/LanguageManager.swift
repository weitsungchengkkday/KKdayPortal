//
//  LanquageManager.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/13.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//
import Foundation
import UIKit

final class LanguageManager {
    
    static let shared: LanguageManager = LanguageManager()
    
    static var NotificationChangeLanguageName: Notification.Name {
        return Notification.Name.init("LanguageChanged")
    }
    
    var currentLanguage: Language = Language.en {
        didSet {
            
            Language.userSelectedLanguage = currentLanguage
            
            NotificationCenter.default.post(name: LanguageManager.NotificationChangeLanguageName, object: currentLanguage, userInfo: nil)
        }
    }
    
    var webServiceLanguageLoad: Bool? = false
    
    private init() {
        
    }
    
    func setup() {
        
        if Language.isUserSelectedLanguage,
            let language: Language = Language.userSelectedLanguage {
            self.currentLanguage = language
        } else {
            self.currentLanguage = Language.systemPreferedLanguage
        }
        
    }
    
}
