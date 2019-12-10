//
//  RepositoryManageable.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/6.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol RepositoryManageable {
    
    associatedtype User
    associatedtype Item
    static var baseURL: URL { get }
    
    // 👤 Authentication
    func login(account: String, password: String) -> Single<User>
    func renewToken() -> Single<User?>
    func logout() -> Single<User>
     
    // 🎛 CRUD
    
    func getItem(generalItemType: GeneralItemType) -> Single<Item>
    func create()
    func update(item: Item)
    func delete(item: Item)
}
