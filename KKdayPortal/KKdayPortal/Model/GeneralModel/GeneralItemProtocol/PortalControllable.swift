//
//  PortalControllable.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/8.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation

protocol PortalControllable {
    associatedtype PortalContent
    
    var generalItem: PortalContent? { get set }
    func getPortalData()
}
