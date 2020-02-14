//
//  GeneralRootWithLanguageFoldersHeaderTableViewCellViewModel.swift
//  KKdayPortal-Sit
//
//  Created by WEI-TSUNG CHENG on 2020/1/17.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

final class GeneralRootWithLanguageFoldersHeaderTableViewCellViewModel {
    
    let generalItem: GeneralItem
    var isOpen: Bool
    
    init(generalItem: GeneralItem, isOpen: Bool) {
        self.generalItem = generalItem
        self.isOpen = isOpen
    }

}

