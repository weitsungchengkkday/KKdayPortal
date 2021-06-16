//
//  KKdayOffice.swift
//  KKdayPortal
//
//  Created by KKday on 2021/6/15.
//  Copyright © 2021 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation

struct KKOffices: Codable {
    let officesInfo: [KKOfficesInfo]
}

struct KKOfficesInfo: Codable {
    let country, countryCode: String
    let companyIdentifier: [String]
}
