//
//  ServerEnv.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/1/20.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

enum ServerEnv: String {
    case sit
    case production
    case local
}

extension ServerEnv {
    var identity: String {
        switch self {
        case .sit:
            return "sit"
        case .production:
            return "production"
        case .local:
            return "local"
        }
    }
}


