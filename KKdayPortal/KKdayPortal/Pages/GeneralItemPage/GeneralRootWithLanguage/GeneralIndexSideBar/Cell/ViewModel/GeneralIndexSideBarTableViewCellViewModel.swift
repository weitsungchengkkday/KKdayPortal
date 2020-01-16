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

final class GeneralIndexSideBarTableViewCellViewModel {
    
    let generalItem: GeneralItem
    
    init(generalItem: GeneralItem) {
        self.generalItem = generalItem
    }
}

extension GeneralIndexSideBarTableViewCellViewModel: IdentifiableType, Equatable {
    
    typealias Identity = String
    
    var identity: String {
        
        if let UID = generalItem.UID {
            return UID
        } else {
            fatalError("No UID exist")
        }
    }
    
    static func == (lhs: GeneralIndexSideBarTableViewCellViewModel, rhs: GeneralIndexSideBarTableViewCellViewModel) -> Bool {
        return lhs.identity == rhs.identity
    }
}
