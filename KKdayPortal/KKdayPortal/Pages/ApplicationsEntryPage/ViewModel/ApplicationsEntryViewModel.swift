//
//  ApplicationsEntryViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/18.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation

final class ApplicationsEntryViewModel {
    
    var updateContent: () -> Void = {}
    
    init() {}
    
    func loadPortalData() {
        updateContent()
    }
    
}
