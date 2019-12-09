//
//  GeneralItem.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/6.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum GeneralItemType {
    case root
    case folder
    case collection
    case image
    case document
    case news
    case event
    case file
    case link
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
         
         imageObject: GeneralImageObject?,
         textObject: GeneralTextObject?,
         eventObject: GeneralEventObject?,
         fileObject: GeneralFileObject?,
         linkObject: GeneralLinkObject?) {
        
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
