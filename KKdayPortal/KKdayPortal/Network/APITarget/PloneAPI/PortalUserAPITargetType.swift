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
      #if SIT_VERSION
        #if DEBUG
        let baseURLString = "http://localhost:8080/pikaPika"
        #else
        let baseURLString = "https://sit.eip.kkday.net/Plone"
        #endif
        
      #elseif PRODUCTION_VERSION
        let baseURLString = "https://eip.kkday.net/Plone"
      #else
      print("Not Implement")
      #endif
      
        return URL(string: baseURLString)!
    }
    
    var sampleData: Data {
        return Data()
    }
}



