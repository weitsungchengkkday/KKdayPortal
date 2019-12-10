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
    
    struct PortalLoader: ModelLoadable {
        
        typealias Repository = WebPloneRepository
        
        func login(account: String, password: String) -> Single<Repository.User> {
            return Repository().login(account: account, password: password)
        }
        
        func renewToken() -> Single<Repository.User?> {
            return Repository().renewToken()
        }
        
        func logout() -> Single<Repository.User> {
            return Repository().logout()
        }
        
        func getItem(source: URL, type: GeneralItemType) -> Single<Repository.Item> {
            return Repository(source: source).getItem(generalItemType: type)
        }
    }
}
