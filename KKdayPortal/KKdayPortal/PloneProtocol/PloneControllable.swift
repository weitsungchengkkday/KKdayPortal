//
//  PloneControllable.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/28.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol PloneControllable {
    associatedtype PloneContent
    var ploneItem: PloneContent? { get set }
    func getPloneData()
}


