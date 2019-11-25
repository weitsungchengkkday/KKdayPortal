//
//  PortalUserAPITargetType.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/22.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//
import Foundation
protocol PortalUserAPITargetType: CodableResponseType {
     
}

extension PortalUserAPITargetType {

    var baseURL: URL {
        let baseURLString = "http://localhost:8080/pikaPika"
        return URL(string: baseURLString)!
    }
    
    var sampleData: Data {
        return Data()
    }
}



