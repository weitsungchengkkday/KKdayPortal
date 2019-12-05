//
//  PloneNews.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/28.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation

final class PloneNews: PloneItem {
    
    var text: PloneTextObject?
    var image: PloneImageObject?
    
    private enum CodingKeys: String, CodingKey {
         case text
         case image
     }
     
    init(UID: String?, atID: URL?, atType: PloneItemType?, description: String?, title: String?, isFolderish: Bool?, parent: PloneItem?, id: String?, text: PloneTextObject?, image: PloneImageObject?) {
         self.text = text
         self.image = image
         
        super.init(UID: UID, atID: atID, atType: atType, description: description, title: title, isFolderish: isFolderish, parent: parent, id: id)
     }
     
     required init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
         self.text = try? container.decode(PloneTextObject.self, forKey: .text)
         self.image = try? container.decode(PloneImageObject.self, forKey: .image)
         try super.init(from: decoder)
     }
}
