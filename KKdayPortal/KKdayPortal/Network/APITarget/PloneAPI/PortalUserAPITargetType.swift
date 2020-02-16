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
        
#if TEST_VERSION
        let baseURLString = "https://sit.eip.kkday.net/Plone"
       
#elseif SIT_VERSION
        let baseURLString = "https://sit.eip.kkday.net/Plone"
        
#elseif PRODUCTION_VERSION
        let baseURLString = "https://eip.kkday.net/Plone"
    
#else
        
#endif
        
        return URL(string: baseURLString)!
    }
    
    var sampleData: Data {
        return Data()
    }
}



