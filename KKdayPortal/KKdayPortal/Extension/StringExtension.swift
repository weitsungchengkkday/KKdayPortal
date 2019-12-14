//
//  StringExtension.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/3.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation

extension String {

    func localize(_ comment: String = "", defaultValue: String = "") -> String {
        return LanguageManager.shared.currentLanguage.localizeForLanguage(key: self, defaultValue: defaultValue, storyboardName: "", comment: comment)
    }
    
    /**
     String (Dateformat YYYY-MM-DD'T'hh:mm:ssTZD (e.g. )) convert to Date
     
     Dateformat YYYY-MM-DD'T'hh:mm:ssTZD can't be used in Swift 5, so it need to remove last ":" for confirm Dateformat YYYY-MM-DD'T'hh:mm:ssZZZ
     */
    func removeLastColon() -> String {
        var string = self
        if let i = string.lastIndex(of: ":") {
            string.remove(at: i)
        }
        return self
    }
    
    func customDateFormatterToDate(formatter: DateFormatter) -> Date? {
        return formatter.date(from: self)
    }
    
    func toDate(_ format: String, locale: Locale, timeZone: TimeZone = TimeZone.current, calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)) -> Date? {
        
        let dateFormater = DateFormatter()
        dateFormater.locale = locale
        dateFormater.dateFormat = format
        dateFormater.timeZone = timeZone
        dateFormater.calendar = calendar
        
        return dateFormater.date(from: self)
    }
}
