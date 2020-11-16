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
import DolphinHTTP

protocol RepositoryManageable {
    
    associatedtype User
    associatedtype Item
    static var baseURL: URL { get }
    
    func getItem(generalItemType: GeneralItemType) -> Single<Item>
    
    func loadItem(generalItemType: GeneralItemType, completion: @escaping (Result<Item, DolphinHTTP.HTTPError>) -> Void)

}
