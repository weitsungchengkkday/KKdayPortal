//
//  SnackBarMovable.swift
//  KKdayPortal
//
//  Created by KKday on 2021/6/27.
//  Copyright © 2021 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit

protocol SnackBarMovable {
    var displacement: CGFloat { get }
    var indexOfRootViewControllerViewSubView: Int { get }
}
