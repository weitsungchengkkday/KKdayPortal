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
    private init() {}
    
    func logout() {
        // 👶🏻 Restart from User Guide Page
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
    
}
