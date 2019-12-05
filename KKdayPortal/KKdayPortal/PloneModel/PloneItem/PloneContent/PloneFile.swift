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
        case file 
    }
    
    init(UID: String?, atID: URL?, atType: PloneItemType?, description: String?, title: String?, isFolderish: Bool?, parent: PloneItem?, id: String?, file: PloneFileObject) {
        self.file = file
        super.init(UID: UID, atID: atID, atType: atType, description: description, title: title, isFolderish: isFolderish, parent: parent, id: id)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.file = try container.decode(PloneFileObject.self, forKey: .file)
        try super.init(from: decoder)
    }
}
