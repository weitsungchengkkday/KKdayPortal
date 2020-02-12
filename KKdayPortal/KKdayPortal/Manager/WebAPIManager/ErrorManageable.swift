//
//  ErrorManageable.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/2/12.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation

protocol ErrorManageable: AnyObject {
    func handle(error: Error)
}
