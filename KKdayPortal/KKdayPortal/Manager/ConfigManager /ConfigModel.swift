//
//  ConfigModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/1/20.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

final class ConfigModel: Codable {
    // current connecting host
    var name: String = ""
    var host: String = ""
    var sitServer: String = ""
    var productionServer: String = ""
}
