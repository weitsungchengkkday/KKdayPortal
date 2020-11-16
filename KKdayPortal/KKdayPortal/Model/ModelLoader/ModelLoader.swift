//
//  ModelLoader.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/7.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import DolphinHTTP

enum ModelLoader {
    
    struct PortalLoader: ModelLoadable {
        
        typealias Repository = WebPloneRepository
        
        func loadItem(source: URL, type: GeneralItemType, completion: @escaping (Result<GeneralItem, DolphinHTTP.HTTPError>) -> Void) {
            return Repository(source: source).loadItem(generalItemType: type, completion: completion)
        }
        
        func getItem(source: URL, type: GeneralItemType) -> Single<Repository.Item> {
            return Repository(source: source).getItem(generalItemType: type)
        }
        
        
    }
}
