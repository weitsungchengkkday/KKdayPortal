//
//  PloneFile.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/28.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation

final class PloneFile: PloneItem {
    
    var file: PloneFileObject
    
    private enum CodingKeys: String, CodingKey {
        case file = "file"
    }
    
    init(atID: URL, atType: PloneItemType, description: String, title: String, isFolderish: Bool, parent: PloneItem, file: PloneFileObject) {
        self.file = file
        super.init(atID: atID, atType: atType, description: description, title: title, isFolderish: isFolderish, parent: parent)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.file = try container.decode(PloneFileObject.self, forKey: .file)
        try super.init(from: decoder)
    }
}
