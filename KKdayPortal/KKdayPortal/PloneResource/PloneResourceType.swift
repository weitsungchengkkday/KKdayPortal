//
//  PloneResourceType.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/2/20.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation

enum PloneResourceType {
    case normal
    case kkMember
    case none
    
    enum CodingKeys: CodingKey {
        case normal
        case rawValue
    }
}

extension PloneResourceType: Codable {
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .normal:
            try container.encode(0, forKey: .normal)
        case .kkMember:
            try container.encode(1, forKey: .rawValue)
        case .none:
            try container.encode(2, forKey: .rawValue)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let rawValue = try? container.decode(Int.self, forKey: .rawValue) {
            switch rawValue {
            case 0:
                self = .normal
            case 1:
                self = .kkMember
            case 2:
                self = .none
            default:
                self = .none
            }
            return
        }
        
        self = .none
        return
    }
}
