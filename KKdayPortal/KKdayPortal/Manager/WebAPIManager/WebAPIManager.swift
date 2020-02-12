//
//  WebAPIManager.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/2/12.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation

final class WebAPIManager: ErrorManageable {

    static let shared = WebAPIManager()
    private init() {}
    
    func handle(error: Error) {
        MemberManager.shared.notifyAlertEvent(error)
    }
}
