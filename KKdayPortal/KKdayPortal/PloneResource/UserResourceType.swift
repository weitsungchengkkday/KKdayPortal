//
//  PloneResourceType.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/2/20.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation

enum UserResourceType<U: Codable> {
    case kkMember
    case custom(U)
}

extension UserResourceType: Codable {
    
    enum Key: CodingKey {
        case rawValue
        case associatedValue
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
            let value = try container.decode(U.self, forKey: .associatedValue)
            self = .custom(value)
            
        default:
            throw CodingError.unknownValue
        }
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        switch self {
        case .kkMember:
            try container.encode(0, forKey: .rawValue)
        case .custom(let value):
            try container.encode(1, forKey: .rawValue)
            try container.encode(value, forKey: .associatedValue)
        }
    }
}
