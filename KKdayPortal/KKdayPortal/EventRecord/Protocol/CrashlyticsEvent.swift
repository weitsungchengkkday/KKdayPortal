//
//  CrashlyticsEvent.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/8.
//  Copyright © 2019 com.inventory.kkday.www. All rights reserved.
//

import Crashlytics

protocol CrashlyticsEvent {
    func recordError(error: Error, withAdditionUserInfo: [String: Any]?)
}

extension CrashlyticsEvent {
    func recordError(error: Error, withAdditionUserInfo: [String: Any]? = nil) {
        Crashlytics.sharedInstance().recordError(error, withAdditionalUserInfo: withAdditionUserInfo)
    }
}
