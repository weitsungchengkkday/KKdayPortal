//
//  PloneCollection.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/27.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation

final class PloneCollection: PloneItem {
    
    var items: [PloneItem]?
    var text: PloneTextObject?
    
    private enum CodingKeys: String, CodingKey {
        case items
        case text
    }
    
    init(UID: String?, atID: URL?, atType: PloneItemType?, description: String?, title: String?, isFolderish: Bool?, parent: PloneItem?, id: String?, items: [PloneItem]?, text: PloneTextObject?) {
        self.items = items
        self.text = text
        
        super.init(UID: UID, atID: atID, atType: atType, description: description, title: title, isFolderish: isFolderish, parent: parent, id: id)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.items = try? container.decode([PloneItem].self, forKey: .items)
        self.text = try?
            container.decode(PloneTextObject.self, forKey: .text)
        try super.init(from: decoder)
    }
}
