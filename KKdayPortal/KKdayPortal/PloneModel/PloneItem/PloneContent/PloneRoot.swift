//
//  PloneRoot.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/27.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation

final class PloneRoot: PloneItem {
 
    var items: [PloneItem]
    
    private enum CodingKeys: String, CodingKey {
        case items = "items"
    }
    
    init(atID: URL, atType: PloneItemType, description: String, title: String, isFolderish: Bool, parent: PloneItem, items: [PloneItem]) {
        self.items = items
        super.init(atID: atID, atType: atType, description: description, title: title, isFolderish: isFolderish, parent: parent)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.items = try container.decode([PloneItem].self, forKey: .items)
        try super.init(from: decoder)
    }
    
}
