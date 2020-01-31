//
//  StringExtension.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/3.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import SwiftSoup

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
    
    func htmlStringTransferToNSAttributedString() -> NSAttributedString? {
        let data = self.data(using: .utf8)
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        do {
            guard let data = data else {
                return nil
            }
            let attributedString = try NSAttributedString(data: data, options: options, documentAttributes: nil)
            return attributedString
            
        } catch {
            print("❌ Data to AttributedString \(error)")
        }
        
        return nil
    }
    
}

// SwiftSoup
// HTML DOM Tree parsing
extension String {
    
    // switch htmlString which use self-closing tag to normal format
    // because WKwebView & UITextView can't handle htmlString without closing tag (e.g. </a>, </iframe>)
    func switchSelfClosingTagToNormalClosingTag() -> String? {
        
        do {
            let doc: Document = try SwiftSoup.parseBodyFragment(self)
            
            do {
                let htmlString = try doc.html()
                return htmlString
            }
            
        } catch {
            print("❌ SwiftSoup, Parsing HTML String Error: \(error)")
        }
        return nil
    }
}
