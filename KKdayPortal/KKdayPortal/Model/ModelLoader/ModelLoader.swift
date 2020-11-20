//
//  ModelLoader.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/7.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import DolphinHTTP

enum ModelLoader {
    
    struct PortalLoader {
        
        typealias Repository = WebPloneRepository
        
        func loadItem(source: URL, type: GeneralItemType, completion: @escaping (Result<GeneralItem, HTTPError>) -> Void) {
            return Repository(source: source).loadItem(generalItemType: type, completion: completion)
        }

    }
}
