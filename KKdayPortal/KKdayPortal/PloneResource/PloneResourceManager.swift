//
//  PloneResourceManager.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/2/20.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import UIKit

final class PloneResourceManager {
    
    static let shared: PloneResourceManager = PloneResourceManager()
    
    var resourceType: PloneResourceType {
        get
        {
            let type: PloneResourceType = StorageManager.shared.loadObject(for: .ploneResourceType) ?? .none
            return type
        }
        
        set
        {
           let type: PloneResourceType = newValue
           StorageManager.shared.saveObject(for: .ploneResourceType, value: type)
        }
        
    }
    
    lazy var currentLogoImage: UIImage = {
        let image: UIImage
        switch resourceType {
        case .kkMember:
            image = #imageLiteral(resourceName: "icKKdayLogo")
        case .normal:
            image = #imageLiteral(resourceName: "icApplicationItem")
        case .none:
            image = #imageLiteral(resourceName: "icPicture")
        }
        
        return image
    }()
    
    private init() {}
}
