//
//  PloneLink.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/28.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation

final class PloneLink: PloneItem {
    var remoteURL: URL
    var linkTitle: String
    
    private enum CodingKeys: String, CodingKey {
        case remoteURL = "remoteUrl"
        case linkTitle = "title"
    }
    
    init(atID: URL, atType: PloneItemType, description: String, title: String, isFolderish: Bool, parent: PloneItem, remoteURL: URL, linkTitle: String) {
        self.remoteURL = remoteURL
        self.linkTitle = linkTitle
    
        super.init(atID: atID, atType: atType, description: description, title: title, isFolderish: isFolderish, parent: parent)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.remoteURL = try container.decode(URL.self, forKey: .remoteURL)
        self.linkTitle = try container.decode(String.self, forKey: .linkTitle)
        try super.init(from: decoder)
    }
}
