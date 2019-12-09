//
//  GeneralList.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/6.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation

final class GeneralList: GeneralItem {
    var items: [GeneralItem]?
    
    init(type: GeneralItemType?, title: String?, description: String?, parent: GeneralItem?, id: String?, UID: String?, source: URL?, imageObject: GeneralImageObject?, textObject: GeneralTextObject?, eventObject: GeneralEventObject?, fileObject: GeneralFileObject?, linkObject: GeneralLinkObject?, items: [GeneralItem]?) {
        self.items = items
        super.init(type: type, title: title, description: description, parent: parent, id: id, UID: UID, source: source, imageObject: imageObject, textObject: textObject, eventObject: eventObject, fileObject: fileObject, linkObject: linkObject)
    }
}
