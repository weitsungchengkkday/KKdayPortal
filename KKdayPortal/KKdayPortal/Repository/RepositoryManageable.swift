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
    
    func getItem() -> PrimitiveSequence<SingleTrait, R>
    func create(item: R)
    func update(item: R)
    func delete(item: R)
}

//
//protocol AuthService where Self: UIViewController {
//
//    func login() -> String
//    func renewToken(token: String) -> String
//    func logout(token: String)
//}
