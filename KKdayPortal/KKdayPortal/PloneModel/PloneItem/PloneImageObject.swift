//
//  PloneImageObject.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/28.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation

final class PloneImageObject: Codable {
    var contentType: String
    var name: String
    var url: URL
    
    private enum CodingKeys: String, CodingKey {
        case contentType = "content-type"
        case name = "filename"
        case url = "download"
    }
    
    init(contentType: String, name: String, url: URL) {
        self.contentType = contentType
        self.name = name
        self.url = url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.contentType = try container.decode(String.self, forKey: .contentType)
        self.name = try container.decode(String.self, forKey: .name)
        self.url = try container.decode(URL.self, forKey: .url)
    }
    
    
}

