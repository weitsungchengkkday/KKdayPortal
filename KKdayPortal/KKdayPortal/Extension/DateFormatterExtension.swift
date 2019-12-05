//
//  DateFormatterExtension.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/3.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation

extension DateFormatter {
    
  static let iso8601Full: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY-MM-DD'T'hh:mm:ssZZZ"
    dateFormatter.calendar = Calendar(identifier: .iso8601)
    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
    return dateFormatter
  }()
    
    static let yyyyMMdd: DateFormatter = {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd"
      dateFormatter.calendar = Calendar(identifier: .iso8601)
      dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
      dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
      return dateFormatter
    }()
}
