//
//  PloneResourceType.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/2/20.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation

enum UserResourceType {
    case kkMember
    case custom
}

extension UserResourceType: Codable {
    
    enum Key: CodingKey {
        case rawValue
    }
    
    enum CodingError: Error {
        case unknownValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        switch rawValue {
        case 0:
            self = .kkMember
        case 1:
            self = .custom
        default:
            throw CodingError.unknownValue
        }
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        switch self {
        case .kkMember:
            try container.encode(0, forKey: .rawValue)
        case .custom:
            try container.encode(1, forKey: .rawValue)
        }
    }
}
