//
//  PloneLRF.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/1/7.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation

final class PloneLRF: PloneItem {
 
    var items: [PloneItem]?
    
    private enum CodingKeys: String, CodingKey {
        case items
    }
    
    init(UID: String?, atID: URL?, atType: PloneItemType?, description: String?, title: String?, isFolderish: Bool?, parent: PloneItem?, id: String?, items: [PloneItem]?) {
        self.items = items
        super.init(UID: UID, atID: atID, atType: atType, description: description, title: title, isFolderish: isFolderish, parent: parent, id: id)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.items = try? container.decode([PloneItem].self, forKey: .items)
        try super.init(from: decoder)
    }
}

