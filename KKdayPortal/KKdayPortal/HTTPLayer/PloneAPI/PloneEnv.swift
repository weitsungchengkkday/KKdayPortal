//
//  PloneEnv.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/11/12.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import DolphinHTTP


extension ServerEnvironment {
   
    static let PloneSit = ServerEnvironment(host: "sit.eip.kkday.net", pathPrefix: "/Plone", headers: ["Accept" : "application/json", "Content-Type": "application/json"], query: [])
    
    static let PlonePro = ServerEnvironment(host: "eip.kkday.net", pathPrefix: "/Plone", headers: ["Accept" : "application/json", "Content-Type": "application/json"], query: [])
    
    
    
}
