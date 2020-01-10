//
//  PloneCategory.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/25.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation

enum PloneItemType: String, Codable {
    case lrf = "LRF"
    case ploneSite = "Plone Site"
    case folder = "Folder"
    case document = "Document"
    case news = "News Item"
    case event = "Event"
    case image = "Image"
    case file = "File"
    case link = "Link"
    case collection = "Collection"
}

class PloneItem: Codable {

    var UID: String?
    var atID: URL?
    var atType: PloneItemType?
    var description: String?
    var title: String?
    var isFolderish: Bool?
    var parent: PloneItem?
    var id: String?
    
    private enum CodingKeys: String, CodingKey {
        case UID
        case atID = "@id"
        case atType = "@type"
        case description
        case title
        case isFolderish = "is_folderish"
        case parent
        case id = "id"
    }
    
    init(UID: String?, atID: URL?, atType: PloneItemType?, description: String?, title: String?, isFolderish: Bool?, parent: PloneItem?, id: String?) {
        self.UID = UID
        self.atID = atID
        self.atType = atType
        self.description = description
        self.title = title
        self.isFolderish = isFolderish
        self.parent = parent
        self.id = id
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.UID = try? container.decodeIfPresent(String.self, forKey: .UID)
        self.atID = try? container.decode(URL.self, forKey: .atID)
        
        if let rawValue = try? container.decode(String.self, forKey: .atType) {
            self.atType = PloneItemType(rawValue: rawValue)
        } else {
            self.atType = nil
        }
        
        self.description = try? container.decode(String.self, forKey: .description)
        self.title = try? container.decode(String.self, forKey: .title)
        
        self.isFolderish = try? container.decodeIfPresent(Bool.self, forKey: .isFolderish)
        
        self.parent = try? container.decodeIfPresent(PloneItem.self, forKey: .parent)
        self.id = try? container.decodeIfPresent(String.self, forKey: .id)
    }
}
