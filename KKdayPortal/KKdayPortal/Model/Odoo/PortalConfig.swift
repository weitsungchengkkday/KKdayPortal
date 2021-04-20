//
//  PortalConfig.swift
//  KKdayPortal
//
//  Created by KKday on 2021/4/12.
//  Copyright © 2021 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation

struct PortalConfig: Codable {
    let meta: PortalMeta
    let data: PortalData
    let status: PortalStatus
}

struct PortalMeta: Codable {
    let data_count: Int
    let total_count: Int
}

struct PortalData: Codable {
    let login: PortalLogin
    let services: [PortalService]
}

struct PortalLogin: Codable {
    let url: String
    let auth_n: String
    let auth_z: String
}

struct PortalService: Codable {
    let type: String
    let name: String
    let url: String
}

struct PortalStatus: Codable {
    let code: String
    let message: String
    let detail: String
}
