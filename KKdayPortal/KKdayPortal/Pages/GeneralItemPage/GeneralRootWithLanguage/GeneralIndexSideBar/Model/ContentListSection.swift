//
//  ContentListSection.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/1/15.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import RxDataSources

struct ContentListSection {
    let header: String
    var items: [Item]
    var isOpen: Bool
}

extension ContentListSection: AnimatableSectionModelType  {
    
    typealias Item = GeneralIndexSideBarTableViewCellViewModel
    var identity: String {
        return header
    }
    
    init(original: Self, items: [Self.Item]) {
        self = original
        self.items = items
    }
}


