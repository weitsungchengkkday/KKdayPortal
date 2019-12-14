//
//  Region.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/13.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation

public enum Region: String {
    case tw = "tw"
    case cn = "cn"
    case hk = "hk"
    case jp = "jp"
    case kr = "kr"
    case sg = "sg"
    case my = "my"
    case th = "th"
    case vn = "vn"
    case ph = "ph"
    case id = "id"
    case en = "en"

}

extension Region {
    
    public static var systemPreferedRegion: Region {
        
        guard let systemRegionCode: String = Locale.current.regionCode,
            let region = Region(rawValue: systemRegionCode.lowercased()) else {
                return Region.en
        }
        return region
    }
    
    public static var isUserSelectedRegion: Bool {
        
        get {
            let isSelected: Bool = StorageManager.shared.load(for: .regionIsSelected) ?? false
            return isSelected
        }
        
        set {
            StorageManager.shared.save(for: .regionIsSelected, value: newValue)
        }
    }
    
    public static var userSelectedRegion: Region? {
        
        get {
            guard let rawValue: String = StorageManager.shared.load(for: .selectedRegionKey) else {
                return nil
            }
            
            return Region(rawValue: rawValue)
        }
        
        set {
            return StorageManager.shared.save(for: .selectedLanguageKey, value: newValue)
        }
    }
    
    // Get current Region
    public static var current: Region {
        
        if isUserSelectedRegion,
            let region: Region = userSelectedRegion {
            return region
        } else {
            return systemPreferedRegion
        }
    }
    
    public var locale: Locale {
        
        switch self {
        case .tw:
            return Locale.tw
            
        case .cn:
            return Locale.cn
            
        case .hk:
            return Locale.zhHK
            
        case .jp:
            return Locale.jp
            
        case .kr:
            return Locale.kr
            
        case .sg:
            return Locale.sg
            
        case .my:
            return Locale.my
            
        case .th:
            return Locale.th
            
        case .vn:
            return Locale.vn
            
        case .ph:
            return Locale.ph
            
        case .id:
            return Locale.id
            
        case .en:
            return Locale.us
        }
    }
    
    
}

