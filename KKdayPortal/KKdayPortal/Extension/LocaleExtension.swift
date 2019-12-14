//
//  LocaleExtension.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/13.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation

extension Locale {
    
    // MARK: - For date converter
    
    public static var enUSPosix: Locale {
        return Locale(identifier: "en_US_POSIX")
    }
    
    // MARK: - All supported Locale
    
    static var tw: Locale {
        return Locale(identifier: "zh_Hant_TW")
    }
    
    static var us: Locale {
        return Locale(identifier: "en_US")
    }
    
    static var jp: Locale {
        return Locale(identifier: "ja_JP")
    }
    
    static var cn: Locale {
        return Locale(identifier: "zh_Hans_CN")
    }
    
    static var kr: Locale {
        return Locale(identifier: "ko_KR")
    }
    
    static var zhHK: Locale {
        return Locale(identifier: "zh_Hant_HK")
    }
    
    static var th: Locale {
        return Locale(identifier: "th_TH")
    }
    
    static var vn: Locale {
        return Locale(identifier: "vi_VN")
    }
    
    static var sg: Locale {
        return Locale(identifier: "en_SG")
    }
    
    static var my: Locale {
        return Locale(identifier: "ms_MY")
    }
    
    static var ph: Locale {
        return Locale(identifier: "fil_PH")
    }
    
    static var id: Locale {
        return Locale(identifier: "id_ID")
    }
    
}
