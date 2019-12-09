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

enum ModelLoader {
    
    struct PortalItem: ModelLoadable {
        
        func getItem<U: RepositoryManageable>(repo: U) -> PrimitiveSequence<SingleTrait, U.R> {
            
            return repo.getItem()
        }
        
        
    }
}
