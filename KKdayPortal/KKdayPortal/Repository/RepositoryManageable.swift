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
    
    associatedtype R
    static var baseURL: URL { get }
    
    func getItem() -> Single<R>
    func create()
    func update(item: R)
    func delete(item: R)
}
