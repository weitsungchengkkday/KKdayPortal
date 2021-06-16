//
//  KKdayOffice.swift
//  KKdayPortal
//
//  Created by KKday on 2021/6/15.
//  Copyright © 2021 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation

struct KKPortalTwilioConfig: Codable {
    let accessTokenURL: String
    let KKOfficesInfos: [KKOfficesInfo]
}

struct KKOfficesInfo: Codable {
    let country, countryCode: String
    let companyIdentifier: [String]
}
