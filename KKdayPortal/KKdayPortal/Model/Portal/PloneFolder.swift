//
//  Folder.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/25.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation

class PloneFolder: PloneItemType, Codable {
    var atID: URL
    var atType: String
    var description: String = ""
    var title: String = ""
    
    var items: [PloneCategory] = []
    
    init(atID: URL, atType: String) {
        self.atID = atID
        self.atType = atType
    }
}
