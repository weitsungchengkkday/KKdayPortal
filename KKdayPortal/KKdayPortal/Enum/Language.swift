//
//  Language.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/12.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation

public enum Language: String, CaseIterable {
    
    case en = "en"
    case zhTW = "zh-tw"
    case zhHK = "zh-hk"
    case zhCN = "zh-cn"
    case ja = "ja"
    case ko = "ko"
    case th = "th"
    case vi = "vi"
}

extension Language {
    // Get system prefered language (system + APP available)
    public static var systemPreferedLanguage: Language {
        
        let availableLanguages: [String] = ["en", "zh-Hans", "zh-Hant-TW", "zh-Hant-HK"]
        
        guard let bestMatchedLanguage: String = Bundle.preferredLocalizations(from: availableLanguages).first else {
            return Language.en
        }
        
        guard let firstPart: String.SubSequence = bestMatchedLanguage.split(separator: "-").first else {
            return Language.en
        }
        
        let languageCode: String = String(firstPart)
        
        switch languageCode {
        case "zh":
            switch bestMatchedLanguage {
            case "zh-Hans":
                return .zhCN
            case "zh-Hant-TW":
                return .zhTW
            case "zh-Hant-HK":
                return .zhHK
            default:
                return .zhTW
            }
        default:
            guard let language = Language(rawValue: languageCode) else {
                return Language.en
            }
            return language
        }
        
    }
    
    public static var isUserSelectedLanguage: Bool {
        get {
            let isSelected: Bool = StorageManager.shared.load(for: .languageIsSelected) ?? false
            return isSelected
        }
        set {
            return StorageManager.shared.save(for: .languageIsSelected, value: newValue)
        }
    }
    
    public static var userSelectedLanguage: Language? {
        get {
            guard let rawValue: String = StorageManager.shared.load(for: .selectedLanguageKey) else {
                return nil
            }
            
            return Language(rawValue: rawValue)
        }
        
        set {
            guard let value = newValue?.rawValue else {
                return
            }
            StorageManager.shared.save(for: .selectedLanguageKey, value: value)
        }
    }
    
    // Get current langauge
    public static var current: Language {
        
        if isUserSelectedLanguage,
            let language: Language = userSelectedLanguage {
            return language
        } else {
            return systemPreferedLanguage
        }
    }
    
}


extension Language {
    
    public var name: String {
        switch self {
        case .en:
            return "English"
            
        case .zhTW:
            return "繁體中文 (台灣)"
            
        case .zhHK:
            return "繁體中文 (香港)"
            
        case .zhCN:
            return "简体中文"
            
        case .ja:
            return "日本語"
            
        case .ko:
            return "한국어"
            
        case .th:
            return "ภาษาไทย"
            
        case .vi:
            return "Tiếng Việt"
            
        }
    }
}

extension Language {
    
    private var bundleName: String {
        
        switch self {
        case .en:
            return "en"
        case .zhTW:
            return "zh-Hant"
        case .zhHK:
            return "zh-HK"
        case .zhCN:
            return "zh-Hans"
        case .ja:
            return "ja"
        case .ko:
            return "ko"
        case .th:
            return "th"
        case .vi:
            return "vi"
        }
    }
    
    private var languageBundle: Bundle? {
        guard let path = Bundle.main.path(forResource: bundleName, ofType: "lproj") else {
            return nil
        }
        
        return Bundle(path: path)
    }
    
    public func localizeForLanguage(key: String, defaultValue: String = "", storyboardName: String = "", comment: String) -> String {
        
        guard let bundle = languageBundle else {
            return defaultValue
        }
        
        return bundle.localizedString(forKey: key, value: defaultValue, table: storyboardName)
    }
}

extension Language {
    
    // IdentifiableType identity
    public var identity: String {
        switch self {
        case .en:
            return "en"
        case .zhTW:
            return "zh-tw"
        case .zhHK:
            return "zh-hk"
        case .zhCN:
            return "zh-cn"
        case .ja:
            return "ja"
        case .ko:
            return "ko"
        case .th:
            return "th"
        case .vi:
            return "vi"
        }
    }
    
    // only use on Plone Portal
    public var portalLang: String? {
        switch self {
        case .en:
            return "en-us"
        case .zhTW:
            return "zh-tw"
        default:
            return nil
        }
    }
}
