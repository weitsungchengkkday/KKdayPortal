//
//  PloneItemType.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/25.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation

protocol PloneItemType {
    var atID: URL { get }
    var atType: String { get }
    var description: String { get }
    var title: String { get }
    
    var UID: String { get }
}

extension PloneItemType {
    var UID: String {
        return ""
    }
}
