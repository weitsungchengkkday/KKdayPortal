//
//  PloneResourceManager.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/2/20.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation

final class PloneResourceManager {
    
    static let shared: PloneResourceManager = PloneResourceManager()
    
    var resourceType: PloneResourceType<URL> {
        get
        {
            let type: PloneResourceType<URL> = StorageManager.shared.loadObject(for: .ploneResourceType) ?? .none
            return type
        }
        
        set
        {
           let type: PloneResourceType<URL> = newValue
           StorageManager.shared.saveObject(for: .ploneResourceType, value: type)
        }
        
    }
    
    private init() {}
}
