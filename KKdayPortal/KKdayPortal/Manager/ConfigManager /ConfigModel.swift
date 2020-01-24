//
//  ConfigModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/1/20.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

final class ConfigModel: Codable {
    
    // current connecting host
    var host: String = ""
    var token: String = ""
    
    // sit
    var sitServer: String = ""
    var sitToken: String = ""
    
    // production
    var productionServer: String = ""
    var productionToken: String = ""
}
