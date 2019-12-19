//
//  WKNavigationTypeExtension.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/19.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import WebKit

extension WKNavigationType: CustomStringConvertible {
    
    public var description: String {
        switch self {
           case .linkActivated:
               return "linkActivated"
           case .formSubmitted:
               return "formSubmitted"
           case .backForward:
              return "backForward"
           case .reload:
              return "reload"
           case .formResubmitted:
              return "formResubmitted"
           case .other:
             return "other"
           @unknown default:
             return  "unknown"
        }
    }
}
