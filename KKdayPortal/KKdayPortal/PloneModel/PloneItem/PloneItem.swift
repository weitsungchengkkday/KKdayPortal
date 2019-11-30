//
//  PloneCategory.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/25.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation

enum PloneItemType: String, Codable {

    case root = "Plone Site"
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
    var atID: URL
    var atType: PloneItemType
    var description: String?
    var title: String
    var isFolderish: Bool
    var parent: PloneItem?
    
    private enum CodingKeys: String, CodingKey {
        case atID = "@id"
        case atType = "@type"
        case description
        case title
        case isFolderish = "is_folderish"
        case parent
    }
    
    init(atID: URL, atType: PloneItemType, description: String, title: String, isFolderish: Bool, parent: PloneItem?) {
        self.atID = atID
        self.atType = atType
        self.description = description
        self.title = title
        self.isFolderish = isFolderish
        self.parent = parent
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.atID = try container.decode(URL.self, forKey: .atID)
        
        let rawValue = try container.decode(String.self, forKey: .atType)
        self.atType = PloneItemType(rawValue: rawValue)!
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.title = try container.decode(String.self, forKey: .title)
      
        let atType = self.atType
        let isFolderish: Bool = {
            switch atType {
            case .root, .folder:
                return true
            case .document, .news, .event, .image, .file, .link, .collection:
                return false
            }
        }()
        
        self.isFolderish = try (container.decodeIfPresent(Bool.self, forKey: .isFolderish) ?? isFolderish)
        
        self.parent = try? container.decodeIfPresent(PloneItem.self, forKey: .parent)
    }
}
