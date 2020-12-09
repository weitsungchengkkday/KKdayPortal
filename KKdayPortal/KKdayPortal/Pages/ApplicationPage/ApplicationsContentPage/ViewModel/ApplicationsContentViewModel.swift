//
//  ApplicationsContentViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/18.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation

final class ApplicationsContentViewModel {
    
    typealias PortalContent = GeneralItem
    
    private(set) var applicationTitle: String = ""
    
    var source: URL
    var generalItem: PortalContent?
    
    init(source: URL) {
        self.source = source
    }
    
    
}
