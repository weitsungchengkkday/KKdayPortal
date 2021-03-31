//
//  ApplicationSever.swift
//  KKdayPortal
//
//  Created by KKday on 2020/12/22.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation

struct PortalService: Codable {
    let id: Int
    let name: String
    let service_type: String
    let portal_service_element: [Int]
    var elements: [PortalServiceElement]
    
    enum AdditionalKeys: String, CodingKey {
            case description = "longDescription"
        }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        service_type = try container.decode(String.self, forKey: .service_type)
        portal_service_element = try container.decode([Int].self, forKey: .portal_service_element)
        elements = try container.decodeIfPresent([PortalServiceElement].self, forKey: .elements) ?? []
    }
    
}

struct PortalServiceElement: Codable {
    let id: Int
    let name: String
    let main_category: String
    
    let sub_category: String
    let content: String
    let service_element_id_num: Int
}
