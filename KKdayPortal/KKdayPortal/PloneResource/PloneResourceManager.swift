//
//  PloneResourceManager.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/2/20.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import UIKit

final class UserResourceManager {
    
    static let shared: UserResourceManager = UserResourceManager()
    
    var resourceType: UserResourceType {
        get
        {
            let type: UserResourceType = StorageManager.shared.loadObject(for: .ploneResourceType) ?? .custom
            return type
        }
        
        set
        {
           let type: UserResourceType = newValue
           StorageManager.shared.saveObject(for: .ploneResourceType, value: type)
        }
        
    }
    
    lazy var currentLogoImage: UIImage = {
        let image: UIImage
        switch resourceType {
        case .kkMember:
            image = #imageLiteral(resourceName: "icKKdayLogo")
        case .custom:
            image = #imageLiteral(resourceName: "icApplicationItem")
        }
        
        return image
    }()
    
    private init() {}
}
