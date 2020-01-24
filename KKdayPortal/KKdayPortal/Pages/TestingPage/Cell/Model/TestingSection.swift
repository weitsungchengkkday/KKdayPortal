//
//  TestingSection.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/1/21.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import RxDataSources

struct TestingSection {
    let header: String
    var items: [Item]
}

extension TestingSection: AnimatableSectionModelType {
    
    typealias Item = TestingTableViewCellViewModel
    var identity: String {
        return header
    }
    
    init(original: Self, items: [Self.Item]) {
        self = original
        self.items = items
    }
    
}
