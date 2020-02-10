//
//  WebCacheCleaner.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/2/10.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import WebKit

final class WebCacheCleaner {
    
    static func clean() {
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
           
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                print("🧹WebCacheCleaner Record \(record) deleted")
            }
        }
    }
}
