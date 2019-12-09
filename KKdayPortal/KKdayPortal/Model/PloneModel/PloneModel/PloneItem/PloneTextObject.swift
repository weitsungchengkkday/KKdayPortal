//
//  PloneTextObject.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/28.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation

final class PloneTextObject: Codable {
    var contentType: String
    var data: String
    var encoding: String
    
    private enum CodingKeys: String, CodingKey {
        case contentType = "content-type"
        case data 
        case encoding
    }
    
    init(contentType: String, data: String, encoding: String) {
        self.contentType = contentType
        self.data = data
        self.encoding = encoding
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.contentType = try container.decodeIfPresent(String.self, forKey: .contentType) ?? ""
        self.data = try container.decodeIfPresent(String.self, forKey: .data) ?? ""
        self.encoding = try container.decodeIfPresent(String.self, forKey: .encoding) ?? ""
    }
    
}



