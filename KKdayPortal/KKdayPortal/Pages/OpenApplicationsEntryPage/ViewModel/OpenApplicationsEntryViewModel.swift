//
//  OpenApplicationsEntryViewModel.swift
//  KKdayPortal
//
//  Created by KKday on 2021/1/18.
//  Copyright © 2021 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation

final class OpenApplicationsEntryViewModel {
    
    var updateContent: () -> Void = {}
    
    init() {}
    
    func loadPortalData() {
        updateContent()
    }
}
