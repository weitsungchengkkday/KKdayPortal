//
//  GeneralIndexSideBarTableViewCellViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/1/15.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

final class GeneralIndexSideBarNormalTableViewCellViewModel {
    
    let generalItem: GeneralItem
    
    init(generalItem: GeneralItem) {
        self.generalItem = generalItem
    }
}
