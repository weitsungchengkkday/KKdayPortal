//
//  GeneralItem.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/6.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import UIKit

enum GeneralItemType {
    case root
    case root_with_language
    case folder
    case collection
    case image
    case document
    case news
    case event
    case file
    case link
}

extension GeneralItemType {
    
    var image: UIImage {
    
        let systemName: String

        switch self {
        case .root:
            systemName = "house"
        case .root_with_language:
            systemName = "house.fill"
        case .folder:
            systemName = "folder.fill"
        case .collection:
            systemName = "tray.full.fill"
        case .image:
            systemName = "photo"
        case .document:
            systemName = "doc.fill"
        case .news:
            systemName = "antenna.radiowaves.left.and.right"
        case .event:
            systemName = "calendar"
        case .file:
            systemName = "paperclip"
        case .link:
            systemName = "globe"
        }
        
        guard let image = UIImage(systemName: systemName) else {
            return #imageLiteral(resourceName: "icPicture")
        }
        return image
    }
}

class GeneralItem {
    var type: GeneralItemType?
    var title: String?
    var description: String?
    
    var parent: GeneralItem?
    
    var id: String?
    var UID: String?
    var source: URL?
    
    var imageObject: GeneralImageObject?
    var textObject: GeneralTextObject?
    var eventObject: GeneralEventObject?
    var fileObject: GeneralFileObject?
    var linkObject: GeneralLinkObject?
    
    init(type: GeneralItemType?,
         title: String?,
         description: String?,
         parent: GeneralItem?,
         id: String?,
         UID: String?,
         source: URL?,
         
         imageObject: GeneralImageObject? = nil,
         textObject: GeneralTextObject? = nil,
         eventObject: GeneralEventObject? = nil,
         fileObject: GeneralFileObject? = nil,
         linkObject: GeneralLinkObject? = nil) {
        
        self.type = type
        self.title = title
        self.description = description
        self.parent = parent
        self.id = id
        self.UID = UID
        self.source = source
        
        self.imageObject = imageObject
        self.textObject = textObject
        self.eventObject = eventObject
        self.fileObject = fileObject
        self.linkObject = linkObject
    }
}
